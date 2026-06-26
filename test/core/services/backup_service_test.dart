import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/core/services/backup_service.dart';
import '../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late Directory docDir;
  late AppDb db;
  late BackupService backupService;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('yarnie_test_temp');
    docDir = Directory.systemTemp.createTempSync('yarnie_test_doc');

    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return docDir.path;
      }
      if (methodCall.method == 'getTemporaryDirectory') {
        return tempDir.path;
      }
      return null;
    });
  });

  tearDownAll(() {
    try {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      if (docDir.existsSync()) docDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  setUp(() async {
    db = createTestDb();
    backupService = BackupService(db);

    // 기존 디렉토리 초기화
    final projImgDir = Directory(p.join(docDir.path, 'project_images'));
    if (projImgDir.existsSync()) projImgDir.deleteSync(recursive: true);
    final stashImgDir = Directory(p.join(docDir.path, 'stash_images'));
    if (stashImgDir.existsSync()) stashImgDir.deleteSync(recursive: true);
  });

  tearDown(() async {
    await db.close();
  });

  test('실 보관함 데이터 백업 및 복원 통합 테스트', () async {
    // 1. 테스트용 실 태그 및 실 정보 추가
    final tagId = await db.createStashTag(name: '테스트태그', color: 0xFF123456);
    expect(tagId, greaterThan(0));

    // 실 보관함용 이미지 디렉토리 생성 및 테스트 이미지 파일 작성
    final stashImgDir = Directory(p.join(docDir.path, 'stash_images'));
    await stashImgDir.create(recursive: true);
    final testImageFile = File(p.join(stashImgDir.path, 'yarn_pic.jpg'));
    await testImageFile.writeAsString('test-image-content');

    final yarnId = await db.createStashYarn(StashYarnsCompanion.insert(
      yarnName: '테스트 실',
      brandName: const Value('예쁜 브랜드'),
      imagePath: const Value('stash_images/yarn_pic.jpg'),
      tagIds: const Value('[1]'),
    ));
    expect(yarnId, greaterThan(0));

    // 2. 백업 파일 내보내기 (Export)
    final backupPath = await backupService.exportBackup();
    expect(backupPath, isNotEmpty);

    final backupFile = File(backupPath);
    expect(await backupFile.exists(), isTrue);

    // 3. 새 DB 및 새 서비스 생성 (데이터 복원 대상 깨끗한 상태)
    final cleanDb = createTestDb();
    final cleanBackupService = BackupService(cleanDb);

    // 깨끗한 DB에 데이터가 없는지 확인
    final cleanTags = await cleanDb.getAllStashTags();
    expect(cleanTags.isEmpty, isTrue);

    // 로컬 이미지 파일 지우기
    if (testImageFile.existsSync()) {
      testImageFile.deleteSync();
    }
    expect(testImageFile.existsSync(), isFalse);

    // 4. 복원 실행 (Import)
    await cleanBackupService.importBackup(backupPath);

    // 5. 데이터 복원 검증
    // DB 확인
    final restoredTags = await cleanDb.getAllStashTags();
    expect(restoredTags.length, 1);
    expect(restoredTags.first.name, '테스트태그');
    expect(restoredTags.first.color, 0xFF123456);

    final restoredYarn = await cleanDb.getStashYarn(yarnId);
    expect(restoredYarn, isNotNull);
    expect(restoredYarn!.yarnName, '테스트 실');
    expect(restoredYarn.brandName, '예쁜 브랜드');
    expect(restoredYarn.imagePath, 'stash_images/yarn_pic.jpg');

    // 이미지 파일 복원 확인
    expect(testImageFile.existsSync(), isTrue);
    final restoredImageContent = await testImageFile.readAsString();
    expect(restoredImageContent, 'test-image-content');

    await cleanDb.close();
  });

  test('레거시 snake_case 백업 데이터 복원 테스트', () async {
    // 1. 레거시 형식의 JSON 데이터 모의 생성 (snake_case 메타데이터, 테이블명, lot_number 포함)
    final Map<String, dynamic> legacyBackup = {
      'metadata': {
        'version': 2,
        'exported_at': '2026-05-26T10:27:18.800202Z',
        'app_identifier': 'com.yes.yarnie'
      },
      'data': {
        'projects': [
          {
            'id': 1,
            'name': '레거시 스웨터',
            'needleType': 'knitting',
            'needleSize': '4.0mm',
            'lot_number': 'L123', // 구버전 lot_number
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }
        ],
        'parts': [
          {
            'id': 1,
            'projectId': 1,
            'name': 'Part 1',
            'orderIndex': 0,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }
        ],
        'main_counters': [ // 구버전 snake_case 테이블명
          {
            'id': 1,
            'partId': 1,
            'currentValue': 1,
            'countBy': 1,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }
        ],
      }
    };

    // 임시 JSON 파일로 저장
    final tempBackupFile = File(p.join(tempDir.path, 'legacy_data.json'));
    await tempBackupFile.writeAsString(jsonEncode(legacyBackup));

    // 2. 복원 실행
    await backupService.importBackup(tempBackupFile.path);

    // 3. 복원 검증
    final restoredProjects = await db.select(db.projects).get();
    expect(restoredProjects.length, 1);
    expect(restoredProjects.first.name, '레거시 스웨터');

    // lot_number 마이그레이션 확인 (실 자동 생성 및 연결되었는지 확인)
    final restoredYarns = await db.select(db.stashYarns).get();
    expect(restoredYarns.length, 1);
    expect(restoredYarns.first.dyeLot, 'L123');

    final restoredMainCounters = await db.select(db.mainCounters).get();
    expect(restoredMainCounters.length, 1);
    expect(restoredMainCounters.first.id, 1);

    if (tempBackupFile.existsSync()) {
      tempBackupFile.deleteSync();
    }
  });
}
