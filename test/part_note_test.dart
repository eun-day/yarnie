import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_helpers.dart';
import 'helpers/database_test_base.dart';

void main() {
  databaseTestGroup('PartNote 데이터베이스 작업', (getDb, getProjectId) {
    late int partId;

    setUp(() async {
      // Part 생성 (MainCounter 자동 생성됨)
      partId = await getDb().createPart(
        projectId: getProjectId(),
        name: 'Test Part',
      );
    });

    test('PartNote 생성', () async {
      // Given & When
      final noteId = await getDb().createPartNote(
        partId: partId,
        content: '테스트 메모입니다',
        isPinned: false,
      );

      // Then
      expect(noteId, greaterThan(0));

      final note = await getDb().getPartNote(noteId);
      expect(note, isNotNull);
      expect(note!.content, '테스트 메모입니다');
      expect(note.isPinned, false);
      expect(note.partId, partId);
    });

    test('PartNote 업데이트', () async {
      // Given
      final noteId = await getDb().createPartNote(
        partId: partId,
        content: '원본 메모',
        isPinned: false,
      );

      // When
      await getDb().updatePartNote(
        noteId: noteId,
        content: '수정된 메모',
        isPinned: true,
      );

      // Then
      final note = await getDb().getPartNote(noteId);
      expect(note, isNotNull);
      expect(note!.content, '수정된 메모');
      expect(note.isPinned, true);
    });

    test('PartNote 삭제', () async {
      // Given
      final noteId = await getDb().createPartNote(
        partId: partId,
        content: '삭제할 메모',
      );

      // When
      await getDb().deletePartNote(noteId);

      // Then
      final note = await getDb().getPartNote(noteId);
      expect(note, isNull);
    });

    test('Part의 모든 메모 조회 (isPinned 우선 정렬)', () async {
      // Given
      await getDb().createPartNote(
        partId: partId,
        content: '일반 메모 1',
        isPinned: false,
      );

      await getDb().createPartNote(
        partId: partId,
        content: '고정 메모',
        isPinned: true,
      );

      await getDb().createPartNote(
        partId: partId,
        content: '일반 메모 2',
        isPinned: false,
      );

      // When
      final notes = await getDb().getPartNotes(partId);

      // Then
      expect(notes.length, 3);
      // 첫 번째는 고정된 메모여야 함
      expect(notes[0].isPinned, true);
      expect(notes[0].content, '고정 메모');
      // 나머지는 일반 메모 (최신순)
      expect(notes[1].isPinned, false);
      expect(notes[2].isPinned, false);
    });

    test('Part 삭제 시 메모도 cascade 삭제', () async {
      // Given
      final noteId = await getDb().createPartNote(
        partId: partId,
        content: '삭제될 메모',
      );

      // When
      await getDb().deletePart(partId);

      // Then
      final note = await getDb().getPartNote(noteId);
      expect(note, isNull);
    });

    test('여러 Part의 메모가 독립적으로 관리됨', () async {
      // Given
      final part2Id = await getDb().createPart(
        projectId: getProjectId(),
        name: 'Test Part 2',
      );

      await getDb().createPartNote(partId: partId, content: 'Part 1 메모');

      await getDb().createPartNote(partId: part2Id, content: 'Part 2 메모');

      // When
      final part1Notes = await getDb().getPartNotes(partId);
      final part2Notes = await getDb().getPartNotes(part2Id);

      // Then
      expect(part1Notes.length, 1);
      expect(part1Notes[0].content, 'Part 1 메모');

      expect(part2Notes.length, 1);
      expect(part2Notes[0].content, 'Part 2 메모');
    });
  });
}
