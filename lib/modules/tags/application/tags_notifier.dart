import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../db/app_db.dart';
import '../../../db/di.dart';
import 'tags_state.dart';
import 'tags_event.dart';
import 'tags_effect.dart';

/// 태그 관리 Notifier
class TagsNotifier extends Notifier<TagsState> {
  StreamSubscription<List<Tag>>? _sub;
  final _effectController = StreamController<TagsEffect>.broadcast();

  Stream<TagsEffect> get effects => _effectController.stream;

  @override
  TagsState build() {
    ref.onDispose(() {
      _sub?.cancel();
      _effectController.close();
    });
    return const TagsState();
  }

  /// 이벤트 처리
  Future<void> onEvent(TagsEvent event) async {
    switch (event) {
      case LoadTags():
        await _loadTags();

      case TagsUpdated(:final tags):
        state = state.copyWith(allTags: tags, isLoading: false, error: null);
        _applySearch();

      case ShowTagError(:final message):
        state = state.copyWith(error: message, isLoading: false);
        _emit(ShowTagErrorMessage(message));

      case SearchTags(:final query):
        _searchTags(query);

      case ToggleTagSelection(:final tagId):
        _toggleSelection(tagId);

      case ClearTagSelection():
        state = state.copyWith(selectedTagIds: {});

      case CreateTag(:final name, :final color):
        await _createTag(name, color);

      case UpdateTag(:final tagId, :final newName, :final newColor):
        await _updateTag(tagId, newName, newColor);

      case DeleteTag(:final tagId):
        await _deleteTag(tagId);
    }
  }

  /// 태그 목록 로드
  Future<void> _loadTags() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final tags = await appDb.getAllTags();
      onEvent(TagsUpdated(tags));
    } catch (e) {
      onEvent(ShowTagError('태그 로드 실패: $e'));
    }
  }

  /// 태그 검색
  void _searchTags(String query) {
    state = state.copyWith(searchQuery: query);
    _applySearch();
  }

  /// 검색 필터 적용
  void _applySearch() {
    if (state.searchQuery.isEmpty) {
      state = state.copyWith(filteredTags: []);
      return;
    }

    final query = state.searchQuery.toLowerCase();
    final filtered = state.allTags
        .where((tag) => tag.name.toLowerCase().contains(query))
        .toList(growable: false);

    state = state.copyWith(filteredTags: filtered);
  }

  /// 태그 선택/해제 토글
  void _toggleSelection(int tagId) {
    final next = {...state.selectedTagIds};
    if (!next.add(tagId)) next.remove(tagId);
    state = state.copyWith(selectedTagIds: next);
  }

  /// 태그 생성
  Future<void> _createTag(String name, int color) async {
    if (name.trim().isEmpty) {
      _emit(const ShowTagErrorMessage('태그 이름을 입력해주세요'));
      return;
    }

    try {
      await appDb.createTag(name: name.trim(), color: color);
      _emit(const ShowTagSuccessMessage('태그가 생성되었습니다'));
      // 목록 새로고침
      await _loadTags();
    } catch (e) {
      _emit(ShowTagErrorMessage('태그 생성 실패: $e'));
    }
  }

  /// 태그 수정
  Future<void> _updateTag(int tagId, String? newName, int? newColor) async {
    if (newName != null && newName.trim().isEmpty) {
      _emit(const ShowTagErrorMessage('태그 이름을 입력해주세요'));
      return;
    }

    try {
      await appDb.updateTag(
          tagId: tagId,
          name: newName?.trim(), // name이 null이면 전달 안함
          color: newColor // color가 null이면 전달 안함
      );
      _emit(const ShowTagSuccessMessage('태그가 수정되었습니다'));
      // 목록 새로고침
      await _loadTags();
    } catch (e) {
      _emit(ShowTagErrorMessage('태그 수정 실패: $e'));
    }
  }

  /// 태그 삭제
  Future<void> _deleteTag(int tagId) async {
    try {
      await appDb.deleteTag(tagId);
      _emit(const ShowTagSuccessMessage('태그가 삭제되었습니다'));
      // 목록 새로고침
      await _loadTags();
    } catch (e) {
      _emit(ShowTagErrorMessage('태그 삭제 실패: $e'));
    }
  }

  /// Effect 발행
  void _emit(TagsEffect effect) {
    _effectController.add(effect);
  }
}

/// State Provider
final tagsProvider = NotifierProvider.autoDispose<TagsNotifier, TagsState>(
  TagsNotifier.new,
);

/// Effect Stream Provider
final tagsEffectsProvider = StreamProvider.autoDispose<TagsEffect>((ref) {
  final notifier = ref.watch(tagsProvider.notifier);
  return notifier.effects;
});
