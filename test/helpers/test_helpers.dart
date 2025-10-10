import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/providers/counter_provider.dart';

/// 테스트용 데이터베이스 연결 생성
DatabaseConnection createTestConnection() {
  return DatabaseConnection(NativeDatabase.memory());
}

/// 테스트용 AppDb 인스턴스 생성
AppDb createTestDb() {
  return AppDb.forTesting(createTestConnection());
}

/// Riverpod 테스트 컨테이너 생성 헬퍼
ProviderContainer createTestContainer() {
  return ProviderContainer();
}

/// 테스트용 프로젝트 생성 헬퍼
Future<int> createTestProject(AppDb db, {String name = 'Test Project'}) async {
  return await db.createProject(
    name: name,
    category: 'Test Category',
    needleType: 'Test Needle',
    needleSize: '4.0mm',
    lotNumber: 'TEST001',
    memo: 'Test project for testing',
  );
}

/// 테스트용 완료된 세션 생성 헬퍼
Future<void> createCompletedSession(
  AppDb db,
  int projectId,
  Duration duration, {
  String? label,
  String? memo,
}) async {
  // 세션 시작
  await db.startSession(projectId: projectId, label: label, memo: memo);

  // 시간 경과 시뮬레이션을 위해 직접 DB 업데이트
  final session = await db.getActiveSession(projectId);
  if (session != null) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final startTime = now - duration.inMilliseconds;

    await db.customUpdate(
      'UPDATE work_sessions SET started_at = ?, elapsed_ms = ?, stopped_at = ?, status = ? WHERE id = ?',
      variables: [
        Variable.withInt(startTime),
        Variable.withInt(duration.inMilliseconds),
        Variable.withInt(now),
        Variable.withInt(2), // SessionStatus.stopped
        Variable.withInt(session.id),
      ],
      updates: {db.workSessions},
    );
  }
}

/// 테스트 정확도 검증 헬퍼
void expectDurationCloseTo(
  Duration actual,
  Duration expected,
  Duration tolerance,
) {
  expect(
    actual.inMilliseconds,
    closeTo(expected.inMilliseconds, tolerance.inMilliseconds),
    reason: 'Expected $actual to be close to $expected within $tolerance',
  );
}

/// 세션 ID로 세션 조회 헬퍼
Future<WorkSession?> getSessionById(AppDb db, int sessionId) async {
  final query = db.select(db.workSessions)
    ..where((s) => s.id.equals(sessionId));
  return await query.getSingleOrNull();
}

/// 테스트 그룹 설정 헬퍼
void setupTestGroup(String description, Function() body) {
  group(description, () {
    late AppDb testDb;
    late ProviderContainer container;

    setUp(() {
      testDb = createTestDb();
      container = createTestContainer();
    });

    tearDown(() async {
      await testDb.close();
      container.dispose();
    });

    body();
  });
}

// ============================================================================
// 카운터 테스트 헬퍼들
// ============================================================================

/// 카운터 테스트용 헬퍼 클래스
class CounterTestHelpers {
  /// 테스트용 카운터 데이터 생성
  static Future<void> createTestCounterData(
    AppDb db,
    int projectId, {
    int mainCounter = 0,
    int mainCountBy = 1,
    bool hasSubCounter = false,
    int? subCounter,
    int subCountBy = 1,
  }) async {
    await db.upsertProjectCounter(
      projectId: projectId,
      mainCounter: mainCounter,
      mainCountBy: mainCountBy,
      hasSubCounter: hasSubCounter,
      subCounter: subCounter,
      subCountBy: subCountBy,
    );
  }

  /// 카운터 상태 검증 헬퍼
  static void expectCounterState(
    dynamic actualState, {
    required int mainCounter,
    required int mainCountBy,
    required bool hasSubCounter,
    int? subCounter,
    int? subCountBy,
  }) {
    expect(actualState.mainCounter, mainCounter);
    expect(actualState.mainCountBy, mainCountBy);
    expect(actualState.hasSubCounter, hasSubCounter);
    if (hasSubCounter) {
      expect(actualState.subCounter, subCounter);
      expect(actualState.subCountBy, subCountBy);
    }
  }

  /// 테스트용 카운터 프로바이더 컨테이너 생성
  static ProviderContainer createCounterTestContainer(AppDb db) {
    return ProviderContainer(overrides: [appDbProvider.overrideWithValue(db)]);
  }
}

/// 테스트용 카운터 프로바이더 (저장 횟수 추적 가능)
class TestCounterNotifier extends CounterNotifier {
  int saveCallCount = 0;

  @override
  Future<void> saveToDatabase() async {
    saveCallCount++;
    return super.saveToDatabase();
  }
}

/// 테스트용 프로바이더
final testCounterProvider = NotifierProvider<TestCounterNotifier, CounterState>(
  () {
    return TestCounterNotifier();
  },
);
