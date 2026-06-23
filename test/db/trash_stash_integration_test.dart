import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('실 휴지통 통합 테스트', () {
    late AppDb db;

    setUp(() async {
      db = createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('실 소프트 삭제 -> 휴지통 조회 -> 복원 Flow 검증', () async {
      // 1. 실 데이터 추가
      final yarnId = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: '테스트용 양모실',
        brandName: const Value('양모 메이커'),
      ));
      expect(yarnId, greaterThan(0));

      // 정상 상태일 때 watchAllStashYarns()에 잡히는지 확인
      final activeYarns = await db.watchAllStashYarns().first;
      expect(activeYarns.any((y) => y.id == yarnId), isTrue);

      // 2. 실 소프트 삭제
      await db.deleteStashYarn(yarnId);

      // 소프트 삭제 후 watchAllStashYarns()에서 제외되었는지 확인
      final activeYarnsAfterDelete = await db.watchAllStashYarns().first;
      expect(activeYarnsAfterDelete.any((y) => y.id == yarnId), isFalse);

      // 3. 휴지통 스트림 watchDeletedStashYarns()를 통해 삭제된 실 확인
      final deletedYarns = await db.watchDeletedStashYarns().first;
      expect(deletedYarns.any((y) => y.id == yarnId), isTrue);

      // 4. 복원 실행
      await db.restoreStashYarn(yarnId);

      // 복원 후 휴지통에서 사라졌는지 확인
      final deletedYarnsAfterRestore = await db.watchDeletedStashYarns().first;
      expect(deletedYarnsAfterRestore.any((y) => y.id == yarnId), isFalse);

      // 복원 후 다시 활성화된 목록에 나타나는지 확인
      final activeYarnsAfterRestore = await db.watchAllStashYarns().first;
      expect(activeYarnsAfterRestore.any((y) => y.id == yarnId), isTrue);
    });

    test('실 영구 삭제 Flow 검증', () async {
      // 1. 실 데이터 추가 및 소프트 삭제
      final yarnId = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: '영구삭제 실',
      ));
      await db.deleteStashYarn(yarnId);

      final deletedYarns = await db.watchDeletedStashYarns().first;
      expect(deletedYarns.any((y) => y.id == yarnId), isTrue);

      // 2. 영구 삭제 실행
      await db.permanentlyDeleteStashYarn(yarnId);

      // 영구 삭제 후 휴지통 목록에서 아예 사라졌는지 확인
      final deletedYarnsAfterDelete = await db.watchDeletedStashYarns().first;
      expect(deletedYarnsAfterDelete.any((y) => y.id == yarnId), isFalse);

      // DB 상세 조회도 null인지 확인
      final detail = await db.getStashYarn(yarnId);
      expect(detail, isNull);
    });

    test('30일 지난 실 데이터 클린업(배치) 검증', () async {
      // 1. 실 데이터 추가
      final yarn1Id = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: '안 지워질 실 (최근 삭제)',
      ));
      final yarn2Id = await db.createStashYarn(StashYarnsCompanion.insert(
        yarnName: '지워질 실 (오래전 삭제)',
      ));

      // 2. 소프트 삭제 적용
      await db.deleteStashYarn(yarn1Id);
      await db.deleteStashYarn(yarn2Id);

      // yarn2Id의 deletedAt을 강제로 31일 전으로 업데이트
      final oldDate = DateTime.now().toUtc().subtract(const Duration(days: 31));
      await (db.update(db.stashYarns)..where((t) => t.id.equals(yarn2Id))).write(
        StashYarnsCompanion(deletedAt: Value(oldDate)),
      );

      // 3. 클린업 호출
      await db.cleanupDeletedStashYarns();

      // yarn2Id는 완전히 삭제되어 없어야 함
      final yarn2Detail = await db.getStashYarn(yarn2Id);
      expect(yarn2Detail, isNull);

      // yarn1Id는 휴지통에 그대로 남아있어야 함
      final yarn1Detail = await db.getStashYarn(yarn1Id);
      expect(yarn1Detail, isNotNull);
      expect(yarn1Detail!.deletedAt, isNotNull);
    });
  });
}
