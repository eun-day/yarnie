import '../../../db/app_db.dart';

/// 태그 관리 상태
class TagsState {
  final List<Tag> allTags;
  final List<Tag> filteredTags;
  final String searchQuery;
  final Set<int> selectedTagIds;
  final bool isLoading;
  final String? error;

  const TagsState({
    this.allTags = const [],
    this.filteredTags = const [],
    this.searchQuery = '',
    this.selectedTagIds = const {},
    this.isLoading = false,
    this.error,
  });

  /// 표시할 태그 목록 (검색 중이면 필터링된 목록, 아니면 전체)
  List<Tag> get displayTags => searchQuery.isEmpty ? allTags : filteredTags;

  /// 빈 상태인지
  bool get isEmpty => allTags.isEmpty;

  /// copyWith
  TagsState copyWith({
    List<Tag>? allTags,
    List<Tag>? filteredTags,
    String? searchQuery,
    Set<int>? selectedTagIds,
    bool? isLoading,
    String? error,
  }) {
    return TagsState(
      allTags: allTags ?? this.allTags,
      filteredTags: filteredTags ?? this.filteredTags,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
