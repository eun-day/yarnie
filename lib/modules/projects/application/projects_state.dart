import '../../../db/app_db.dart';

/// 뷰 모드
enum ProjectViewMode {
  largeCard, // 큰 카드
  smallCard, // 작은 카드
  list, // 리스트
}

/// 프로젝트 목록 화면 상태
class ProjectsState {
  final List<Project> allProjects;
  final List<Project> filteredProjects;
  final List<Tag> allTags;
  final Set<int> selectedTagIds;
  final ProjectViewMode viewMode;
  final bool isLoading;
  final String? error;

  const ProjectsState({
    this.allProjects = const [],
    this.filteredProjects = const [],
    this.allTags = const [],
    this.selectedTagIds = const {},
    this.viewMode = ProjectViewMode.largeCard,
    this.isLoading = false,
    this.error,
  });

  /// 필터가 활성화되어 있는지
  bool get hasActiveFilters => selectedTagIds.isNotEmpty;

  /// 표시할 프로젝트 목록
  List<Project> get displayProjects =>
      hasActiveFilters ? filteredProjects : allProjects;

  /// 빈 상태인지 (프로젝트가 하나도 없음)
  bool get isEmpty => allProjects.isEmpty;

  /// 필터 결과가 없는지
  bool get isFilteredEmpty => hasActiveFilters && filteredProjects.isEmpty;

  /// copyWith
  ProjectsState copyWith({
    List<Project>? allProjects,
    List<Project>? filteredProjects,
    List<Tag>? allTags,
    Set<int>? selectedTagIds,
    ProjectViewMode? viewMode,
    bool? isLoading,
    String? error,
  }) {
    return ProjectsState(
      allProjects: allProjects ?? this.allProjects,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      allTags: allTags ?? this.allTags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      viewMode: viewMode ?? this.viewMode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
