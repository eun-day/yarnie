import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Part 데이터베이스 작업', () {
    late AppDb db;

    setUp(() async {
      db = createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    group('Part CRUD 작업', () {
      test('Part 생성 시 MainCounter가 자동으로 생성된다', () async {
        // Given
        final projectId = await createTestProject(db);

        // When
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        // Then
        final part = await db.getPart(partId);
        expect(part, isNotNull);
        expect(part!.name, 'Test Part');
        expect(part.projectId, projectId);

        // MainCounter 자동 생성 확인
        final mainCounter = await db.getMainCounter(partId);
        expect(mainCounter, isNotNull);
        expect(mainCounter!.partId, partId);
        expect(mainCounter.currentValue, 0);
      });

      test('Part 생성 시 orderIndex가 자동으로 설정된다', () async {
        // Given
        final projectId = await createTestProject(db);

        // When
        final partId1 = await db.createPart(
          projectId: projectId,
          name: 'Part 1',
        );
        final partId2 = await db.createPart(
          projectId: projectId,
          name: 'Part 2',
        );
        final partId3 = await db.createPart(
          projectId: projectId,
          name: 'Part 3',
        );

        // Then
        final part1 = await db.getPart(partId1);
        final part2 = await db.getPart(partId2);
        final part3 = await db.getPart(partId3);

        expect(part1!.orderIndex, 0);
        expect(part2!.orderIndex, 1);
        expect(part3!.orderIndex, 2);
      });

      test('Part 생성 시 orderIndex를 명시적으로 지정할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);

        // When
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
          orderIndex: 5,
        );

        // Then
        final part = await db.getPart(partId);
        expect(part!.orderIndex, 5);
      });

      test('프로젝트의 모든 Part를 순서대로 조회할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        await db.createPart(projectId: projectId, name: 'Part 1');
        await db.createPart(projectId: projectId, name: 'Part 2');
        await db.createPart(projectId: projectId, name: 'Part 3');

        // When
        final parts = await db.getProjectParts(projectId);

        // Then
        expect(parts.length, 3);
        expect(parts[0].name, 'Part 1');
        expect(parts[1].name, 'Part 2');
        expect(parts[2].name, 'Part 3');
        expect(parts[0].orderIndex, 0);
        expect(parts[1].orderIndex, 1);
        expect(parts[2].orderIndex, 2);
      });

      test('Part를 업데이트할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Old Name',
        );
        final partBefore = await db.getPart(partId);

        // When
        await db.updatePart(
          partBefore!.copyWith(name: 'New Name').toCompanion(true),
        );

        // Then
        final part = await db.getPart(partId);
        expect(part!.name, 'New Name');
        expect(part.updatedAt, isNotNull);
      });

      test('Part 삭제 시 관련 데이터가 cascade 삭제된다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        // StitchCounter 생성
        await db.createStitchCounter(
          partId: partId,
          name: 'Test Stitch',
          newOrderJson: '[{"type":"stitch","id":1}]',
        );

        // PartNote 생성
        await db.createPartNote(partId: partId, content: 'Test Note');

        // When
        await db.deletePart(partId);

        // Then
        final part = await db.getPart(partId);
        expect(part, isNull);

        // MainCounter도 삭제되었는지 확인
        final mainCounter = await db.getMainCounter(partId);
        expect(mainCounter, isNull);

        // StitchCounter도 삭제되었는지 확인
        final stitchCounters = await db.getPartStitchCounters(partId);
        expect(stitchCounters, isEmpty);

        // PartNote도 삭제되었는지 확인
        final notes = await db.getPartNotes(partId);
        expect(notes, isEmpty);
      });
    });

    group('Part 순서 관리', () {
      test('Part 순서를 변경할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId1 = await db.createPart(
          projectId: projectId,
          name: 'Part 1',
        );
        final partId2 = await db.createPart(
          projectId: projectId,
          name: 'Part 2',
        );
        final partId3 = await db.createPart(
          projectId: projectId,
          name: 'Part 3',
        );

        // When: Part 순서를 [3, 1, 2]로 변경
        await db.reorderParts(
          projectId: projectId,
          partIds: [partId3, partId1, partId2],
        );

        // Then
        final parts = await db.getProjectParts(projectId);
        expect(parts[0].id, partId3);
        expect(parts[0].orderIndex, 0);
        expect(parts[1].id, partId1);
        expect(parts[1].orderIndex, 1);
        expect(parts[2].id, partId2);
        expect(parts[2].orderIndex, 2);
      });

      test('Part 순서 변경 시 updatedAt이 업데이트된다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId1 = await db.createPart(
          projectId: projectId,
          name: 'Part 1',
        );
        final partId2 = await db.createPart(
          projectId: projectId,
          name: 'Part 2',
        );

        await Future.delayed(Duration(milliseconds: 100));

        // When
        await db.reorderParts(
          projectId: projectId,
          partIds: [partId2, partId1],
        );

        // Then
        final part1After = await db.getPart(partId1);
        expect(part1After!.updatedAt, isNotNull);
      });
    });

    group('BuddyCounter 순서 관리', () {
      test('BuddyCounter 순서를 JSON으로 저장할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final orderJson =
            '[{"type":"stitch","id":1},{"type":"section","id":2}]';

        // When
        await db.reorderBuddyCounters(partId: partId, newOrderJson: orderJson);

        // Then
        final part = await db.getPart(partId);
        expect(part!.buddyCounterOrder, orderJson);
      });

      test('BuddyCounter 순서 변경 시 updatedAt이 업데이트된다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        await Future.delayed(Duration(milliseconds: 100));

        // When
        await db.reorderBuddyCounters(
          partId: partId,
          newOrderJson: '[{"type":"stitch","id":1}]',
        );

        // Then
        final partAfter = await db.getPart(partId);
        expect(partAfter!.updatedAt, isNotNull);
      });
    });

    group('Part Stream 조회', () {
      test('프로젝트의 Part 변경사항을 Stream으로 감지할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final stream = db.watchProjectParts(projectId);

        // When & Then
        expectLater(
          stream,
          emitsInOrder([
            [], // 초기 상태
            predicate<List<Part>>((parts) => parts.length == 1), // Part 추가 후
          ]),
        );

        await Future.delayed(Duration(milliseconds: 10));
        await db.createPart(projectId: projectId, name: 'Test Part');
      });
    });
  });
}
