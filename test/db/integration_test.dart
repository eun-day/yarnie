import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('통합 테스트', () {
    late AppDb db;

    setUp(() async {
      db = createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('전체 작업 플로우: 프로젝트 생성 → Part 생성 → Counter 추가 → 세션 시작 → 일시정지', () async {
      // 1. 프로젝트 생성
      final projectId = await db.createProject(
        name: '스웨터 프로젝트',
        needleType: '대바늘',
        needleSize: '5mm',
      );
      expect(projectId, greaterThan(0));

      // 2. Part 생성 (MainCounter 자동 생성)
      final partId = await db.createPart(projectId: projectId, name: '앞판');
      expect(partId, greaterThan(0));

      // MainCounter 자동 생성 확인
      final mainCounter = await db.getMainCounter(partId);
      expect(mainCounter, isNotNull);
      expect(mainCounter!.currentValue, 0);

      // 3. StitchCounter 추가
      final stitchCounterId = await db.createStitchCounter(
        partId: partId,
        name: '무늬 카운터',
        newOrderJson: '[{"type":"stitch","id":1}]',
        countBy: 4,
      );
      expect(stitchCounterId, greaterThan(0));

      // 4. SectionCounter 추가
      final sectionCounterId = await db.createSectionCounter(
        partId: partId,
        name: '구간 카운터',
        specJson:
            '{"type":"repeat","startRow":1,"rowsPerRepeat":10,"repeatCount":5}',
        newOrderJson: '[{"type":"stitch","id":1},{"type":"section","id":1}]',
      );
      expect(sectionCounterId, greaterThan(0));

      // SectionRuns 자동 전개 확인
      final runs = await db.getSectionRuns(sectionCounterId);
      expect(runs.length, 5);

      // 5. MainCounter 값 증가
      await db.updateMainCounter(partId: partId, newValue: 10);
      final updatedMainCounter = await db.getMainCounter(partId);
      expect(updatedMainCounter!.currentValue, 10);

      // 6. 세션 시작
      final sessionId = await db.startNewSession(
        partId: partId,
        currentMainValue: 10,
      );
      expect(sessionId, greaterThan(0));

      // 첫 번째 Segment 자동 생성 확인
      final segment = await db.getCurrentSegment(sessionId);
      expect(segment, isNotNull);
      expect(segment!.startCount, 10);

      // 7. 작업 진행 (MainCounter 증가)
      await db.updateMainCounter(partId: partId, newValue: 25);

      // 8. 세션 일시정지
      await db.pauseNewSession(
        sessionId: sessionId,
        currentSegmentId: segment.id,
        currentMainValue: 25,
        segmentStartedAt: segment.startedAt,
      );

      // 세션 상태 확인
      final session = await db.getSession(partId);
      expect(session!.status, SessionStatus2.paused);

      // Segment 종료 확인
      final segments = await db.getSessionSegments(sessionId);
      expect(segments.length, 1);
      expect(segments[0].endCount, 25);
      expect(segments[0].endedAt, isNotNull);
    });

    test('복잡한 시나리오: 여러 Part, 여러 Counter, 여러 Segment', () async {
      // 1. 프로젝트 생성
      final projectId = await db.createProject(name: '복잡한 프로젝트');

      // 2. 여러 Part 생성
      final part1Id = await db.createPart(projectId: projectId, name: 'Part 1');
      final part2Id = await db.createPart(projectId: projectId, name: 'Part 2');
      final part3Id = await db.createPart(projectId: projectId, name: 'Part 3');

      // 3. Part 1에 여러 Counter 추가
      await db.createStitchCounter(
        partId: part1Id,
        name: 'Stitch 1',
        newOrderJson: '[{"type":"stitch","id":1}]',
      );
      await db.createStitchCounter(
        partId: part1Id,
        name: 'Stitch 2',
        newOrderJson: '[{"type":"stitch","id":1},{"type":"stitch","id":2}]',
      );
      await db.createSectionCounter(
        partId: part1Id,
        name: 'Section 1',
        specJson: '{"type":"range","startRow":1,"rowsTotal":20}',
        newOrderJson:
            '[{"type":"stitch","id":1},{"type":"stitch","id":2},{"type":"section","id":1}]',
      );

      // 4. Part 1에서 세션 시작 → 일시정지 → 재시작 → 일시정지
      final session1Id = await db.startNewSession(
        partId: part1Id,
        currentMainValue: 0,
      );
      var segment = await db.getCurrentSegment(session1Id);

      await db.pauseNewSession(
        sessionId: session1Id,
        currentSegmentId: segment!.id,
        currentMainValue: 10,
        segmentStartedAt: segment.startedAt,
      );

      await db.resumeNewSession(
        sessionId: session1Id,
        partId: part1Id,
        currentMainValue: 10,
      );
      segment = await db.getCurrentSegment(session1Id);

      await db.pauseNewSession(
        sessionId: session1Id,
        currentSegmentId: segment!.id,
        currentMainValue: 20,
        segmentStartedAt: segment.startedAt,
      );

      // Part 1의 Segment 확인
      final part1Segments = await db.getSessionSegments(session1Id);
      expect(part1Segments.length, 2);

      // 5. Part 2에서 세션 시작
      final session2Id = await db.startNewSession(
        partId: part2Id,
        currentMainValue: 0,
      );
      segment = await db.getCurrentSegment(session2Id);

      await db.pauseNewSession(
        sessionId: session2Id,
        currentSegmentId: segment!.id,
        currentMainValue: 5,
        segmentStartedAt: segment.startedAt,
      );

      // 6. 프로젝트 전체 통계 확인
      final totalSeconds = await db.getProjectTotalSeconds(projectId);
      expect(totalSeconds, greaterThanOrEqualTo(0));

      // 7. Part 순서 변경
      await db.reorderParts(
        projectId: projectId,
        partIds: [part3Id, part1Id, part2Id],
      );

      final parts = await db.getProjectParts(projectId);
      expect(parts[0].id, part3Id);
      expect(parts[1].id, part1Id);
      expect(parts[2].id, part2Id);
    });

    test('Tag와 프로젝트 통합', () async {
      // 1. 태그 생성
      final tag1Id = await db.createTag(name: '뜨개질', color: 0xFFE91E63);
      final tag2Id = await db.createTag(name: '스웨터', color: 0xFF2196F3);

      // 2. 프로젝트 생성 및 태그 연결
      final projectId = await db.createProject(name: '스웨터 프로젝트');
      await db.updateProjectTags(
        projectId: projectId,
        tagIds: [tag1Id, tag2Id],
      );

      // 3. 프로젝트의 태그 확인
      final projectTags = await db.getProjectTags(projectId);
      expect(projectTags.length, 2);

      // 4. 태그로 프로젝트 검색
      final projects = await db.getProjectsByTag(tag1Id);
      expect(projects.any((p) => p.id == projectId), isTrue);

      // 5. 태그 삭제 시 프로젝트에서 자동 제거
      await db.deleteTag(tag1Id);
      final updatedTags = await db.getProjectTags(projectId);
      expect(updatedTags.length, 1);
      expect(updatedTags[0].id, tag2Id);
    });

    test('PartNote와 Part 통합', () async {
      // 1. 프로젝트 및 Part 생성
      final projectId = await db.createProject(name: '테스트 프로젝트');
      final partId = await db.createPart(
        projectId: projectId,
        name: 'Test Part',
      );

      // 2. 여러 메모 추가
      final note1Id = await db.createPartNote(
        partId: partId,
        content: '일반 메모 1',
      );
      final note2Id = await db.createPartNote(
        partId: partId,
        content: '고정 메모',
        isPinned: true,
      );
      final note3Id = await db.createPartNote(
        partId: partId,
        content: '일반 메모 2',
      );

      // 3. 메모 조회 (고정된 메모가 먼저)
      final notes = await db.getPartNotes(partId);
      expect(notes.length, 3);
      expect(notes[0].id, note2Id); // 고정된 메모가 첫 번째
      expect(notes[0].isPinned, isTrue);

      // 4. 메모 업데이트
      await db.updatePartNote(noteId: note1Id, content: '수정된 메모');
      final updatedNote = await db.getPartNote(note1Id);
      expect(updatedNote!.content, '수정된 메모');

      // 5. 메모 삭제
      await db.deletePartNote(note3Id);
      final remainingNotes = await db.getPartNotes(partId);
      expect(remainingNotes.length, 2);
    });

    test('Part 삭제 시 모든 관련 데이터 cascade 삭제', () async {
      // 1. 프로젝트 및 Part 생성
      final projectId = await db.createProject(name: '테스트 프로젝트');
      final partId = await db.createPart(
        projectId: projectId,
        name: 'Test Part',
      );

      // 2. 다양한 데이터 추가
      // MainCounter (자동 생성됨)
      final mainCounter = await db.getMainCounter(partId);
      expect(mainCounter, isNotNull);

      // StitchCounter
      final stitchCounterId = await db.createStitchCounter(
        partId: partId,
        name: 'Test Stitch',
        newOrderJson: '[]',
      );

      // SectionCounter
      final sectionCounterId = await db.createSectionCounter(
        partId: partId,
        name: 'Test Section',
        specJson: '{"type":"range","startRow":1,"rowsTotal":10}',
        newOrderJson: '[]',
      );

      // Session
      final sessionId = await db.startNewSession(
        partId: partId,
        currentMainValue: 0,
      );

      // PartNote
      final noteId = await db.createPartNote(
        partId: partId,
        content: 'Test Note',
      );

      // 3. Part 삭제
      await db.deletePart(partId);

      // 4. 모든 관련 데이터가 삭제되었는지 확인
      expect(await db.getPart(partId), isNull);
      expect(await db.getMainCounter(partId), isNull);
      expect(await db.getStitchCounter(stitchCounterId), isNull);
      expect(await db.getSectionCounter(sectionCounterId), isNull);
      expect(await db.getSession(partId), isNull);
      expect(await db.getPartNote(noteId), isNull);
    });
  });
}
