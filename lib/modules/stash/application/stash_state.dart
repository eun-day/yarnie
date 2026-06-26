import 'dart:convert';
import '../../../db/app_db.dart';

enum StashViewMode {
  smallCard,
  list,
}

class StashState {
  final List<StashYarn> allYarns;
  final List<StashYarn> filteredYarns;
  final List<StashTag> allTags;
  final Set<int> selectedTagIds;
  final String searchQuery;
  final StashViewMode viewMode;
  final bool isLoading;
  final String? error;

  const StashState({
    this.allYarns = const [],
    this.filteredYarns = const [],
    this.allTags = const [],
    this.selectedTagIds = const {},
    this.searchQuery = '',
    this.viewMode = StashViewMode.smallCard,
    this.isLoading = false,
    this.error,
  });

  bool get hasActiveFilters => selectedTagIds.isNotEmpty || searchQuery.isNotEmpty;

  List<StashYarn> get displayYarns =>
      hasActiveFilters ? filteredYarns : allYarns;

  bool get isEmpty => allYarns.isEmpty;

  bool get isFilteredEmpty => hasActiveFilters && filteredYarns.isEmpty;

  StashState copyWith({
    List<StashYarn>? allYarns,
    List<StashYarn>? filteredYarns,
    List<StashTag>? allTags,
    Set<int>? selectedTagIds,
    String? searchQuery,
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
