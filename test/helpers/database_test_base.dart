import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'test_helpers.dart';

/// 데이터베이스 테스트를 위한 기본 클래스
abstract class DatabaseTestBase {
  late AppDb db;
  late int testProjectId;

  /// 각 테스트 전에 실행되는 설정
  Future<void> setUpDatabase() async {
    db = createTestDb();
    testProjectId = await createTestProject(db);
  }

  /// 각 테스트 후에 실행되는 정리
  Future<void> tearDownDatabase() async {
    await db.close();
  }
}

/// 데이터베이스 테스트 그룹 설정 헬퍼
void databaseTestGroup(
  String description,
  void Function(AppDb Function() getDb, int Function() getProjectId) body,
) {
  group(description, () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    body(() => db, () => projectId);
  });
}
