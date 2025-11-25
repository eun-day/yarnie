import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../db/di.dart'; // appDb 인스턴스
import 'projects_notifier.dart'; // ProjectsNotifier에 프로젝트 생성/업데이트 이벤트를 전달하기 위함
import 'projects_event.dart'; // CreateProject, UpdateProject 이벤트
import 'projects_effect.dart'; // ProjectCreated, ProjectUpdated 이벤트 (ProjectsNotifier에서 옴)

import 'project_form_state.dart';
import 'project_form_event.dart';
import 'project_form_effect.dart';

class ProjectFormNotifier extends Notifier<ProjectFormState> {
  final _effectController = StreamController<ProjectFormEffect>.broadcast();

  Stream<ProjectFormEffect> get effects => _effectController.stream;

  @override
  ProjectFormState build() {
    ref.onDispose(() {
      _effectController.close();
    });

    ref.listen(projectsEffectsProvider, (_, asyncEffect) {
      asyncEffect.whenData((effect) {
        if (effect is ProjectCreated) {
          _emit(CloseProjectForm(effect.projectId));
        } else if (effect is ProjectUpdated) {
          _emit(CloseProjectForm(effect.projectId));
        }
      });
    });

    // Do not load data here, wait for the event from the UI.
    return const ProjectFormState();
  }

  Future<void> onEvent(ProjectFormEvent event) async {
    switch (event) {
      case LoadProjectData(:final projectId):
        await _loadProjectData(projectId);
      case ProjectNameChanged(:final name):
        state = state.copyWith(name: name);
      case NeedleTypeChanged(:final needleType):
        _handleNeedleTypeChange(needleType);
      case NeedleSizeChanged(:final needleSize):
        state = state.copyWith(needleSize: needleSize);
      case LotNumberChanged(:final lotNumber):
        state = state.copyWith(lotNumber: lotNumber);
      case MemoChanged(:final memo):
        state = state.copyWith(memo: memo);
      case ImagePathChanged(:final imagePath):
        state = state.copyWith(imagePath: imagePath);
      case ToggleTagSelected(:final tagId):
        _toggleTagSelected(tagId);
      case SaveProject():
        await _saveProject();
      case UpdateSelectedTags(:final tagIds):
        state = state.copyWith(selectedTagIds: tagIds);
    }
  }

  Future<void> _loadProjectData(int? projectId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Always load all available tags for the form.
      final allTags = await appDb.getAllTags();

      if (projectId == null) {
        // CREATE MODE
        state = state.copyWith(
          initialProjectId: null,
          initialProject: null,
          name: '',
          imagePath: null,
          needleType: null,
          needleSize: null,
          lotNumber: null,
          memo: null,
          selectedTagIds: {},
          allAvailableTags: allTags, // Set the tags
          isLoading: false,
        );
      } else {
        // EDIT MODE
        final project = await (appDb.select(appDb.projects)..where((p) => p.id.equals(projectId))).getSingleOrNull();
        if (project == null) {
          throw '프로젝트를 찾을 수 없습니다.';
        }

        final needleTypeEnum = project.needleType != null
            ? NeedleType.values.firstWhere((e) => e.toString().split('.').last == project.needleType, orElse: () => NeedleType.knitting)
            : null;

        state = state.copyWith(
          initialProjectId: projectId,
          initialProject: project,
          name: project.name,
          imagePath: project.imagePath,
          needleType: needleTypeEnum,
          needleSize: project.needleSize,
          availableNeedleSizes: getNeedleSizesForType(needleTypeEnum),
          lotNumber: project.lotNumber,
          memo: project.memo,
          selectedTagIds: _parseTagIds(project.tagIds).toSet(),
          allAvailableTags: allTags, // Also set the tags here
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '데이터 로드 실패: $e');
      _emit(ShowProjectFormErrorMessage('데이터 로드 실패: $e'));
    }
  }

  void _handleNeedleTypeChange(String? typeString) {
    NeedleType? newNeedleType;
    if (typeString != null) {
      newNeedleType = NeedleType.values.firstWhere(
        (e) => e.toString().split('.').last == typeString,
        orElse: () => NeedleType.knitting, // 기본값
      );
    }

    final newAvailableSizes = getNeedleSizesForType(newNeedleType);
    final newNeedleSize = newAvailableSizes.contains(state.needleSize) ? state.needleSize : null; // 기존 사이즈 유지 또는 초기화

    state = state.copyWith(
      needleType: newNeedleType,
      availableNeedleSizes: newAvailableSizes,
      needleSize: newNeedleSize,
    );
  }

  void _toggleTagSelected(int tagId) {
    final updatedTags = Set<int>.from(state.selectedTagIds);
    if (updatedTags.contains(tagId)) {
      updatedTags.remove(tagId);
    } else {
      updatedTags.add(tagId);
    }
    state = state.copyWith(selectedTagIds: updatedTags);
  }

  Future<void> _saveProject() async {
    if (!state.isValid) {
      _emit(const ShowProjectFormErrorMessage('프로젝트 이름을 입력해주세요.'));
      return;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final projectsNotifier = ref.read(projectsProvider.notifier);
      if (state.isEditMode && state.initialProjectId != null) {
        // 프로젝트 수정
        await projectsNotifier.onEvent(
          UpdateProject(
            projectId: state.initialProjectId!,
            name: state.name,
            needleType: state.needleType?.toString().split('.').last,
            needleSize: state.needleSize,
            lotNumber: state.lotNumber,
            memo: state.memo,
            imagePath: state.imagePath,
            tagIds: state.selectedTagIds.toList(),
          ),
        );

      } else {
        // 새 프로젝트 생성
        await projectsNotifier.onEvent(
          CreateProject(
            name: state.name,
            needleType: state.needleType?.toString().split('.').last,
            needleSize: state.needleSize,
            lotNumber: state.lotNumber,
            memo: state.memo,
            imagePath: state.imagePath,
            tagIds: state.selectedTagIds.toList(),
          ),
        );

      }
    } catch (e) {
      state = state.copyWith(isSaving: false, error: '프로젝트 저장 실패: $e');
      _emit(ShowProjectFormErrorMessage('프로젝트 저장 실패: $e'));
    }
  }

  // 헬퍼: DB에서 불러온 JSON 문자열 태그 ID 파싱
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

  void _emit(ProjectFormEffect effect) {
    _effectController.add(effect);
  }
}

final projectFormNotifierProvider =
    NotifierProvider.autoDispose<ProjectFormNotifier, ProjectFormState>(
  ProjectFormNotifier.new,
);

final projectFormEffectsProvider = StreamProvider.autoDispose<ProjectFormEffect>((ref) {
  final notifier = ref.watch(projectFormNotifierProvider.notifier);
  return notifier.effects;
});