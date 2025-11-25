import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../db/app_db.dart';
import '../../../db/di.dart';
import 'projects_state.dart';
import 'projects_event.dart';
import 'projects_effect.dart';

// ============================================================
// JSON 파싱 헬퍼
// ============================================================

/// 태그 ID JSON 파싱
List<int> _parseTagIds(String? s) {
  if (s == null || s.isEmpty) return const <int>[];
  try {
    final raw = jsonDecode(s);
    if (raw is List) {
      return raw.cast<num>().map((e) => e.toInt()).toList(growable: false);
    }
  } catch (_) {}
  return const <int>[];
}

/// 프로젝트 목록 Notifier
class ProjectsNotifier extends Notifier<ProjectsState> {
  StreamSubscription<List<Project>>? _projectsSubscription;
  final _effectController = StreamController<ProjectsEffect>.broadcast();

  Stream<ProjectsEffect> get effects => _effectController.stream;

  @override
  ProjectsState build() {
    // 초기 상태만 반환 (비동기 로드는 UI에서 LoadProjects 이벤트로 시작)
    ref.onDispose(() {
      _projectsSubscription?.cancel();
      _effectController.close();
    });
    return const ProjectsState();
  }

  /// 이벤트 처리
  Future<void> onEvent(ProjectsEvent event) async {
    switch (event) {
      case LoadProjects():
        await _loadData();

      case ProjectsUpdated(:final projects):
        // 필터링과 상태 업데이트를 한 번에 처리
        final ids = state.selectedTagIds;
        final filtered = ids.isEmpty
            ? projects
            : projects
                  .where((p) => ids.every(_parseTagIds(p.tagIds).contains))
                  .toList(growable: false);
        state = state.copyWith(
          allProjects: projects,
          filteredProjects: filtered,
          isLoading: false,
          error: null,
        );

      case ShowError(:final message):
        state = state.copyWith(error: message, isLoading: false);
        _emit(ShowErrorMessage(message));

      case ChangeViewMode(:final viewMode):
        state = state.copyWith(viewMode: viewMode);

      case ToggleTagFilter(:final tagId):
        _toggleTagFilter(tagId);

      case ClearFilters():
        state = state.copyWith(selectedTagIds: {});
        _applyFilters();

      case OpenProject(:final projectId):
        _emit(NavigateToProjectDetail(projectId));

      case DuplicateProject(:final projectId):
        await _duplicateProject(projectId);

      case OpenAssignTagsDialog(:final projectId):
        _openAssignTagsDialog(projectId);

      case AssignTagsToProject(:final projectId, :final tagIds):
        await _assignTags(projectId, tagIds);

      case CreateProject():
        await _createProject(event);

      case UpdateProject():
        await _updateProject(event);

      case DeleteProject(:final projectId):
        await _deleteProject(projectId);
    }
  }

  /// 데이터 로드 (stream 구독)
  Future<void> _loadData() async {
    // 중복 로드 방지
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 태그 목록 로드
      final tags = await appDb.getAllTags();

      // 프로젝트 목록 stream 구독 (자동 반영)
      await _projectsSubscription?.cancel();
      _projectsSubscription = appDb.watchAll().listen(
        (projects) => onEvent(ProjectsUpdated(projects)),
        onError: (e, st) => onEvent(ShowError('프로젝트 로드 실패: $e')),
      );

      state = state.copyWith(allTags: tags);
    } catch (e) {
      await _projectsSubscription?.cancel();
      onEvent(ShowError('초기화 실패: $e'));
    }
  }

  /// 태그 필터 토글 (필터링까지 한 번에 처리)
  void _toggleTagFilter(int tagId) {
    final next = {...state.selectedTagIds};
    if (!next.add(tagId)) next.remove(tagId);

    final ids = next;
    final src = state.allProjects;
    final filtered = ids.isEmpty
        ? src
        : src
              .where((p) => ids.every(_parseTagIds(p.tagIds).contains))
              .toList(growable: false);

    state = state.copyWith(selectedTagIds: next, filteredProjects: filtered);
  }

  /// 필터 적용
  void _applyFilters() {
    final ids = state.selectedTagIds;
    final src = state.allProjects;

    final filtered = ids.isEmpty
        ? src
        : src
              .where((p) => ids.every(_parseTagIds(p.tagIds).contains))
              .toList(growable: false);

    state = state.copyWith(filteredProjects: filtered);
  }

  /// 프로젝트 복사
  Future<void> _duplicateProject(int projectId) async {
    try {
      final original = _projectById(projectId);
      if (original == null) {
        _emit(const ShowErrorMessage('프로젝트를 찾을 수 없습니다'));
        return;
      }

      // 새 프로젝트 생성
      final newId = await appDb.createProject(
        name: '${original.name} (복사)',
        needleType: original.needleType,
        needleSize: original.needleSize,
        lotNumber: original.lotNumber,
        memo: original.memo,
      );

      // 태그 복사
      final tagIds = _parseTagIds(original.tagIds);
      if (tagIds.isNotEmpty) {
        await appDb.updateProjectTags(projectId: newId, tagIds: tagIds);
      }

      _emit(const ShowSuccessMessage('프로젝트가 복사되었습니다'));
    } catch (e) {
      _emit(ShowErrorMessage('프로젝트 복사 실패: $e'));
    }
  }

  /// 태그 지정 다이얼로그 열기
  void _openAssignTagsDialog(int projectId) {
    final project = _projectById(projectId);
    if (project == null) {
      _emit(const ShowErrorMessage('프로젝트를 찾을 수 없습니다'));
      return;
    }

    _emit(ShowAssignTagsDialog(projectId, _parseTagIds(project.tagIds)));
  }

  /// 태그 지정
  Future<void> _assignTags(int projectId, List<int> tagIds) async {
    try {
      await appDb.updateProjectTags(projectId: projectId, tagIds: tagIds);
      _emit(const ShowSuccessMessage('태그가 지정되었습니다'));
    } catch (e) {
      _emit(ShowErrorMessage('태그 지정 실패: $e'));
    }
  }

  /// ID로 프로젝트 찾기
  Project? _projectById(int id) {
    try {
      return state.allProjects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 프로젝트 생성
  Future<void> _createProject(CreateProject event) async {
    try {
      final projectId = await appDb.createProject(
        name: event.name,
        needleType: event.needleType,
        needleSize: event.needleSize,
        lotNumber: event.lotNumber,
        memo: event.memo,
      );

      // 이미지 설정
      if (event.imagePath != null) {
        await appDb.updateProjectImage(
          projectId: projectId,
          imagePath: event.imagePath,
        );
      }

      // 태그 지정
      if (event.tagIds.isNotEmpty) {
        await appDb.updateProjectTags(
          projectId: projectId,
          tagIds: event.tagIds,
        );
      }

      _emit(ProjectCreated(projectId));
      _emit(const ShowSuccessMessage('프로젝트가 생성되었습니다'));
    } catch (e) {
      _emit(ShowErrorMessage('프로젝트 생성 실패: $e'));
    }
  }

  /// 프로젝트 수정
  Future<void> _updateProject(UpdateProject event) async {
    try {
      final project = _projectById(event.projectId);
      if (project == null) {
        _emit(const ShowErrorMessage('프로젝트를 찾을 수 없습니다'));
        return;
      }

      // ProjectsCompanion으로 업데이트
      await appDb.updateProject(
        ProjectsCompanion(
          id: Value(event.projectId),
          name: Value(event.name),
          needleType: Value(event.needleType),
          needleSize: Value(event.needleSize),
          lotNumber: Value(event.lotNumber),
          memo: Value(event.memo),
        ),
      );

      // 이미지 업데이트
      await appDb.updateProjectImage(
        projectId: event.projectId,
        imagePath: event.imagePath,
      );

      // 태그 업데이트
      await appDb.updateProjectTags(
        projectId: event.projectId,
        tagIds: event.tagIds,
      );

      _emit(ProjectUpdated(event.projectId));
      _emit(const ShowSuccessMessage('프로젝트가 수정되었습니다'));
    } catch (e) {
      _emit(ShowErrorMessage('프로젝트 수정 실패: $e'));
    }
  }

  /// 프로젝트 삭제
  Future<void> _deleteProject(int projectId) async {
    try {
      final project = _projectById(projectId);
      if (project == null) {
        _emit(const ShowErrorMessage('프로젝트를 찾을 수 없습니다'));
        return;
      }

      // Drift의 delete 메서드 사용
      await (appDb.delete(
        appDb.projects,
      )..where((tbl) => tbl.id.equals(projectId))).go();

      _emit(const ProjectDeleted());
      _emit(const ShowSuccessMessage('프로젝트가 삭제되었습니다'));
    } catch (e) {
      _emit(ShowErrorMessage('프로젝트 삭제 실패: $e'));
    }
  }

  /// Effect 발행
  void _emit(ProjectsEffect effect) {
    _effectController.add(effect);
  }
}

/// State Provider
final projectsProvider =
    NotifierProvider.autoDispose<ProjectsNotifier, ProjectsState>(
      ProjectsNotifier.new,
    );

/// Effect Stream Provider (위젯에서 ref.listen 사용)
final projectsEffectsProvider = StreamProvider.autoDispose<ProjectsEffect>((
  ref,
) {
  final notifier = ref.watch(projectsProvider.notifier);
  return notifier.effects;
});
