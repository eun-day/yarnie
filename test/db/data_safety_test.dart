import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  late AppDb db;

  setUp(() {
    db = createTestDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('v4 마이그레이션 (보관함 태그 이름 UNIQUE 인덱스)', () {
    Future<bool> hasStashTagNameIndex() async {
      final rows = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'index' AND name = 'stash_tags_name'",
      ).get();
      return rows.isNotEmpty;
    }

    test('v3에서 올라오면 같은 이름의 태그를 합치고 인덱스를 만든다', () async {
      // v3 업그레이드 사용자처럼 인덱스가 없는 상태를 만든다
      await db.customStatement('DROP INDEX stash_tags_name');
      final wool1 = await db.createStashTag(name: 'Wool', color: 1);
      final wool2 = await db.createStashTag(name: 'Wool', color: 2);
      final cotton = await db.createStashTag(name: 'Cotton', color: 3);
      final yarnA = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: 'A',
        tagIds: Value('[$wool2,$cotton]'),
      ));
      final yarnB = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: 'B',
        tagIds: Value('[$wool1,$wool2]'),
      ));

      await db.migration.onUpgrade(Migrator(db), 3, 4);

      final tags = await db.getAllStashTags();
      expect(tags.map((t) => t.id), unorderedEquals([wool1, cotton]));
      expect((await db.getStashYarn(yarnA))!.tagIds, '[$wool1,$cotton]');
      expect((await db.getStashYarn(yarnB))!.tagIds, '[$wool1]');
      expect(await hasStashTagNameIndex(), isTrue);
      expect(
        () => db.createStashTag(name: 'Wool', color: 4),
        throwsA(isA<UniqueConstraintException>()),
      );
    });

    test('v3를 새로 설치해 인덱스가 이미 있으면 그대로 둔다', () async {
      expect(await hasStashTagNameIndex(), isTrue);
      await db.migration.onUpgrade(Migrator(db), 3, 4);
      expect(await hasStashTagNameIndex(), isTrue);
    });

    test('remapTagIdsJson: ID를 바꾸고 중복을 없앤다', () {
      expect(AppDb.remapTagIdsJson('[2,3]', {2: 1}), '[1,3]');
      expect(AppDb.remapTagIdsJson('[1,2]', {2: 1}), '[1]');
      expect(AppDb.remapTagIdsJson('[1, 3]', {2: 1}), '[1, 3]'); // 바꿀 ID 없음
      expect(AppDb.remapTagIdsJson(null, {2: 1}), isNull);
      expect(AppDb.remapTagIdsJson('broken', {2: 1}), 'broken');
    });
  });

  group('이미지 참조 확인', () {
    test('프로젝트·실 어느 쪽이든 참조하면 사용 중으로 본다', () async {
      final projectId = await createTestProject(db);
      await db.updateProjectImage(projectId: projectId, imagePath: 'project_images/1.jpg');
      final yarnId = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: '복사한 실',
        imagePath: const Value('project_images/1.jpg'),
      ));

      expect(await db.isImagePathReferenced('project_images/1.jpg'), isTrue);

      await db.updateProjectImage(projectId: projectId, imagePath: null);
      expect(await db.isImagePathReferenced('project_images/1.jpg'), isTrue);

      await db.permanentlyDeleteStashYarn(yarnId);
      expect(await db.isImagePathReferenced('project_images/1.jpg'), isFalse);
    });

    test('30일 정리는 지운 행의 이미지 경로만 돌려준다', () async {
      final oldId = await createTestProject(db, name: 'old');
      final recentId = await createTestProject(db, name: 'recent');
      await db.updateProjectImage(projectId: oldId, imagePath: 'project_images/old.jpg');
      await db.updateProjectImage(projectId: recentId, imagePath: 'project_images/recent.jpg');
      final now = DateTime.now().toUtc();
      await db.updateProject(ProjectsCompanion(
        id: Value(oldId),
        deletedAt: Value(now.subtract(const Duration(days: 31))),
      ));
      await db.updateProject(ProjectsCompanion(
        id: Value(recentId),
        deletedAt: Value(now.subtract(const Duration(days: 1))),
      ));

      expect(await db.cleanupDeletedProjects(), ['project_images/old.jpg']);
      expect(await db.isImagePathReferenced('project_images/old.jpg'), isFalse);
      expect(await db.isImagePathReferenced('project_images/recent.jpg'), isTrue);
    });
  });
}
