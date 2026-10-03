import 'dart:convert';
import '../../../db/app_db.dart';

enum StashViewMode {
  smallCard,
  list,
}

/// 보관함 목록 정렬 기준
enum StashSortOrder {
  newest, // 최신 등록순 (기본)
  name, // 제품명순
  brand, // 브랜드순
}

class StashState {
  final List<StashYarn> allYarns;
  final List<StashYarn> filteredYarns;
  final List<StashTag> allTags;
  final Set<int> selectedTagIds;
  final String searchQuery;
  final String? yarnWeightFilter; // 굵기 필터 (null이면 전체)
  final StashSortOrder sortOrder;
  final StashViewMode viewMode;
  final bool isLoading;
  final String? error;

  const StashState({
    this.allYarns = const [],
    this.filteredYarns = const [],
    this.allTags = const [],
    this.selectedTagIds = const {},
    this.searchQuery = '',
    this.yarnWeightFilter,
    this.sortOrder = StashSortOrder.newest,
    this.viewMode = StashViewMode.smallCard,
    this.isLoading = false,
    this.error,
  });

  bool get hasActiveFilters =>
      selectedTagIds.isNotEmpty || searchQuery.isNotEmpty || yarnWeightFilter != null;

  /// 필터와 정렬을 적용한 목록 (StashNotifier._applyFilters가 항상 계산)
  List<StashYarn> get displayYarns => filteredYarns;

  bool get isEmpty => allYarns.isEmpty;

  bool get isFilteredEmpty => hasActiveFilters && filteredYarns.isEmpty;

  StashState copyWith({
    List<StashYarn>? allYarns,
    List<StashYarn>? filteredYarns,
    List<StashTag>? allTags,
    Set<int>? selectedTagIds,
    String? searchQuery,
    String? yarnWeightFilter,
    bool clearYarnWeightFilter = false,
    StashSortOrder? sortOrder,
    StashViewMode? viewMode,
    bool? isLoading,
    String? error,
  }) {
    return StashState(
      allYarns: allYarns ?? this.allYarns,
      filteredYarns: filteredYarns ?? this.filteredYarns,
      allTags: allTags ?? this.allTags,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      searchQuery: searchQuery ?? this.searchQuery,
      yarnWeightFilter: clearYarnWeightFilter
          ? null
          : (yarnWeightFilter ?? this.yarnWeightFilter),
      sortOrder: sortOrder ?? this.sortOrder,
      viewMode: viewMode ?? this.viewMode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

List<int> parseTagIds(String? s) {
  if (s == null || s.isEmpty) return const <int>[];
  try {
    final raw = jsonDecode(s);
    if (raw is List) {
      return raw.cast<num>().map((e) => e.toInt()).toList(growable: false);
    }
  } catch (_) {}
  return const <int>[];
}
