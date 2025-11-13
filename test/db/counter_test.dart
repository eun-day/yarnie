import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Counter 데이터베이스 작업', () {
    late AppDb db;

    setUp(() async {
      db = createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    group('MainCounter 작업', () {
      test('Part 생성 시 MainCounter가 자동으로 생성된다', () async {
        // Given
        final projectId = await createTestProject(db);

        // When
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        // Then
        final mainCounter = await db.getMainCounter(partId);
        expect(mainCounter, isNotNull);
        expect(mainCounter!.partId, partId);
        expect(mainCounter.currentValue, 0);
      });

      test('MainCounter 값을 업데이트할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        // When
        await db.updateMainCounter(partId: partId, newValue: 10);

        // Then
        final mainCounter = await db.getMainCounter(partId);
        expect(mainCounter!.currentValue, 10);
      });
    });

    group('StitchCounter 작업', () {
      test('StitchCounter를 생성할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        // When
        final counterId = await db.createStitchCounter(
          partId: partId,
          name: 'Test Stitch',
          newOrderJson: '[{"type":"stitch","id":1}]',
          countBy: 2,
        );

        // Then
        final counter = await db.getStitchCounter(counterId);
        expect(counter, isNotNull);
        expect(counter!.name, 'Test Stitch');
        expect(counter.currentValue, 0);
        expect(counter.countBy, 2);

        // Part의 buddyCounterOrder도 업데이트되었는지 확인
        final part = await db.getPart(partId);
        expect(part!.buddyCounterOrder, '[{"type":"stitch","id":1}]');
      });

      test('StitchCounter를 업데이트할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final counterId = await db.createStitchCounter(
          partId: partId,
          name: 'Old Name',
          newOrderJson: '[]',
        );

        // When
        await db.updateStitchCounter(
          counterId: counterId,
          name: 'New Name',
          currentValue: 5,
          countBy: 3,
        );

        // Then
        final counter = await db.getStitchCounter(counterId);
        expect(counter!.name, 'New Name');
        expect(counter.currentValue, 5);
        expect(counter.countBy, 3);
      });

      test('StitchCounter를 삭제할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final counterId = await db.createStitchCounter(
          partId: partId,
          name: 'Test Stitch',
          newOrderJson: '[{"type":"stitch","id":1}]',
        );

        // When
        await db.deleteStitchCounter(
          counterId: counterId,
          partId: partId,
          newOrderJson: '[]',
        );

        // Then
        final counter = await db.getStitchCounter(counterId);
        expect(counter, isNull);

        // Part의 buddyCounterOrder도 업데이트되었는지 확인
        final part = await db.getPart(partId);
        expect(part!.buddyCounterOrder, '[]');
      });

      test('Part의 모든 StitchCounter를 조회할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        await db.createStitchCounter(
          partId: partId,
          name: 'Stitch 1',
          newOrderJson: '[]',
        );
        await db.createStitchCounter(
          partId: partId,
          name: 'Stitch 2',
          newOrderJson: '[]',
        );

        // When
        final counters = await db.getPartStitchCounters(partId);

        // Then
        expect(counters.length, 2);
        expect(counters[0].name, 'Stitch 1');
        expect(counters[1].name, 'Stitch 2');
      });
    });

    group('SectionCounter 작업', () {
      test('SectionCounter를 생성하면 SectionRuns가 자동으로 전개된다 (Range 타입)', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final specJson =
            '{"type":"range","startRow":1,"rowsTotal":10,"label":"테스트 구간"}';

        // When
        final counterId = await db.createSectionCounter(
          partId: partId,
          name: 'Test Section',
          specJson: specJson,
          newOrderJson: '[{"type":"section","id":1}]',
        );

        // Then
        final counter = await db.getSectionCounter(counterId);
        expect(counter, isNotNull);
        expect(counter!.name, 'Test Section');
        expect(counter.linkState, LinkState.linked);

        // SectionRuns 확인
        final runs = await db.getSectionRuns(counterId);
        expect(runs.length, 1);
        expect(runs[0].ord, 0);
        expect(runs[0].startRow, 1);
        expect(runs[0].rowsTotal, 10);
        expect(runs[0].label, '테스트 구간');
        expect(runs[0].state, RunState.scheduled);
      });

      test('SectionCounter를 생성하면 SectionRuns가 자동으로 전개된다 (Repeat 타입)', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final specJson =
            '{"type":"repeat","startRow":1,"rowsPerRepeat":5,"repeatCount":3}';

        // When
        final counterId = await db.createSectionCounter(
          partId: partId,
          name: 'Test Section',
          specJson: specJson,
          newOrderJson: '[]',
        );

        // Then
        final runs = await db.getSectionRuns(counterId);
        expect(runs.length, 3);

        expect(runs[0].ord, 0);
        expect(runs[0].startRow, 1);
        expect(runs[0].rowsTotal, 5);
        expect(runs[0].label, '1회차');

        expect(runs[1].ord, 1);
        expect(runs[1].startRow, 6);
        expect(runs[1].rowsTotal, 5);
        expect(runs[1].label, '2회차');

        expect(runs[2].ord, 2);
        expect(runs[2].startRow, 11);
        expect(runs[2].rowsTotal, 5);
        expect(runs[2].label, '3회차');
      });

      test('SectionCounter spec 업데이트 시 SectionRuns가 재전개된다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final oldSpecJson =
            '{"type":"repeat","startRow":1,"rowsPerRepeat":5,"repeatCount":2}';
        final counterId = await db.createSectionCounter(
          partId: partId,
          name: 'Test Section',
          specJson: oldSpecJson,
          newOrderJson: '[]',
        );

        // When: repeatCount를 3으로 변경
        final newSpecJson =
            '{"type":"repeat","startRow":1,"rowsPerRepeat":5,"repeatCount":3}';
        await db.updateSectionCounter(
          counterId: counterId,
          specJson: newSpecJson,
        );

        // Then
        final runs = await db.getSectionRuns(counterId);
        expect(runs.length, 3); // 2개에서 3개로 증가
      });

      test('SectionCounter를 언링크할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final counterId = await db.createSectionCounter(
          partId: partId,
          name: 'Test Section',
          specJson: '{"type":"range","startRow":1,"rowsTotal":10}',
          newOrderJson: '[]',
        );

        // MainCounter 값 설정
        await db.updateMainCounter(partId: partId, newValue: 15);

        // When
        await db.unlinkSectionCounter(
          counterId: counterId,
          currentMainValue: 15,
        );

        // Then
        final counter = await db.getSectionCounter(counterId);
        expect(counter!.linkState, LinkState.unlinked);
        expect(counter.frozenMainAt, 15);
      });

      test('SectionCounter를 재링크할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final counterId = await db.createSectionCounter(
          partId: partId,
          name: 'Test Section',
          specJson: '{"type":"range","startRow":1,"rowsTotal":10}',
          newOrderJson: '[]',
        );

        await db.unlinkSectionCounter(
          counterId: counterId,
          currentMainValue: 10,
        );

        // When
        await db.relinkSectionCounter(counterId);

        // Then
        final counter = await db.getSectionCounter(counterId);
        expect(counter!.linkState, LinkState.linked);
        expect(counter.frozenMainAt, isNull);
      });

      test('SectionCounter 삭제 시 SectionRuns도 함께 삭제된다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final counterId = await db.createSectionCounter(
          partId: partId,
          name: 'Test Section',
          specJson:
              '{"type":"repeat","startRow":1,"rowsPerRepeat":5,"repeatCount":3}',
          newOrderJson: '[{"type":"section","id":1}]',
        );

        // When
        await db.deleteSectionCounter(
          counterId: counterId,
          partId: partId,
          newOrderJson: '[]',
        );

        // Then
        final counter = await db.getSectionCounter(counterId);
        expect(counter, isNull);

        final runs = await db.getSectionRuns(counterId);
        expect(runs, isEmpty);
      });
    });
  });
}
