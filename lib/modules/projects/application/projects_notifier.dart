import 'dart:async';
import 'dart:convert';
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
