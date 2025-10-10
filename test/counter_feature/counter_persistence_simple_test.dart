import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('카운터 데이터 지속성 간단 테스트', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('기본값 테스트', () async {
      await db
          .into(db.projectCounters)
          .insert(
            ProjectCountersCompanion.insert(
              projectId: Value(projectId),
              mainCounter: Value(0),
              mainCountBy: Value(1),
              subCounter: Value(null),
              subCountBy: Value(1),
              hasSubCounter: Value(false),
            ),
          );

      final counterData = await (db.select(
        db.projectCounters,
      )..where((t) => t.projectId.equals(projectId))).getSingleOrNull();

      expect(counterData, isA<ProjectCounter>());
      expect(counterData!.projectId, projectId);
      expect(counterData.mainCounter, 0);
      expect(counterData.mainCountBy, 1);
      expect(counterData.hasSubCounter, false);
      expect(counterData.subCounter, null);
      expect(counterData.subCountBy, 1);
    });

    test('메인 카운터 증감 테스트', () async {
      await db
          .into(db.projectCounters)
          .insert(
            ProjectCountersCompanion.insert(
              projectId: Value(projectId),
              mainCounter: Value(0),
              mainCountBy: Value(1),
              subCounter: Value(null),
              subCountBy: Value(1),
              hasSubCounter: Value(false),
            ),
          );

      await (db.update(db.projectCounters)
            ..where((t) => t.projectId.equals(projectId)))
          .write(ProjectCountersCompanion(mainCounter: Value(1)));

      final counterData = await (db.select(
        db.projectCounters,
      )..where((t) => t.projectId.equals(projectId))).getSingleOrNull();

      expect(counterData!.mainCounter, 1);
    });

    test('서브 카운터 추가/삭제 테스트', () async {
      await db
          .into(db.projectCounters)
          .insert(
            ProjectCountersCompanion.insert(
              projectId: Value(projectId),
              mainCounter: Value(0),
              mainCountBy: Value(1),
              subCounter: Value(null),
              subCountBy: Value(1),
              hasSubCounter: Value(false),
            ),
          );

      await (db.update(
        db.projectCounters,
      )..where((t) => t.projectId.equals(projectId))).write(
        ProjectCountersCompanion(
          hasSubCounter: Value(true),
          subCounter: Value(0),
        ),
      );

      final counterData1 = await (db.select(
        db.projectCounters,
      )..where((t) => t.projectId.equals(projectId))).getSingleOrNull();

      expect(counterData1!.hasSubCounter, true);
      expect(counterData1.subCounter, 0);
    });

    test('프로젝트별 데이터 격리 테스트', () async {
      const project1Id = 1;
      const project2Id = 2;

      await db
          .into(db.projectCounters)
          .insert(
            ProjectCountersCompanion.insert(
              projectId: Value(project1Id),
              mainCounter: Value(3),
              mainCountBy: Value(3),
              subCounter: Value(null),
              subCountBy: Value(1),
              hasSubCounter: Value(false),
            ),
          );

      await db
          .into(db.projectCounters)
          .insert(
            ProjectCountersCompanion.insert(
              projectId: Value(project2Id),
              mainCounter: Value(2),
              mainCountBy: Value(2),
              subCounter: Value(null),
              subCountBy: Value(1),
              hasSubCounter: Value(false),
            ),
          );

      final project1Data = await (db.select(
        db.projectCounters,
      )..where((t) => t.projectId.equals(project1Id))).getSingleOrNull();

      final project2Data = await (db.select(
        db.projectCounters,
      )..where((t) => t.projectId.equals(project2Id))).getSingleOrNull();

      expect(project1Data!.mainCounter, 3);
      expect(project2Data!.mainCounter, 2);
    });
  });
}
