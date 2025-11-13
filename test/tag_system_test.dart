import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'helpers/database_test_base.dart';

void main() {
  databaseTestGroup('Tag 시스템 테스트', (getDb, getProjectId) {
    late AppDb db;
    late int projectId;

    setUp(() {
      db = getDb();
      projectId = getProjectId();
    });
    group('Tag CRUD 작업', () {
      test('Tag 생성', () async {
        // Given & When
        final tagId = await db.createTag(name: '뜨개질', color: 0xFFE91E63);

        // Then
        expect(tagId, greaterThan(0));

        final tag = await db.getTag(tagId);
        expect(tag, isNotNull);
        expect(tag!.name, '뜨개질');
        expect(tag.color, 0xFFE91E63);
      });

      test('Tag 업데이트', () async {
        // Given
        final tagId = await db.createTag(name: '뜨개질', color: 0xFFE91E63);

        // When
        await db.updateTag(tagId: tagId, name: '코바늘', color: 0xFF2196F3);

        // Then
        final tag = await db.getTag(tagId);
        expect(tag!.name, '코바늘');
        expect(tag.color, 0xFF2196F3);
      });

      test('모든 태그 조회 (이름순)', () async {
        // Given
        await db.createTag(name: 'C태그', color: 0xFF000000);
        await db.createTag(name: 'A태그', color: 0xFF000000);
        await db.createTag(name: 'B태그', color: 0xFF000000);

        // When
        final tags = await db.getAllTags();

        // Then
        expect(tags.length, greaterThanOrEqualTo(3));
        // 이름순 정렬 확인
        final names = tags.map((t) => t.name).toList();
        final sortedNames = [...names]..sort();
        expect(names, sortedNames);
      });

      test('태그 이름으로 검색', () async {
        // Given
        await db.createTag(name: '뜨개질', color: 0xFF000000);
        await db.createTag(name: '코바늘', color: 0xFF000000);
        await db.createTag(name: '대바늘', color: 0xFF000000);

        // When
        final results = await db.searchTags('바늘');

        // Then
        expect(results.length, 2);
        expect(results.any((t) => t.name == '코바늘'), true);
        expect(results.any((t) => t.name == '대바늘'), true);
      });
    });

    group('Tag 삭제 시 프로젝트 정리', () {
      test('Tag 삭제 시 모든 프로젝트의 tagIds에서 제거', () async {
        // Given
        final tag1Id = await db.createTag(name: '태그1', color: 0xFF000000);
        final tag2Id = await db.createTag(name: '태그2', color: 0xFF000000);
        final tag3Id = await db.createTag(name: '태그3', color: 0xFF000000);

        // 프로젝트에 태그 연결
        await db.updateProjectTags(
          projectId: projectId,
          tagIds: [tag1Id, tag2Id, tag3Id],
        );

        // When
        await db.deleteTag(tag2Id);

        // Then
        final projectTags = await db.getProjectTags(projectId);
        expect(projectTags.length, 2);
        expect(projectTags.any((t) => t.id == tag1Id), true);
        expect(projectTags.any((t) => t.id == tag2Id), false);
        expect(projectTags.any((t) => t.id == tag3Id), true);
      });

      test('마지막 태그 삭제 시 tagIds가 null이 됨', () async {
        // Given
        final tagId = await db.createTag(name: '태그', color: 0xFF000000);
        await db.updateProjectTags(projectId: projectId, tagIds: [tagId]);

        // When
        await db.deleteTag(tagId);

        // Then
        final project = await (db.select(
          db.projects,
        )..where((t) => t.id.equals(projectId))).getSingle();
        expect(project.tagIds, isNull);
      });
    });

    group('프로젝트-태그 관계 관리', () {
      test('프로젝트의 태그 조회', () async {
        // Given
        final tag1Id = await db.createTag(name: '태그1', color: 0xFF000000);
        final tag2Id = await db.createTag(name: '태그2', color: 0xFF000000);

        await db.updateProjectTags(
          projectId: projectId,
          tagIds: [tag1Id, tag2Id],
        );

        // When
        final tags = await db.getProjectTags(projectId);

        // Then
        expect(tags.length, 2);
        expect(tags.any((t) => t.id == tag1Id), true);
        expect(tags.any((t) => t.id == tag2Id), true);
      });

      test('프로젝트의 태그 업데이트', () async {
        // Given
        final tag1Id = await db.createTag(name: '태그1', color: 0xFF000000);
        final tag2Id = await db.createTag(name: '태그2', color: 0xFF000000);
        final tag3Id = await db.createTag(name: '태그3', color: 0xFF000000);

        await db.updateProjectTags(
          projectId: projectId,
          tagIds: [tag1Id, tag2Id],
        );

        // When
        await db.updateProjectTags(
          projectId: projectId,
          tagIds: [tag2Id, tag3Id],
        );

        // Then
        final tags = await db.getProjectTags(projectId);
        expect(tags.length, 2);
        expect(tags.any((t) => t.id == tag1Id), false);
        expect(tags.any((t) => t.id == tag2Id), true);
        expect(tags.any((t) => t.id == tag3Id), true);
      });

      test('태그별 프로젝트 조회 (단일 태그)', () async {
        // Given
        final tagId = await db.createTag(name: '태그', color: 0xFF000000);
        final project2Id = await db.createProject(name: '프로젝트2');
        final project3Id = await db.createProject(name: '프로젝트3');

        await db.updateProjectTags(projectId: projectId, tagIds: [tagId]);
        await db.updateProjectTags(projectId: project2Id, tagIds: [tagId]);
        // project3는 태그 없음

        // When
        final projects = await db.getProjectsByTag(tagId);

        // Then
        expect(projects.length, 2);
        expect(projects.any((p) => p.id == projectId), true);
        expect(projects.any((p) => p.id == project2Id), true);
        expect(projects.any((p) => p.id == project3Id), false);
      });

      test('다중 태그 필터 (AND 조건)', () async {
        // Given
        final tag1Id = await db.createTag(name: '태그1', color: 0xFF000000);
        final tag2Id = await db.createTag(name: '태그2', color: 0xFF000000);
        final tag3Id = await db.createTag(name: '태그3', color: 0xFF000000);

        final project2Id = await db.createProject(name: '프로젝트2');
        final project3Id = await db.createProject(name: '프로젝트3');

        await db.updateProjectTags(
          projectId: projectId,
          tagIds: [tag1Id, tag2Id],
        );
        await db.updateProjectTags(
          projectId: project2Id,
          tagIds: [tag1Id, tag2Id, tag3Id],
        );
        await db.updateProjectTags(projectId: project3Id, tagIds: [tag1Id]);

        // When
        final projects = await db.getProjectsByTags([tag1Id, tag2Id]);

        // Then
        expect(projects.length, 2);
        expect(projects.any((p) => p.id == projectId), true);
        expect(projects.any((p) => p.id == project2Id), true);
        expect(projects.any((p) => p.id == project3Id), false);
      });

      test('빈 태그 리스트로 필터 시 모든 프로젝트 반환', () async {
        // Given
        final project2Id = await db.createProject(name: '프로젝트2');

        // When
        final projects = await db.getProjectsByTags([]);

        // Then
        expect(projects.length, greaterThanOrEqualTo(2));
        expect(projects.any((p) => p.id == projectId), true);
        expect(projects.any((p) => p.id == project2Id), true);
      });
    });
  });
}
