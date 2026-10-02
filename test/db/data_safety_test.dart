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
  });
}
