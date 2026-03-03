import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/model/session_status.dart';
import 'package:yarnie/model/counter_data.dart';
import 'connection.dart';

part 'app_db.g.dart'; // <- 코드 생성 파일 연결

// ────────────────────────────────────────────────────────────────────────────
// 커스텀 예외 정의
// ────────────────────────────────────────────────────────────────────────────

/// 데이터베이스 작업 중 발생하는 예외의 기본 클래스
class DatabaseException implements Exception {
  final String message;
  final Object? cause;

  DatabaseException(this.message, [this.cause]);

  @override
  String toString() =>
      'DatabaseException: $message${cause != null ? ' (원인: $cause)' : ''}';
}

/// 외래키 제약 위반 예외
class ForeignKeyConstraintException extends DatabaseException {
  ForeignKeyConstraintException(String message, [Object? cause])
    : super(message, cause);

  @override
  String toString() => 'ForeignKeyConstraintException: $message';
}

/// 고유성 제약 위반 예외
class UniqueConstraintException extends DatabaseException {
  UniqueConstraintException(String message, [Object? cause])
    : super(message, cause);

  @override
  String toString() => 'UniqueConstraintException: $message';
}

/// 데이터 무결성 위반 예외
class DataIntegrityException extends DatabaseException {
  DataIntegrityException(String message, [Object? cause])
    : super(message, cause);

  @override
  String toString() => 'DataIntegrityException: $message';
}

/// 레코드를 찾을 수 없음 예외
class RecordNotFoundException extends DatabaseException {
  RecordNotFoundException(String message, [Object? cause])
    : super(message, cause);

  @override
  String toString() => 'RecordNotFoundException: $message';
}

// ────────────────────────────────────────────────────────────────────────────
// Enum 정의
// ────────────────────────────────────────────────────────────────────────────

/// SectionCounter의 링크 상태
enum LinkState {
  linked, // MainCounter와 연동 중
  unlinked, // 연동 해제됨
}

/// Session 상태
enum SessionStatus2 {
  running, // 진행 중
  paused, // 일시정지
}

/// SessionSegment 분할 이유
enum SegmentReason {
  pause, // 일시정지
  resume, // 재시작
  modeChange, // Row/Free 모드 변경
  partChange, // Part 전환
  midnightSplit, // 자정 교차
}

/// SectionRun 상태
enum RunState {
  scheduled, // 예정
  active, // 진행 중
  completed, // 완료
  skipped, // 건너뜀
}

// ────────────────────────────────────────────────────────────────────────────
// 테이블 정의
// ────────────────────────────────────────────────────────────────────────────

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  // category 필드 삭제 (태그 시스템으로 대체)

  TextColumn get needleType => text().nullable()();
  TextColumn get needleSize => text().nullable()();
  TextColumn get lotNumber => text().nullable()();
  TextColumn get memo => text().nullable()();

  // 새로 추가
  IntColumn get currentPartId =>
      integer().nullable()(); // FK는 애플리케이션 레벨에서 관리 (순환 참조 방지)
  TextColumn get imagePath => text().nullable()(); // 프로젝트 이미지 경로
  TextColumn get tagIds => text().nullable()(); // 태그 ID 배열 (JSON: '[1,2,3]')

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// Part: 프로젝트 내의 작업 구간
@TableIndex(name: 'parts_project_order', columns: {#projectId, #orderIndex})
class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId =>
      integer().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()(); // Part 정렬 순서

  // BuddyCounter 순서 관리
  TextColumn get buddyCounterOrder => text().nullable()();
  // JSON: '[{"type":"stitch","id":1},{"type":"section","id":2},...]'

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// MainCounter: 각 Part의 중심 카운터
@TableIndex(name: 'main_counters_part_id', columns: {#partId})
class MainCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  IntColumn get currentValue => integer().withDefault(const Constant(1))();
  IntColumn get targetValue => integer().nullable()(); // Added targetValue column

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// StitchCounter: 독립적으로 조작 가능한 BuddyCounter
@TableIndex(name: 'stitch_counters_part_id', columns: {#partId})
class StitchCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()(); // 사용자 정의 이름
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  IntColumn get countBy => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// SectionCounter: MainCounter와 연동되는 BuddyCounter
@TableIndex(name: 'section_counters_part_id', columns: {#partId})
@TableIndex(name: 'section_counters_part_link', columns: {#partId, #linkState})
class SectionCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()(); // 사용자 정의 이름
  TextColumn get specJson => text()(); // Section 유형별 설정 (JSON, schemaVer 포함)

  // 링크 관리 (enum으로 향후 확장성 확보)
  TextColumn get linkState =>
      textEnum<LinkState>().withDefault(const Constant('linked'))();
  IntColumn get frozenMainAt => integer().nullable()(); // 언링크 시 고정값

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// SectionRuns: SectionCounter의 구간을 전개한 캐시 테이블
@TableIndex(
  name: 'section_runs_counter_ord',
  columns: {#sectionCounterId, #ord},
)
@TableIndex(
  name: 'section_runs_counter_state',
  columns: {#sectionCounterId, #state},
)
class SectionRuns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sectionCounterId =>
      integer().references(SectionCounters, #id, onDelete: KeyAction.cascade)();

  IntColumn get ord => integer()(); // 순서
  IntColumn get startRow => integer()(); // 시작 행
  IntColumn get rowsTotal => integer()(); // 총 행수
  TextColumn get label => text().nullable()(); // 라벨 (예: "1회차", "색상 변경")

  TextColumn get state =>
      textEnum<RunState>().withDefault(const Constant('scheduled'))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

/// Sessions: Part별 작업 세션
@TableIndex(name: 'sessions_part_id', columns: {#partId})
@TableIndex(name: 'sessions_started_at', columns: {#startedAt})
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get startedAt => dateTime()();

  IntColumn get totalDurationSeconds =>
      integer().withDefault(const Constant(0))();

  IntColumn get status => intEnum<SessionStatus2>().withDefault(
    Constant(SessionStatus2.running.index),
  )();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// SessionSegments: Session 내의 실제 작업 시간 구간
@TableIndex(name: 'session_segments_session_id', columns: {#sessionId})
@TableIndex(
  name: 'session_segments_part_started',
  columns: {#partId, #startedAt},
)
@TableIndex(name: 'session_segments_started_at', columns: {#startedAt})
class SessionSegments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().nullable()();

  // Counter 스냅샷
  IntColumn get startCount => integer().nullable()();
  IntColumn get endCount => integer().nullable()();

  // 분할 이유
  TextColumn get reason => textEnum<SegmentReason>().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}

/// PartNotes: Part별 메모
@TableIndex(
  name: 'part_notes_part_pinned_created',
  columns: {#partId, #isPinned, #createdAt},
)
class PartNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId =>
      integer().references(Parts, #id, onDelete: KeyAction.cascade)();

  TextColumn get content => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// Tags: 사용자 정의 태그
@TableIndex(name: 'tags_name', columns: {#name}, unique: true)
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // 태그 이름 (고유 인덱스로 보장)
  IntColumn get color => integer()(); // Flutter Color 값 (0xFFRRGGBB)

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

// ────────────────────────────────────────────────────────────────────────────
// 기존 테이블 (마이그레이션 후 삭제 예정)
// ────────────────────────────────────────────────────────────────────────────

class WorkSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()(); // FK: Projects.id
  IntColumn get startedAt => integer()(); // epoch ms
  IntColumn get stoppedAt => integer().nullable()(); // 완결 시각
  IntColumn get elapsedMs => integer().withDefault(const Constant(0))();
  IntColumn get lastStartedAt => integer().nullable()();
  TextColumn get label => text().nullable()();
  TextColumn get memo => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer().nullable()();

  // ✅ status: 0=paused, 1=running, 2=stopped (enum 인덱스 저장)
  IntColumn get status => intEnum<SessionStatus>().withDefault(
    Constant(SessionStatus.running.index),
  )();
}

class ProjectCounters extends Table {
  IntColumn get projectId => integer()(); // FK: Projects.id
  IntColumn get mainCounter => integer().withDefault(const Constant(0))();
  IntColumn get mainCountBy => integer().withDefault(const Constant(1))();
  IntColumn get subCounter => integer().nullable()();
  IntColumn get subCountBy => integer().withDefault(const Constant(1))();
  BoolColumn get hasSubCounter =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {projectId};
}

@DriftDatabase(
  tables: [
    Projects,
    Parts,
    MainCounters,
    StitchCounters,
    SectionCounters,
    SectionRuns,
    Sessions,
    SessionSegments,
    PartNotes,
    Tags,
    // 기존 테이블 (마이그레이션 후 삭제 예정)
    WorkSessions,
    ProjectCounters,
  ],
)
class AppDb extends _$AppDb {
  AppDb() : super(openConnection());

  /// 테스트용 생성자
  AppDb.forTesting(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) async => m.createAll());

  // ────────────────────────────────────────────────────────────────────────────
  // 에러 처리 헬퍼 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// Exception을 적절한 DatabaseException으로 변환
  DatabaseException _handleDatabaseException(Object e, String context) {
    final errorMessage = e.toString().toLowerCase();

    // 고유성 제약 위반 감지 (unique보다 먼저 체크)
    if (errorMessage.contains('unique') ||
        errorMessage.contains('duplicate') ||
        errorMessage.contains('already exists')) {
      return UniqueConstraintException('$context: 중복된 값이 존재합니다', e);
    }

    // 외래키 제약 위반 감지
    if (errorMessage.contains('foreign key')) {
      return ForeignKeyConstraintException('$context: 참조하는 레코드가 존재하지 않습니다', e);
    }

    // NOT NULL 제약 위반 감지
    if (errorMessage.contains('not null')) {
      return DataIntegrityException('$context: 필수 값이 누락되었습니다', e);
    }

    // 데이터 무결성 위반 감지 (Too many elements 등)
    if (errorMessage.contains('too many') ||
        errorMessage.contains('bad state')) {
      return DataIntegrityException('$context: 데이터 무결성 위반', e);
    }

    // 일반 제약 위반 감지
    if (errorMessage.contains('constraint')) {
      return DataIntegrityException('$context: 데이터 제약 조건을 위반했습니다', e);
    }

    // 기타 데이터베이스 에러
    return DatabaseException('$context: 데이터베이스 오류가 발생했습니다', e);
  }

  /// Part당 MainCounter가 1개만 존재하는지 검증
  Future<void> _validateSingleMainCounter(int partId) async {
    final mainCounterList = await (select(
      mainCounters,
    )..where((t) => t.partId.equals(partId))).get();

    if (mainCounterList.length > 1) {
      throw DataIntegrityException(
        'Part(ID: $partId)에 MainCounter가 ${mainCounterList.length}개 존재합니다. 1개만 허용됩니다.',
      );
    }
  }

  /// Part당 활성 세션이 1개 이하인지 검증
  Future<void> _validateSingleActiveSession(int partId) async {
    final activeSessions =
        await (select(sessions)..where(
              (t) =>
                  t.partId.equals(partId) &
                  t.status.isIn([
                    SessionStatus2.running.index,
                    SessionStatus2.paused.index,
                  ]),
            ))
            .get();

    if (activeSessions.length > 1) {
      throw DataIntegrityException(
        'Part(ID: $partId)에 활성 세션이 ${activeSessions.length}개 존재합니다. 1개만 허용됩니다.',
      );
    }
  }

  /// Part가 존재하는지 검증
  Future<void> _validatePartExists(int partId) async {
    final part = await getPart(partId);
    if (part == null) {
      throw RecordNotFoundException('Part(ID: $partId)를 찾을 수 없습니다');
    }
  }

  /// Project가 존재하는지 검증
  Future<void> _validateProjectExists(int projectId) async {
    final project = await (select(
      projects,
    )..where((t) => t.id.equals(projectId))).getSingleOrNull();
    if (project == null) {
      throw RecordNotFoundException('Project(ID: $projectId)를 찾을 수 없습니다');
    }
  }

  /// Session이 존재하는지 검증
  Future<void> _validateSessionExists(int sessionId) async {
    final session = await (select(
      sessions,
    )..where((t) => t.id.equals(sessionId))).getSingleOrNull();
    if (session == null) {
      throw RecordNotFoundException('Session(ID: $sessionId)을 찾을 수 없습니다');
    }
  }

  /// Tag가 존재하는지 검증
  Future<void> _validateTagExists(int tagId) async {
    final tag = await getTag(tagId);
    if (tag == null) {
      throw RecordNotFoundException('Tag(ID: $tagId)를 찾을 수 없습니다');
    }
  }

  Future<int> createProject({
    required String name,
    String? needleType,
    String? needleSize,
    String? lotNumber,
    String? memo,
  }) {
    return into(projects).insert(
      ProjectsCompanion.insert(
        name: name,
        needleType: Value(needleType),
        needleSize: Value(needleSize),
        lotNumber: Value(lotNumber),
        memo: Value(memo),
      ),
    );
  }

  Future<bool> updateProject(ProjectsCompanion entity) {
    final now = DateTime.now().toUtc();
    return update(projects).replace(entity.copyWith(updatedAt: Value(now)));
  }

  Stream<List<Project>> watchAll() => (select(
    projects,
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  Stream<Project> watchProject(int id) =>
      (select(projects)..where((t) => t.id.equals(id))).watchSingle();

  // 공통: 활성 세션 조회 (RUNNING/PAUSED)
  Future<WorkSession?> getActiveSession(int projectId) {
    return (select(workSessions)
          ..where(
            (t) =>
                t.projectId.equals(projectId) &
                t.status.isIn([
                  SessionStatus.running.index,
                  SessionStatus.paused.index,
                ]),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  // 활성 세션 삭제 (RUNNING/PAUSED 모두 대상)
  Future<void> discardActiveSession({required int projectId}) async {
    await (delete(workSessions)..where(
          (t) =>
              t.projectId.equals(projectId) &
              t.status.isIn([
                SessionStatus.running.index,
                SessionStatus.paused.index,
              ]),
        ))
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

      return await into(workSessions).insert(
        WorkSessionsCompanion.insert(
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
        ),
      );
    });
  }

  // 2) PAUSE: RUNNING -> PAUSED
  // Elapsed Time을 초 단위로 리턴
  Future<int> pauseSession({required int projectId}) async {
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
          status: Value(SessionStatus.paused),
        ),
      );

      return newElapsedMs.toSec();
    });
  }

  // 3) RESUME: PAUSED -> RUNNING
  Future<void> resumeSession({required int projectId}) async {
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
          status: Value(SessionStatus.running),
        ),
      );
    });
  }

  // 4) STOP: RUNNING이면 먼저 경과분 합산 후 종료, PAUSED면 그대로 종료
  Future<void> stopSession({
    required int projectId,
    String? label, // 선택: 전달 시 세션 라벨 업데이트
    String? memo, // 선택: 전달 시 세션 메모 업데이트
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
      final Value<String?> labelValue = (label == null)
          ? const Value.absent()
          : Value<String?>(label);
      final Value<String?> memoValue = (memo == null)
          ? const Value.absent()
          : Value<String?>(memo);

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

  // 라벨만 업데이트
  Future<void> updateSessionLabel({
    required int sessionId,
    String? label,
    required int nowMs,
  }) async {
    await (update(workSessions)..where((t) => t.id.equals(sessionId))).write(
      WorkSessionsCompanion(label: Value(label), updatedAt: Value(nowMs)),
    );
  }

  // 메모만 업데이트
  Future<void> updateSessionMemo({
    required int sessionId,
    String? memo,
    required int nowMs,
  }) async {
    await (update(workSessions)..where((t) => t.id.equals(sessionId))).write(
      WorkSessionsCompanion(memo: Value(memo), updatedAt: Value(nowMs)),
    );
  }

  // 6) 프로젝트 총 누적 (진행 중/일시정지 제외 = STOPPED만 합산)
  Future<int> totalElapsedSec({required int projectId}) async {
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
          (active.status == SessionStatus.running &&
              active.lastStartedAt != null)
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
    int projectId,
    List<SessionStatus> statuses,
  ) {
    final q = (select(workSessions)
      ..where(
        (t) => t.projectId.equals(projectId) & t.status.isInValues(statuses),
      ) // enum 직접 비교
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]));
    return q.watch();
  }

  Future<List<WorkSession>> getByStatuses(
    int projectId,
    List<SessionStatus> statuses, {
    int limit = 50,
    int offset = 0,
  }) {
    final q = (select(workSessions)
      ..where(
        (t) => t.projectId.equals(projectId) & t.status.isInValues(statuses),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
      ..limit(limit, offset: offset));
    return q.get();
  }

  // 종료 세션 watch
  Stream<List<WorkSession>> watchCompletedSessions(int projectId) {
    return watchByStatuses(projectId, const [SessionStatus.stopped]);
  }

  // 종료 세션 가져오기
  Future<List<WorkSession>> getCompletedSessions(
    int projectId, {
    int limit = 50,
    int offset = 0,
  }) {
    return getByStatuses(
      projectId,
      const [SessionStatus.stopped],
      limit: limit,
      offset: offset,
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Part 관련 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// Part 생성 (MainCounter 자동 생성)
  Future<int> createPart({
    required int projectId,
    required String name,
    int? orderIndex,
  }) async {
    try {
      // Project 존재 여부 검증
      await _validateProjectExists(projectId);

      return await transaction(() async {
        // orderIndex가 없으면 마지막 순서로 설정
        final maxOrder =
            orderIndex ??
            await (selectOnly(parts)
                      ..addColumns([parts.orderIndex.max()])
                      ..where(parts.projectId.equals(projectId)))
                    .map((row) => row.read(parts.orderIndex.max()) ?? -1)
                    .getSingle() +
                1;

        // Part 생성
        final partId = await into(parts).insert(
          PartsCompanion.insert(
            projectId: projectId,
            name: name,
            orderIndex: maxOrder,
            buddyCounterOrder: const Value(null),
          ),
        );

        // MainCounter 자동 생성
        await into(mainCounters).insert(
          MainCountersCompanion.insert(
            partId: partId,
            currentValue: const Value(1),
          ),
        );

        return partId;
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'Part 생성');
    }
  }

  /// Part 조회
  Future<Part?> getPart(int partId) {
    return (select(parts)..where((t) => t.id.equals(partId))).getSingleOrNull();
  }

  /// 프로젝트의 모든 Part 조회 (순서대로)
  Future<List<Part>> getProjectParts(int projectId) {
    return (select(parts)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();
  }

  /// 프로젝트의 모든 Part 조회 (순서대로) - Stream
  Stream<List<Part>> watchProjectParts(int projectId) {
    return (select(parts)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .watch();
  }

  /// Part 업데이트
  Future<bool> updatePart(PartsCompanion entity) {
    final now = DateTime.now().toUtc();
    return update(parts).replace(entity.copyWith(updatedAt: Value(now)));
  }

  /// Part 삭제 (관련 Counter, Session, Note 모두 cascade 삭제됨)
  Future<void> deletePart(int partId) async {
    try {
      // Part 존재 여부 검증
      await _validatePartExists(partId);

      await (delete(parts)..where((t) => t.id.equals(partId))).go();
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'Part 삭제');
    }
  }

  /// Part 순서 변경
  Future<void> reorderParts({
    required int projectId,
    required List<int> partIds,
  }) async {
    return transaction(() async {
      for (var i = 0; i < partIds.length; i++) {
        await (update(parts)..where((t) => t.id.equals(partIds[i]))).write(
          PartsCompanion(
            orderIndex: Value(i),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
      }
    });
  }

  /// BuddyCounter 순서 변경
  /// newOrder: [{"type":"stitch","id":1},{"type":"section","id":2},...]
  Future<void> reorderBuddyCounters({
    required int partId,
    required String newOrderJson,
  }) {
    return (update(parts)..where((t) => t.id.equals(partId))).write(
      PartsCompanion(
        buddyCounterOrder: Value(newOrderJson),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Counter 관련 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// MainCounter 조회
  Future<MainCounter?> getMainCounter(int partId) {
    return (select(
      mainCounters,
    )..where((t) => t.partId.equals(partId))).getSingleOrNull();
  }

  /// MainCounter 업데이트 (currentValue 증감)
  Future<void> updateMainCounter({
    required int partId,
    required int newValue,
  }) async {
    try {
      // Part 존재 여부 검증
      await _validatePartExists(partId);

      // MainCounter 존재 여부 검증
      final mainCounter = await getMainCounter(partId);
      if (mainCounter == null) {
        throw RecordNotFoundException(
          'Part(ID: $partId)의 MainCounter를 찾을 수 없습니다',
        );
      }

      // Part당 MainCounter 1개 검증
      await _validateSingleMainCounter(partId);

      await (update(mainCounters)..where((t) => t.partId.equals(partId))).write(
        MainCountersCompanion(
          currentValue: Value(newValue),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'MainCounter 업데이트');
    }
  }

  /// MainCounter 목표 단수 업데이트
  Future<void> updateMainCounterTarget({
    required int partId,
    required int? newTargetValue,
  }) async {
    try {
      await _validatePartExists(partId);

      await (update(mainCounters)..where((t) => t.partId.equals(partId))).write(
        MainCountersCompanion(
          targetValue: Value(newTargetValue),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    } on DatabaseException {
      rethrow;
    } catch (e) {
      throw _handleDatabaseException(e, 'MainCounter 목표 단수 업데이트');
    }
  }

  /// StitchCounter 생성 (순서 리스트 자동 업데이트 지원)
  Future<int> createStitchCounter({
    required int partId,
    required String name,
    String? newOrderJson,
    int countBy = 1,
  }) async {
    try {
      // Part 존재 여부 검증
      final part = await _validatePartExistsReturnPart(partId);

      return await transaction(() async {
        // StitchCounter 생성
        final counterId = await into(stitchCounters).insert(
          StitchCountersCompanion.insert(
            partId: partId,
            name: name,
            countBy: Value(countBy),
          ),
        );

        // 순서 리스트 업데이트
        String finalOrderJson;
        if (newOrderJson != null) {
          finalOrderJson = newOrderJson;
        } else {
          // 자동 추가 로직
          final List orderList =
              part.buddyCounterOrder != null
                  ? jsonDecode(part.buddyCounterOrder!)
                  : [];
          orderList.add({'type': 'stitch', 'id': counterId});
          finalOrderJson = jsonEncode(orderList);
        }

        await (update(parts)..where((t) => t.id.equals(partId))).write(
          PartsCompanion(
            buddyCounterOrder: Value(finalOrderJson),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

        return counterId;
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'StitchCounter 생성');
    }
  }

  /// StitchCounter 조회
  Future<StitchCounter?> getStitchCounter(int counterId) {
    return (select(
      stitchCounters,
    )..where((t) => t.id.equals(counterId))).getSingleOrNull();
  }

  /// Part의 모든 StitchCounter 조회
  Future<List<StitchCounter>> getPartStitchCounters(int partId) {
    return (select(
      stitchCounters,
    )..where((t) => t.partId.equals(partId))).get();
  }

  /// StitchCounter 업데이트
  Future<void> updateStitchCounter({
    required int counterId,
    int? currentValue,
    int? countBy,
    String? name,
  }) {
    return (update(stitchCounters)..where((t) => t.id.equals(counterId))).write(
      StitchCountersCompanion(
        currentValue: currentValue != null
            ? Value(currentValue)
            : const Value.absent(),
        countBy: countBy != null ? Value(countBy) : const Value.absent(),
        name: name != null ? Value(name) : const Value.absent(),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// StitchCounter 삭제 (순서 리스트 업데이트 포함)
  Future<void> deleteStitchCounter({
    required int counterId,
    required int partId,
    required String newOrderJson,
  }) async {
    return transaction(() async {
      // StitchCounter 삭제
      await (delete(stitchCounters)..where((t) => t.id.equals(counterId))).go();

      // 순서 리스트 업데이트
      await (update(parts)..where((t) => t.id.equals(partId))).write(
        PartsCompanion(
          buddyCounterOrder: Value(newOrderJson),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    });
  }

  /// SectionCounter 생성 (SectionRuns 전개 포함, 순서 리스트 자동 업데이트 지원)
  Future<int> createSectionCounter({
    required int partId,
    required String name,
    required String specJson,
    String? newOrderJson,
  }) async {
    try {
      // Part 존재 여부 검증
      final part = await _validatePartExistsReturnPart(partId);

      return await transaction(() async {
        // SectionCounter 생성
        final counterId = await into(sectionCounters).insert(
          SectionCountersCompanion.insert(
            partId: partId,
            name: name,
            specJson: specJson,
            linkState: const Value(LinkState.linked),
          ),
        );

        // SectionRuns 전개
        await _expandSectionRuns(counterId, specJson);

        // 순서 리스트 업데이트
        String finalOrderJson;
        if (newOrderJson != null) {
          finalOrderJson = newOrderJson;
        } else {
          // 자동 추가 로직
          final List orderList =
              part.buddyCounterOrder != null
                  ? jsonDecode(part.buddyCounterOrder!)
                  : [];
          orderList.add({'type': 'section', 'id': counterId});
          finalOrderJson = jsonEncode(orderList);
        }

        await (update(parts)..where((t) => t.id.equals(partId))).write(
          PartsCompanion(
            buddyCounterOrder: Value(finalOrderJson),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

        return counterId;
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'SectionCounter 생성');
    }
  }

  // 헬퍼: Part 존재 확인 및 Part 객체 반환
  Future<Part> _validatePartExistsReturnPart(int partId) async {
    final part = await getPart(partId);
    if (part == null) {
      throw RecordNotFoundException('Part(ID: $partId)를 찾을 수 없습니다');
    }
    return part;
  }


  /// SectionCounter 조회
  Future<SectionCounter?> getSectionCounter(int counterId) {
    return (select(
      sectionCounters,
    )..where((t) => t.id.equals(counterId))).getSingleOrNull();
  }

  /// Part의 모든 SectionCounter 조회
  Future<List<SectionCounter>> getPartSectionCounters(int partId) {
    return (select(
      sectionCounters,
    )..where((t) => t.partId.equals(partId))).get();
  }

  /// SectionCounter 업데이트 (spec 수정 시 SectionRuns 재전개)
  Future<void> updateSectionCounter({
    required int counterId,
    String? name,
    String? specJson,
  }) async {
    return transaction(() async {
      await (update(
        sectionCounters,
      )..where((t) => t.id.equals(counterId))).write(
        SectionCountersCompanion(
          name: name != null ? Value(name) : const Value.absent(),
          specJson: specJson != null ? Value(specJson) : const Value.absent(),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

      // spec이 변경되면 SectionRuns 재전개
      if (specJson != null) {
        // 기존 runs 삭제
        await (delete(
          sectionRuns,
        )..where((t) => t.sectionCounterId.equals(counterId))).go();

        // 새로 전개
        await _expandSectionRuns(counterId, specJson);
      }
    });
  }

  /// SectionCounter 삭제 (순서 리스트 업데이트 포함)
  Future<void> deleteSectionCounter({
    required int counterId,
    required int partId,
    required String newOrderJson,
  }) async {
    return transaction(() async {
      // SectionCounter 삭제 (SectionRuns도 cascade 삭제됨)
      await (delete(
        sectionCounters,
      )..where((t) => t.id.equals(counterId))).go();

      // 순서 리스트 업데이트
      await (update(parts)..where((t) => t.id.equals(partId))).write(
        PartsCompanion(
          buddyCounterOrder: Value(newOrderJson),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    });
  }

  /// SectionCounter 언링크 (현재 MainCounter 값으로 고정)
  Future<void> unlinkSectionCounter({
    required int counterId,
    required int currentMainValue,
  }) {
    return (update(
      sectionCounters,
    )..where((t) => t.id.equals(counterId))).write(
      SectionCountersCompanion(
        linkState: const Value(LinkState.unlinked),
        frozenMainAt: Value(currentMainValue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// SectionCounter 재링크
  Future<void> relinkSectionCounter(int counterId) {
    return (update(
      sectionCounters,
    )..where((t) => t.id.equals(counterId))).write(
      const SectionCountersCompanion(
        linkState: Value(LinkState.linked),
        frozenMainAt: Value(null),
      ),
    );
  }

  /// SectionRuns 전개 헬퍼 메서드
  Future<void> _expandSectionRuns(int sectionCounterId, String specJson) async {
    final spec = jsonDecode(specJson) as Map<String, dynamic>;
    final type = spec['type'] as String?;

    if (type == 'range') {
      // Range 타입: 단일 구간
      final startRow = spec['startRow'] as int? ?? 0;
      final rowsTotal = spec['rowsTotal'] as int? ?? 0;
      final label = spec['label'] as String?;

      await into(sectionRuns).insert(
        SectionRunsCompanion.insert(
          sectionCounterId: sectionCounterId,
          ord: 0,
          startRow: startRow,
          rowsTotal: rowsTotal,
          label: Value(label),
        ),
      );
    } else if (type == 'repeat') {
      // Repeat 타입: 여러 반복 구간
      final startRow = spec['startRow'] as int? ?? 0;
      final rowsPerRepeat = spec['rowsPerRepeat'] as int? ?? 0;
      final repeatCount = spec['repeatCount'] as int? ?? 0;

      for (var i = 0; i < repeatCount; i++) {
        await into(sectionRuns).insert(
          SectionRunsCompanion.insert(
            sectionCounterId: sectionCounterId,
            ord: i,
            startRow: startRow + (i * rowsPerRepeat),
            rowsTotal: rowsPerRepeat,
            label: Value('${i + 1}회차'),
          ),
        );
      }
    } else if (type == 'interval') {
      // Interval 타입: 일정 간격으로 반복
      final startRow = spec['startRow'] as int? ?? 0;
      final intervalRows = spec['intervalRows'] as int? ?? 0;
      final totalCount = spec['totalCount'] as int? ?? 0;
      final palette = spec['palette'] as List<dynamic>?;

      for (var i = 0; i < totalCount; i++) {
        String? label;
        if (palette != null && palette.isNotEmpty) {
          final colorHex = palette[i % palette.length].toString();
          label = colorHex;
        }

        await into(sectionRuns).insert(
          SectionRunsCompanion.insert(
            sectionCounterId: sectionCounterId,
            ord: i,
            startRow: startRow + (i * intervalRows),
            rowsTotal: intervalRows,
            label: Value(label),
          ),
        );
      }
    } else if (type == 'shaping') {
      // Shaping 타입: 코 수 증감
      final startRow = spec['startRow'] as int? ?? 0;
      final intervalRows = spec['intervalRows'] as int? ?? 0;
      final totalCount = spec['totalCount'] as int? ?? 0;
      final amount = spec['amount'] as int? ?? 0;

      final label = amount > 0 ? '+$amount코' : '$amount코'; // +1코, -1코

      for (var i = 0; i < totalCount; i++) {
        await into(sectionRuns).insert(
          SectionRunsCompanion.insert(
            sectionCounterId: sectionCounterId,
            ord: i,
            startRow: startRow + (i * intervalRows),
            rowsTotal: intervalRows,
            label: Value(label),
          ),
        );
      }
    } else if (type == 'length') {
      // Length 타입: 단일 목표 구간
      final startRow = spec['startRow'] as int? ?? 0;
      final rowsTotal = spec['rowsTotal'] as int? ?? 0;
      final label = spec['targetInfo'] as String?;

      await into(sectionRuns).insert(
        SectionRunsCompanion.insert(
          sectionCounterId: sectionCounterId,
          ord: 0,
          startRow: startRow,
          rowsTotal: rowsTotal,
          label: Value(label),
        ),
      );
    }
  }

  /// SectionCounter의 모든 runs 조회 (순서대로)
  Future<List<SectionRun>> getSectionRuns(int sectionCounterId) {
    return (select(sectionRuns)
          ..where((t) => t.sectionCounterId.equals(sectionCounterId))
          ..orderBy([(t) => OrderingTerm.asc(t.ord)]))
        .get();
  }

  /// 프로젝트의 카운터 데이터 조회
  Future<ProjectCounter?> getProjectCounter(int projectId) {
    return (select(
      projectCounters,
    )..where((t) => t.projectId.equals(projectId))).getSingleOrNull();
  }

  /// 프로젝트의 카운터 데이터 생성 또는 업데이트
  Future<void> upsertProjectCounter({
    required int projectId,
    required int mainCounter,
    required int mainCountBy,
    int? subCounter,
    required int subCountBy,
    required bool hasSubCounter,
  }) async {
    await into(projectCounters).insertOnConflictUpdate(
      ProjectCountersCompanion.insert(
        projectId: Value(projectId),
        mainCounter: Value(mainCounter),
        mainCountBy: Value(mainCountBy),
        subCounter: Value(subCounter),
        subCountBy: Value(subCountBy),
        hasSubCounter: Value(hasSubCounter),
      ),
    );
  }

  /// 카운터 데이터를 DB에 저장 (디바운싱용)
  Future<void> saveProjectCounter(CounterData counterData) async {
    await upsertProjectCounter(
      projectId: counterData.projectId,
      mainCounter: counterData.mainCounter,
      mainCountBy: counterData.mainCountBy,
      subCounter: counterData.subCounter,
      subCountBy: counterData.subCountBy,
      hasSubCounter: counterData.hasSubCounter,
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Session 관련 메서드들 (새 스키마)
  // ────────────────────────────────────────────────────────────────────────────

  /// 세션 조회 (Part당 최대 1개)
  Future<Session?> getSession(int partId) {
    return (select(sessions)
          ..where((t) => t.partId.equals(partId))
          ..limit(1))
        .getSingleOrNull();
  }

  /// 세션 시작 (첫 작업 시작 시 Session 생성 + 첫 Segment 생성)
  Future<int> createSession({
    required int partId,
    required int currentMainValue,
  }) async {
    try {
      // Part 존재 여부 검증
      await _validatePartExists(partId);

      // 활성 세션 중복 검증
      await _validateSingleActiveSession(partId);

      return await transaction(() async {
        // 기존 세션 확인
        final existing = await getSession(partId);
        if (existing != null) {
          throw DataIntegrityException('Part(ID: $partId)에 이미 세션이 존재합니다');
        }

        final now = DateTime.now().toUtc();

        // Session 생성
        final sessionId = await into(sessions).insert(
          SessionsCompanion.insert(
            partId: partId,
            startedAt: now,
            status: Value(SessionStatus2.running),
          ),
        );

        // 첫 번째 Segment 생성
        await into(sessionSegments).insert(
          SessionSegmentsCompanion.insert(
            sessionId: sessionId,
            partId: partId,
            startedAt: now,
            startCount: Value(currentMainValue),
            reason: Value(SegmentReason.resume),
          ),
        );

        return sessionId;
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, '세션 시작');
    }
  }

  /// 세션 일시정지 (현재 Segment 종료, totalDuration 누적)
  Future<void> pausePartSession({
    required int sessionId,
    required int currentSegmentId,
    required int currentMainValue,
    required DateTime segmentStartedAt,
  }) async {
    try {
      // Session 존재 여부 검증
      await _validateSessionExists(sessionId);

      return await transaction(() async {
        final session = await (select(
          sessions,
        )..where((t) => t.id.equals(sessionId))).getSingleOrNull();

        if (session == null) {
          throw RecordNotFoundException('Session(ID: $sessionId)을 찾을 수 없습니다');
        }

        // 세션 상태 검증
        if (session.status != SessionStatus2.running) {
          throw DataIntegrityException(
            'Session(ID: $sessionId)이 실행 중이 아닙니다 (현재 상태: ${session.status})',
          );
        }

        final now = DateTime.now().toUtc();
        final duration = now.difference(segmentStartedAt).inSeconds;

        // 현재 Segment 종료
        await (update(
          sessionSegments,
        )..where((t) => t.id.equals(currentSegmentId))).write(
          SessionSegmentsCompanion(
            endedAt: Value(now),
            durationSeconds: Value(duration),
            endCount: Value(currentMainValue),
            reason: Value(SegmentReason.pause),
          ),
        );

        // Session 상태 업데이트 및 totalDuration 누적
        await (update(sessions)..where((t) => t.id.equals(sessionId))).write(
          SessionsCompanion(
            status: Value(SessionStatus2.paused),
            totalDurationSeconds: Value(
              session.totalDurationSeconds + duration,
            ),
            updatedAt: Value(now),
          ),
        );
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, '세션 일시정지');
    }
  }

  /// 세션 재시작 (새 Segment 시작)
  Future<int> resumePartSession({
    required int sessionId,
    required int partId,
    required int currentMainValue,
  }) async {
    try {
      // Session 존재 여부 검증
      await _validateSessionExists(sessionId);

      // Part 존재 여부 검증
      await _validatePartExists(partId);

      return await transaction(() async {
        final session = await (select(
          sessions,
        )..where((t) => t.id.equals(sessionId))).getSingleOrNull();

        if (session == null) {
          throw RecordNotFoundException('Session(ID: $sessionId)을 찾을 수 없습니다');
        }

        // 세션 상태 검증
        if (session.status != SessionStatus2.paused) {
          throw DataIntegrityException(
            'Session(ID: $sessionId)이 일시정지 상태가 아닙니다 (현재 상태: ${session.status})',
          );
        }

        final now = DateTime.now().toUtc();

        // Session 상태 업데이트
        await (update(sessions)..where((t) => t.id.equals(sessionId))).write(
          SessionsCompanion(
            status: Value(SessionStatus2.running),
            updatedAt: Value(now),
          ),
        );

        // 새 Segment 시작
        final segmentId = await into(sessionSegments).insert(
          SessionSegmentsCompanion.insert(
            sessionId: sessionId,
            partId: partId,
            startedAt: now,
            startCount: Value(currentMainValue),
            reason: Value(SegmentReason.resume),
          ),
        );

        return segmentId;
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, '세션 재시작');
    }
  }

  /// 현재 진행 중인 Segment 조회 (endedAt이 null인 것)
  Future<SessionSegment?> getCurrentSegment(int sessionId) {
    return (select(sessionSegments)
          ..where((t) => t.sessionId.equals(sessionId) & t.endedAt.isNull())
          ..limit(1))
        .getSingleOrNull();
  }

  /// Session의 모든 Segment 조회 (시간순)
  Future<List<SessionSegment>> getSessionSegments(int sessionId) {
    return (select(sessionSegments)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
        .get();
  }

  /// Segment 종료 (duration 계산 및 저장, endCount 스냅샷)
  Future<void> endSegment({
    required int segmentId,
    required int endMainValue,
    required SegmentReason reason,
  }) async {
    final segment = await (select(
      sessionSegments,
    )..where((t) => t.id.equals(segmentId))).getSingle();

    final now = DateTime.now().toUtc();
    final duration = now.difference(segment.startedAt).inSeconds;

    await (update(sessionSegments)..where((t) => t.id.equals(segmentId))).write(
      SessionSegmentsCompanion(
        endedAt: Value(now),
        durationSeconds: Value(duration),
        endCount: Value(endMainValue),
        reason: Value(reason),
      ),
    );
  }

  /// Part의 모든 Segment 조회 (날짜별 통계용)
  Future<List<SessionSegment>> getPartSegments({
    required int partId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(sessionSegments)
      ..where((t) => t.partId.equals(partId));

    if (startDate != null) {
      query.where((t) => t.startedAt.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where((t) => t.startedAt.isSmallerThanValue(endDate));
    }

    query.orderBy([(t) => OrderingTerm.asc(t.startedAt)]);

    return query.get();
  }

  /// 자정 교차 확인 및 Segment 분할
  /// 현재 진행 중인 Segment가 자정을 넘었는지 확인하고, 넘었다면 분할
  /// 반환값: 분할이 발생했으면 새 Segment ID, 아니면 null
  Future<int?> checkAndSplitSegmentAtMidnight({
    required int sessionId,
    required int partId,
    required int currentMainValue,
  }) async {
    return transaction(() async {
      // 현재 진행 중인 Segment 조회
      final currentSegment = await getCurrentSegment(sessionId);
      if (currentSegment == null) {
        return null; // 진행 중인 Segment가 없음
      }

      final now = DateTime.now().toUtc();
      final segmentStartDate = DateTime(
        currentSegment.startedAt.year,
        currentSegment.startedAt.month,
        currentSegment.startedAt.day,
      );
      final nowDate = DateTime(now.year, now.month, now.day);

      // 같은 날이면 분할 불필요
      if (segmentStartDate == nowDate) {
        return null;
      }

      // 자정 시각 계산 (Segment 시작일의 다음날 00:00:00)
      final midnight = DateTime(
        currentSegment.startedAt.year,
        currentSegment.startedAt.month,
        currentSegment.startedAt.day + 1,
      ).toUtc();

      // 현재 Segment를 자정에서 종료
      final durationUntilMidnight = midnight
          .difference(currentSegment.startedAt)
          .inSeconds;

      await (update(
        sessionSegments,
      )..where((t) => t.id.equals(currentSegment.id))).write(
        SessionSegmentsCompanion(
          endedAt: Value(midnight),
          durationSeconds: Value(durationUntilMidnight),
          endCount: Value(currentMainValue),
          reason: Value(SegmentReason.midnightSplit),
        ),
      );

      // Session의 totalDuration 업데이트
      final session = await (select(
        sessions,
      )..where((t) => t.id.equals(sessionId))).getSingle();

      await (update(sessions)..where((t) => t.id.equals(sessionId))).write(
        SessionsCompanion(
          totalDurationSeconds: Value(
            session.totalDurationSeconds + durationUntilMidnight,
          ),
          updatedAt: Value(now),
        ),
      );

      // 자정부터 새 Segment 시작
      final newSegmentId = await into(sessionSegments).insert(
        SessionSegmentsCompanion.insert(
          sessionId: sessionId,
          partId: partId,
          startedAt: midnight,
          startCount: Value(currentMainValue),
          reason: Value(SegmentReason.midnightSplit),
        ),
      );

      return newSegmentId;
    });
  }

  /// 자정 교차 여부 확인 (분할 없이 확인만)
  Future<bool> needsMidnightSplit(int sessionId) async {
    final currentSegment = await getCurrentSegment(sessionId);
    if (currentSegment == null) {
      return false;
    }

    final now = DateTime.now().toUtc();
    final segmentStartDate = DateTime(
      currentSegment.startedAt.year,
      currentSegment.startedAt.month,
      currentSegment.startedAt.day,
    );
    final nowDate = DateTime(now.year, now.month, now.day);

    return segmentStartDate != nowDate;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // 통계 쿼리 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// 날짜별 작업 시간 집계 (히트맵용)
  /// SessionSegment 기반으로 날짜별 총 작업 시간(초)을 계산
  ///
  /// [startDate]: 조회 시작 날짜 (포함)
  /// [endDate]: 조회 종료 날짜 (미포함)
  ///
  /// 반환값: Map<DateTime, int> - 날짜(00:00:00 UTC)를 키로, 총 작업 시간(초)을 값으로
  Future<Map<DateTime, int>> getDailyWorkSeconds({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final result = await customSelect(
      '''
      SELECT 
        DATE(started_at) as date,
        SUM(duration_seconds) as total_seconds
      FROM session_segments
      WHERE started_at >= ?1 AND started_at < ?2
        AND duration_seconds IS NOT NULL
      GROUP BY DATE(started_at)
      ORDER BY date
      ''',
      variables: [
        Variable.withDateTime(startDate),
        Variable.withDateTime(endDate),
      ],
      readsFrom: {sessionSegments},
    ).get();

    return {
      for (var row in result)
        DateTime.parse(row.data['date'] as String):
            row.data['total_seconds'] as int,
    };
  }

  /// 프로젝트별 총 작업 시간 (Sessions 기반)
  /// 프로젝트의 모든 Part에 대한 Session의 totalDurationSeconds를 합산
  ///
  /// [projectId]: 프로젝트 ID
  ///
  /// 반환값: 총 작업 시간(초)
  Future<int> getProjectTotalSeconds(int projectId) async {
    final result = await customSelect(
      '''
      SELECT COALESCE(SUM(s.total_duration_seconds), 0) as total
      FROM sessions s
      JOIN parts p ON s.part_id = p.id
      WHERE p.project_id = ?1
      ''',
      variables: [Variable.withInt(projectId)],
      readsFrom: {sessions, parts},
    ).getSingle();

    return result.data['total'] as int;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // PartNote 관련 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// PartNote 생성
  ///
  /// [partId]: Part ID
  /// [content]: 메모 내용
  /// [isPinned]: 상단 고정 여부 (기본값: false)
  ///
  /// 반환값: 생성된 PartNote ID
  Future<int> createPartNote({
    required int partId,
    required String content,
    bool isPinned = false,
  }) async {
    try {
      // Part 존재 여부 검증
      await _validatePartExists(partId);

      return await into(partNotes).insert(
        PartNotesCompanion.insert(
          partId: partId,
          content: content,
          isPinned: Value(isPinned),
        ),
      );
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'PartNote 생성');
    }
  }

  /// PartNote 업데이트
  ///
  /// [noteId]: PartNote ID
  /// [content]: 메모 내용 (선택)
  /// [isPinned]: 상단 고정 여부 (선택)
  Future<void> updatePartNote({
    required int noteId,
    String? content,
    bool? isPinned,
  }) {
    return (update(partNotes)..where((t) => t.id.equals(noteId))).write(
      PartNotesCompanion(
        content: content != null ? Value(content) : const Value.absent(),
        isPinned: isPinned != null ? Value(isPinned) : const Value.absent(),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// PartNote 삭제
  ///
  /// [noteId]: PartNote ID
  Future<void> deletePartNote(int noteId) {
    return (delete(partNotes)..where((t) => t.id.equals(noteId))).go();
  }

  /// Part의 모든 메모 조회 (isPinned 우선 정렬)
  ///
  /// 고정된 메모가 먼저 표시되고, 그 다음 생성일시 역순으로 정렬됩니다.
  ///
  /// [partId]: Part ID
  ///
  /// 반환값: PartNote 리스트
  Future<List<PartNote>> getPartNotes(int partId) {
    return (select(partNotes)
          ..where((t) => t.partId.equals(partId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPinned), // 고정된 메모 우선
            (t) => OrderingTerm.desc(t.createdAt), // 최신순
          ]))
        .get();
  }

  /// Part의 모든 메모 조회 (Stream, isPinned 우선 정렬)
  ///
  /// [partId]: Part ID
  ///
  /// 반환값: PartNote 리스트 Stream
  Stream<List<PartNote>> watchPartNotes(int partId) {
    return (select(partNotes)
          ..where((t) => t.partId.equals(partId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPinned), // 고정된 메모 우선
            (t) => OrderingTerm.desc(t.createdAt), // 최신순
          ]))
        .watch();
  }

  /// 특정 PartNote 조회
  ///
  /// [noteId]: PartNote ID
  ///
  /// 반환값: PartNote 또는 null
  Future<PartNote?> getPartNote(int noteId) {
    return (select(
      partNotes,
    )..where((t) => t.id.equals(noteId))).getSingleOrNull();
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Tag 관련 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// Tag 생성
  ///
  /// [name]: 태그 이름 (고유해야 함)
  /// [color]: Flutter Color 값 (0xFFRRGGBB)
  ///
  /// 반환값: 생성된 Tag ID
  Future<int> createTag({required String name, required int color}) async {
    try {
      return await into(
        tags,
      ).insert(TagsCompanion.insert(name: name, color: color));
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'Tag 생성');
    }
  }

  /// Tag 업데이트
  ///
  /// [tagId]: Tag ID
  /// [name]: 태그 이름 (선택)
  /// [color]: Flutter Color 값 (선택)
  Future<void> updateTag({required int tagId, String? name, int? color}) {
    return (update(tags)..where((t) => t.id.equals(tagId))).write(
      TagsCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        color: color != null ? Value(color) : const Value.absent(),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// Tag 삭제 (모든 프로젝트에서 해당 태그 제거)
  ///
  /// [tagId]: Tag ID
  Future<void> deleteTag(int tagId) async {
    try {
      // Tag 존재 여부 검증
      await _validateTagExists(tagId);

      return await transaction(() async {
        // 1. 태그 삭제
        await (delete(tags)..where((t) => t.id.equals(tagId))).go();

        // 2. 모든 프로젝트에서 해당 태그 ID 제거
        final projectsWithTags = await (select(
          projects,
        )..where((t) => t.tagIds.isNotNull())).get();

        for (final project in projectsWithTags) {
          final tagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
          if (tagIds.contains(tagId)) {
            tagIds.remove(tagId);
            await (update(
              projects,
            )..where((t) => t.id.equals(project.id))).write(
              ProjectsCompanion(
                tagIds: Value(tagIds.isEmpty ? null : jsonEncode(tagIds)),
                updatedAt: Value(DateTime.now().toUtc()),
              ),
            );
          }
        }
      });
    } on DatabaseException {
      rethrow; // 이미 DatabaseException이면 그대로 throw
    } catch (e) {
      throw _handleDatabaseException(e, 'Tag 삭제');
    }
  }

  /// 모든 태그 조회 (이름순)
  ///
  /// 반환값: Tag 리스트
  Future<List<Tag>> getAllTags() {
    return (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();
  }

  /// 태그 이름으로 검색
  ///
  /// [query]: 검색어
  ///
  /// 반환값: 검색어를 포함하는 Tag 리스트 (이름순)
  Future<List<Tag>> searchTags(String query) {
    return (select(tags)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// 특정 Tag 조회
  ///
  /// [tagId]: Tag ID
  ///
  /// 반환값: Tag 또는 null
  Future<Tag?> getTag(int tagId) {
    return (select(tags)..where((t) => t.id.equals(tagId))).getSingleOrNull();
  }

  /// 프로젝트의 태그 조회
  ///
  /// [projectId]: 프로젝트 ID
  ///
  /// 반환값: 프로젝트에 연결된 Tag 리스트
  Future<List<Tag>> getProjectTags(int projectId) async {
    final project = await (select(
      projects,
    )..where((t) => t.id.equals(projectId))).getSingle();

    if (project.tagIds == null) return [];

    final tagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
    if (tagIds.isEmpty) return [];

    return (select(tags)..where((t) => t.id.isIn(tagIds))).get();
  }

  /// 프로젝트의 태그 업데이트
  ///
  /// [projectId]: 프로젝트 ID
  /// [tagIds]: 태그 ID 리스트
  Future<void> updateProjectTags({
    required int projectId,
    required List<int> tagIds,
  }) {
    return (update(projects)..where((t) => t.id.equals(projectId))).write(
      ProjectsCompanion(
        tagIds: Value(tagIds.isEmpty ? null : jsonEncode(tagIds)),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// 태그별 프로젝트 조회 (단일 태그)
  ///
  /// [tagId]: Tag ID
  ///
  /// 반환값: 해당 태그를 가진 프로젝트 리스트 (최신순)
  Future<List<Project>> getProjectsByTag(int tagId) async {
    // 모든 프로젝트 조회 후 필터링
    final allProjects = await (select(
      projects,
    )..where((t) => t.tagIds.isNotNull())).get();

    final filtered = allProjects.where((project) {
      final projectTagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
      return projectTagIds.contains(tagId);
    }).toList();

    // 최신순 정렬
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  /// 다중 태그 필터 (AND 조건)
  ///
  /// [tagIds]: Tag ID 리스트 (모든 태그를 포함하는 프로젝트만 반환)
  ///
  /// 반환값: 모든 태그를 가진 프로젝트 리스트 (최신순)
  Future<List<Project>> getProjectsByTags(List<int> tagIds) async {
    if (tagIds.isEmpty) {
      return (select(
        projects,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    }

    // 모든 프로젝트 조회 후 필터링
    final allProjects = await (select(
      projects,
    )..where((t) => t.tagIds.isNotNull())).get();

    final filtered = allProjects.where((project) {
      final projectTagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
      return tagIds.every((tagId) => projectTagIds.contains(tagId));
    }).toList();

    // 최신순 정렬
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  // ────────────────────────────────────────────────────────────────────────────
  // 프로젝트 이미지 관리 메서드들
  // ────────────────────────────────────────────────────────────────────────────

  /// 프로젝트 이미지 경로 업데이트
  ///
  /// 이미지 파일의 실제 저장/삭제는 애플리케이션 레벨에서 처리해야 합니다.
  /// 이 메서드는 데이터베이스의 imagePath 필드만 업데이트합니다.
  ///
  /// [projectId]: 프로젝트 ID
  /// [imagePath]: 이미지 파일 경로 (예: 'project_images/1.jpg')
  ///               null을 전달하면 이미지 경로를 제거합니다.
  ///
  /// 사용 예시:
  /// ```dart
  /// // 이미지 설정
  /// await db.updateProjectImage(projectId: 1, imagePath: 'project_images/1.jpg');
  ///
  /// // 이미지 제거
  /// await db.updateProjectImage(projectId: 1, imagePath: null);
  /// ```
  Future<void> updateProjectImage({
    required int projectId,
    required String? imagePath,
  }) {
    return (update(projects)..where((t) => t.id.equals(projectId))).write(
      ProjectsCompanion(
        imagePath: Value(imagePath),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// 프로젝트의 현재 선택된 파트 ID 업데이트
  Future<void> updateProjectCurrentPart({
    required int projectId,
    required int partId,
  }) {
    return (update(projects)..where((t) => t.id.equals(projectId))).write(
      ProjectsCompanion(
        currentPartId: Value(partId),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// 파트 이름 중복 확인
  Future<bool> isPartNameExists({
    required int projectId,
    required String name,
  }) async {
    final count = await (selectOnly(parts)
      ..addColumns([parts.id.count()])
      ..where(parts.projectId.equals(projectId) & parts.name.equals(name)))
      .map((row) => row.read(parts.id.count()))
      .getSingle();
    return (count ?? 0) > 0;
  }
}
