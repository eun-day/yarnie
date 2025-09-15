import 'package:drift/drift.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/model/session_status.dart';
import 'connection.dart';

part 'app_db.g.dart';   // <- 코드 생성 파일 연결

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get needleType => text().nullable()();
  TextColumn get needleSize => text().nullable()();
  TextColumn get lotNumber => text().nullable()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}


class WorkSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()();              // FK: Projects.id
  IntColumn get startedAt => integer()();              // epoch ms
  IntColumn get stoppedAt => integer().nullable()();   // 완결 시각
  IntColumn get elapsedMs => integer().withDefault(const Constant(0))();
  IntColumn get lastStartedAt => integer().nullable()();
  TextColumn get label => text().nullable()();
  TextColumn get memo => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer().nullable()();

  // ✅ status: 0=paused, 1=running, 2=stopped (enum 인덱스 저장)
  IntColumn get status =>
      intEnum<SessionStatus>()
          .withDefault(Constant(SessionStatus.running.index))();
}

@DriftDatabase(tables: [Projects, WorkSessions])
class AppDb extends _$AppDb {
  AppDb() : super(openConnection());
  @override int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
  );

  Future<int> createProject({
    required String name,
    String? category,
    String? needleType,
    String? needleSize,
    String? lotNumber,
    String? memo,
  }) {
    return into(projects).insert(ProjectsCompanion.insert(
      name: name,
      category: Value(category),
      needleType: Value(needleType),
      needleSize: Value(needleSize),
      lotNumber: Value(lotNumber),
      memo: Value(memo),
    ));
  }

  Future<bool> updateProject(ProjectsCompanion entity) {
    final now = DateTime.now().toUtc();
    return update(projects).replace(entity.copyWith(updatedAt: Value(now)));
  }

  Stream<List<Project>> watchAll() =>
      (select(projects)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Stream<Project> watchProject(int id) =>
      (select(projects)..where((t) => t.id.equals(id))).watchSingle();

    // 공통: 활성 세션 조회 (RUNNING/PAUSED)
  Future<WorkSession?> getActiveSession(int projectId) {
    return (select(workSessions)
          ..where((t) =>
              t.projectId.equals(projectId) &
              t.status.isIn([SessionStatus.running.index, SessionStatus.paused.index]))
          ..limit(1))
        .getSingleOrNull();
  }

  // 활성 세션 삭제 (RUNNING/PAUSED 모두 대상)
  Future<void> discardActiveSession({required int projectId}) async {
    await (delete(workSessions)
          ..where((t) =>
              t.projectId.equals(projectId) &
              t.status.isIn([SessionStatus.running.index, SessionStatus.paused.index])))
        .go();
  }


  // ────────────────────────────────────────────────────────────────────────────
  // 1) START: 활성 세션이 없어야 새로 시작
  Future<int> startSession({
    required int projectId,
    String? label,
    String? memo,
  }) async {
    return transaction(() async {
      final active = await getActiveSession(projectId);
      if (active != null) {
        throw StateError('활성 세션이 이미 존재합니다.');
      }

      final nowMs = DateTime.now().millisecondsSinceEpoch;

      return await into(workSessions).insert(WorkSessionsCompanion.insert(
        projectId: projectId,
        startedAt: nowMs,
        stoppedAt: const Value.absent(),
        elapsedMs: const Value(0),
        lastStartedAt: Value(nowMs),
        label: Value(label),
        memo: Value(memo),
        createdAt: nowMs,
        updatedAt: const Value.absent(),
        status: Value(SessionStatus.running),
      ));
    });
  }

  // 2) PAUSE: RUNNING -> PAUSED
  // Elapsed Time을 초 단위로 리턴
  Future<int> pauseSession({
    required int projectId,
  }) async {
    return transaction(() async {
      final s = await getActiveSession(projectId);
      if (s == null || s.status != SessionStatus.running) {
        throw StateError('RUNNING 세션이 없습니다.');
      }

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final addMs = (nowMs - s.lastStartedAt!).clamp(0, 1 << 31);
      final newElapsedMs = s.elapsedMs + addMs;
      
      await (update(workSessions)..where((t) => t.id.equals(s.id))).write(
        WorkSessionsCompanion(
          elapsedMs: Value(newElapsedMs),
          lastStartedAt: const Value(null),
          updatedAt: Value(nowMs),
          status: Value(SessionStatus.paused)
        ),
      );

      return newElapsedMs.toSec();
    });
  }

  // 3) RESUME: PAUSED -> RUNNING 
  Future<void> resumeSession({
    required int projectId,
  }) async {
    await transaction(() async {
      final s = await getActiveSession(projectId);
      if (s == null || s.status != SessionStatus.paused) {
        throw StateError('PAUSED 세션이 없습니다.');
      }

      final nowMs = DateTime.now().millisecondsSinceEpoch;

      await (update(workSessions)..where((t) => t.id.equals(s.id))).write(
        WorkSessionsCompanion(
          lastStartedAt: Value(nowMs),
          updatedAt: Value(nowMs),
          status: Value(SessionStatus.running)
        ),
      );
    });
  }

  // 4) STOP: RUNNING이면 먼저 경과분 합산 후 종료, PAUSED면 그대로 종료
  Future<void> stopSession({
    required int projectId,
    String? label, // 선택: 전달 시 세션 라벨 업데이트
    String? memo,  // 선택: 전달 시 세션 메모 업데이트
  }) async {
    await transaction(() async {
      final s = await getActiveSession(projectId);
      if (s == null) throw StateError('활성 세션이 없습니다.');

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      int newElapsed = s.elapsedMs;
      if (s.status == SessionStatus.running && s.lastStartedAt != null) {
        final add = nowMs - s.lastStartedAt!;
        if (add > 0) newElapsed += add;
      }

      // 전달된 값만 업데이트; 미전달(null)이면 기존 값 유지
      final Value<String?> labelValue = (label == null) ? const Value.absent() : Value<String?>(label);
      final Value<String?> memoValue = (memo == null) ? const Value.absent() : Value<String?>(memo);

      await (update(workSessions)..where((t) => t.id.equals(s.id))).write(
        WorkSessionsCompanion(
          elapsedMs: Value(newElapsed),
          lastStartedAt: const Value(null),
          stoppedAt: Value(nowMs),
          updatedAt: Value(nowMs),
          status: Value(SessionStatus.stopped),
          label: labelValue,
          memo: memoValue,
        ),
      );
    });
  }

  // 5) 라벨/메모 업데이트(편집 팝업에서)
  Future<void> updateSessionLabelMemo({
    required int sessionId,
    String? label,
    String? memo,
    required int nowMs,
  }) async {
    await (update(workSessions)..where((t) => t.id.equals(sessionId))).write(
      WorkSessionsCompanion(
        label: Value(label),
        memo: Value(memo),
        updatedAt: Value(nowMs),
      ),
    );
  }

  // 6) 프로젝트 총 누적 (진행 중/일시정지 제외 = STOPPED만 합산)
  Future<int> totalElapsedSec({
    required int projectId,
  }) async {
    final row = await customSelect(
      'SELECT COALESCE(SUM(elapsed_ms / 1000), 0) AS t '
      'FROM work_sessions '
      'WHERE project_id = ?1 AND status = ?2;',
      variables: [
        Variable.withInt(projectId),
        Variable.withInt(SessionStatus.stopped.index), // 2
      ],
      readsFrom: {workSessions},
    ).getSingleOrNull();

    return (row?.data['t'] as int?) ?? 0;
  }

  Future<Duration> totalElapsedDuration({required int projectId}) async {
    // 1) 종료된 세션 합계 (stopped만)
    final totalDone = await totalElapsedSec(projectId: projectId);

    // 2) 현재 활성 세션 (running/paused)
    final active = await getActiveSession(projectId);

    int viewSec = totalDone;

    if (active != null) {
      final base = (active.elapsedMs).toSec();

      // 진행 중이면 lastStartedAt부터 지금까지 더해줌
      final add =
          (active.status == SessionStatus.running && active.lastStartedAt != null)
              ? (DateTime.now().millisecondsSinceEpoch - active.lastStartedAt!)
                  .clamp(0, 1 << 30)
                  .toSec()
              : 0;

      viewSec += base + add;
    }

    return Duration(seconds: viewSec);
  }

  // 공통: 상태 집합으로 조회 (최신 시작순)
  Stream<List<WorkSession>> watchByStatuses(
      int projectId, List<SessionStatus> statuses) {
    final q = (select(workSessions)
          ..where((t) =>
              t.projectId.equals(projectId) &
              t.status.isInValues(statuses)) // enum 직접 비교
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]));
    return q.watch();
  }

  Future<List<WorkSession>> getByStatuses(
      int projectId, List<SessionStatus> statuses,
      {int limit = 50, int offset = 0}) {
    final q = (select(workSessions)
          ..where((t) =>
              t.projectId.equals(projectId) &
              t.status.isInValues(statuses))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(limit, offset: offset));
    return q.get();
  }

  // 종료 세션 watch
  Stream<List<WorkSession>> watchCompletedSessions(int projectId) {
    return watchByStatuses(projectId, const [SessionStatus.stopped]);
  }

  // 종료 세션 가져오기
  Future<List<WorkSession>> getCompletedSessions(int projectId,
      {int limit = 50, int offset = 0}) {
    return getByStatuses(projectId, const [SessionStatus.stopped],
        limit: limit, offset: offset);
  }
}
