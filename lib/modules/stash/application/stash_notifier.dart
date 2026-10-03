import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io';
import 'dart:convert';
import '../../../db/app_db.dart';
import '../../../db/di.dart';
import '../../../core/utils/app_image_utils.dart';
import 'stash_effect.dart';
import 'stash_event.dart';
import 'stash_state.dart';
import 'package:yarnie/common/error_text_helper.dart';

class StashNotifier extends Notifier<StashState> {
  StreamSubscription<List<StashYarn>>? _stashSubscription;
  StreamSubscription<List<StashTag>>? _tagsSubscription;
  final _effectController = StreamController<StashEffect>.broadcast();

  Stream<StashEffect> get effects => _effectController.stream;

  @override
  StashState build() {
    ref.onDispose(() {
      _stashSubscription?.cancel();
      _tagsSubscription?.cancel();
      _effectController.close();
    });
    return const StashState();
  }

  Future<void> onEvent(StashEvent event) async {
    switch (event) {
      case LoadStash():
        await _loadData();

      case StashUpdatedEvent(:final yarns):
        // 태그 목록은 tags 스트림이 갱신
        state = state.copyWith(
          allYarns: yarns,
          isLoading: false,
          error: null,
        );
        _applyFilters();

      case StashTagsUpdated(:final tags):
        // 삭제된 태그가 필터에 남으면 결과가 0건이 되는데 선택 칩은 보이지 않으므로 함께 정리
        final existingIds = tags.map((t) => t.id).toSet();
        state = state.copyWith(
          allTags: tags,
          selectedTagIds: state.selectedTagIds.intersection(existingIds),
        );
        _applyFilters();

      case ToggleTagFilter(:final tagId):
        final next = {...state.selectedTagIds};
        if (!next.add(tagId)) next.remove(tagId);
        state = state.copyWith(selectedTagIds: next);
        _applyFilters();

      case SearchYarns(:final query):
        state = state.copyWith(searchQuery: query);
        _applyFilters();

      case FilterYarnWeight(:final yarnWeight):
        state = state.copyWith(
          yarnWeightFilter: yarnWeight,
          clearYarnWeightFilter: yarnWeight == null,
        );
        _applyFilters();

      case ChangeSortOrder(:final sortOrder):
        state = state.copyWith(sortOrder: sortOrder);
        _applyFilters();

      case ClearFilters():
        state = state.copyWith(
          selectedTagIds: const {},
          searchQuery: '',
          clearYarnWeightFilter: true,
        );
        _applyFilters();

      case ClearTagFilters():
        state = state.copyWith(selectedTagIds: const {});
        _applyFilters();

      case ChangeViewMode(:final viewMode):
        state = state.copyWith(viewMode: viewMode);

      case CreateStashYarnEvent(:final companion, :final isFromSelectionSheet):
        await _createStashYarn(companion, isFromSelectionSheet: isFromSelectionSheet);

      case UpdateStashYarnEvent(:final companion):
        await _updateStashYarn(companion);

      case DeleteStashYarnEvent(:final id):
        await _deleteStashYarn(id);

      case QuickAdjustSkeins(:final yarnId, :final offset):
        await _quickAdjustSkeins(yarnId, offset);

      case DuplicateStashYarnEvent(:final yarnId, :final suffix):
        await _duplicateStashYarn(yarnId, suffix);

      case AssignTagsToStashYarnEvent(:final yarnId, :final tagIds):
        await _assignTagsToStashYarn(yarnId, tagIds);

      case OpenAssignStashTagsDialog(:final yarnId):
        _openAssignStashTagsDialog(yarnId);
    }
  }

  Future<void> _loadData() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _stashSubscription?.cancel();
      _stashSubscription = appDb.watchAllStashYarns().listen(
        (yarns) => onEvent(StashUpdatedEvent(yarns)),
        onError: (e) => _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.loadDataFailed(l10n.errorText(e)))),
      );

      // 태그 목록 stream 구독 (태그 시트에서 이름·색을 바꾸거나 지워도 바로 반영)
      await _tagsSubscription?.cancel();
      _tagsSubscription = appDb.watchAllStashTags().listen(
        (tags) => onEvent(StashTagsUpdated(tags)),
      );
    } catch (e) {
      await _stashSubscription?.cancel();
      await _tagsSubscription?.cancel();
      state = state.copyWith(isLoading: false); // 실패 후에도 다시 불러올 수 있게
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.initFailed(l10n.errorText(e))));
    }
  }

  void _applyFilters() {
    final ids = state.selectedTagIds;
    final query = state.searchQuery.trim().toLowerCase();
    final yarnWeight = state.yarnWeightFilter;
    var list = state.allYarns;

    // 1. 태그 필터링
    if (ids.isNotEmpty) {
      list = list.where((y) => ids.every(parseTagIds(y.tagIds).contains)).toList();
    }

    // 2. 굵기 필터링
    if (yarnWeight != null) {
      list = list.where((y) => y.yarnWeight == yarnWeight).toList();
    }

    // 3. 검색어 필터링 (별명, 제품명, 브랜드명, 색상명 등 검색)
    if (query.isNotEmpty) {
      list = list.where((y) {
        final nameMatch = y.nickname?.toLowerCase().contains(query) ?? false;
        final yarnNameMatch = y.yarnName.toLowerCase().contains(query);
        final brandNameMatch = y.brandName?.toLowerCase().contains(query) ?? false;
        final colorMatch = y.colorwayName?.toLowerCase().contains(query) ?? false;
        return nameMatch || yarnNameMatch || brandNameMatch || colorMatch;
      }).toList();
    }

    // 4. 정렬 (DB 스트림이 최신 등록순이므로 newest는 그대로)
    switch (state.sortOrder) {
      case StashSortOrder.newest:
        break;
      case StashSortOrder.name:
        list = [...list]..sort(
            (a, b) => a.yarnName.toLowerCase().compareTo(b.yarnName.toLowerCase()),
          );
      case StashSortOrder.brand:
        // 브랜드가 없는 실은 뒤로
        list = [...list]..sort((a, b) {
            final brandA = (a.brandName ?? '').toLowerCase();
            final brandB = (b.brandName ?? '').toLowerCase();
            if (brandA.isEmpty || brandB.isEmpty) {
              return (brandA.isEmpty ? 1 : 0) - (brandB.isEmpty ? 1 : 0);
            }
            return brandA.compareTo(brandB);
          });
    }

    state = state.copyWith(filteredYarns: list);
  }

  Future<void> _createStashYarn(StashYarnsCompanion companion, {bool isFromSelectionSheet = false}) async {
    try {
      final id = await appDb.createStashYarn(companion);
      _emit(StashYarnCreated(id, isFromSelectionSheet: isFromSelectionSheet));
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.addComplete));
    } catch (e) {
      // 저장되지 못한 실용으로 복사해 둔 이미지 정리
      await AppImageUtils.deleteImageIfUnused(companion.imagePath.value);
      _emit(const StashYarnSaveFailed());
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.saveYarnFailed(l10n.errorText(e))));
    }
  }

  Future<void> _updateStashYarn(StashYarnsCompanion companion) async {
    final id = companion.id.value;
    final newImagePath = companion.imagePath.value;
    String? previousImagePath;
    try {
      previousImagePath = (await appDb.getStashYarn(id))?.imagePath;
      await appDb.updateStashYarn(companion);
    } catch (e) {
      // 저장 실패: 새로 복사한 이미지만 정리하고 기존 이미지는 그대로 둔다
      await AppImageUtils.deleteImageIfUnused(newImagePath, keep: previousImagePath);
      _emit(const StashYarnSaveFailed());
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.saveYarnFailed(l10n.errorText(e))));
      return;
    }

    // 교체·제거된 기존 이미지 정리 (복사본이 같은 파일을 쓰고 있으면 남겨둔다)
    await AppImageUtils.deleteImageIfUnused(previousImagePath, keep: newImagePath);
    _emit(StashYarnUpdated(id));
    _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.editComplete));
  }

  Future<void> _deleteStashYarn(int id) async {
    try {
      await appDb.deleteStashYarn(id);
      _emit(const StashYarnDeleted());
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.stashDeleted));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.deleteFailed(l10n.errorText(e))));
    }
  }

  Future<void> _quickAdjustSkeins(int yarnId, double offset) async {
    try {
      final yarn = state.allYarns.firstWhere((y) => y.id == yarnId);
      final currentSkeins = yarn.skeins ?? 0.0;
      var newSkeins = currentSkeins + offset;
      if (newSkeins < 0.0) newSkeins = 0.0;
      
      // 소수점 둘째 자리 반올림
      newSkeins = double.parse(newSkeins.toStringAsFixed(2));

      // 지능형 양방향 계산 로직 반영:
      // skeins가 변경되었으므로 1볼당 규격이 있는 총량은 비례하여 다시 계산한다.
      // 규격이 없으면 사용자가 직접 입력한 총량이므로 건드리지 않는다.
      final lengthPerSkein = yarn.yarnLengthPerSkein;
      final weightPerSkein = yarn.yarnWeightPerSkein;

      await appDb.updateStashYarn(
        StashYarnsCompanion(
          id: Value(yarnId),
          skeins: Value(newSkeins),
          totalLength: lengthPerSkein != null
              ? Value(double.parse((newSkeins * lengthPerSkein).toStringAsFixed(2)))
              : const Value.absent(),
          totalWeight: weightPerSkein != null
              ? Value(double.parse((newSkeins * weightPerSkein).toStringAsFixed(2)))
              : const Value.absent(),
        ),
      );
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(l10n.errorText(e))));
    }
  }

  Future<void> _duplicateStashYarn(int yarnId, String suffix) async {
    try {
      final origin = state.allYarns.firstWhere((y) => y.id == yarnId);

      // 이미지 복사 처리
      String? copiedImagePath;
      if (origin.imagePath != null) {
        final absPath = await AppImageUtils.toAbsolutePath(origin.imagePath);
        if (absPath != null && await File(absPath).exists()) {
          copiedImagePath = await AppImageUtils.persistImage(absPath, subDir: 'stash_images');
        }
      }

      final newNickname = origin.nickname;
      final newYarnName = '${origin.yarnName}$suffix';

      final companion = StashYarnsCompanion(
        imagePath: Value(copiedImagePath),
        nickname: Value(newNickname),
        yarnName: Value(newYarnName),
        brandName: Value(origin.brandName),
        colorwayName: Value(origin.colorwayName),
        dyeLot: Value(origin.dyeLot),
        skeins: Value(origin.skeins),
        yarnLengthPerSkein: Value(origin.yarnLengthPerSkein),
        yarnWeightPerSkein: Value(origin.yarnWeightPerSkein),
        totalLength: Value(origin.totalLength),
        totalWeight: Value(origin.totalWeight),
        lengthUnit: Value(origin.lengthUnit),
        weightUnit: Value(origin.weightUnit),
        yarnWeight: Value(origin.yarnWeight),
        location: Value(origin.location),
        notes: Value(origin.notes),
        tagIds: Value(origin.tagIds),
        createdAt: Value(DateTime.now().toUtc()),
      );

      final newId = await appDb.createStashYarn(companion);
      _emit(StashYarnCreated(newId));
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.addComplete));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(l10n.errorText(e))));
    }
  }

  Future<void> _assignTagsToStashYarn(int yarnId, List<int> tagIds) async {
    try {
      await appDb.updateStashYarnTags(yarnId: yarnId, tagIds: tagIds);
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.editComplete));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(l10n.errorText(e))));
    }
  }

  void _openAssignStashTagsDialog(int yarnId) {
    try {
      final yarn = state.allYarns.firstWhere((y) => y.id == yarnId);
      final currentTagIds = parseTagIds(yarn.tagIds);
      _emit(ShowAssignStashTagsDialog(yarnId, currentTagIds));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(l10n.errorText(e))));
    }
  }

  void _emit(StashEffect effect) {
    _effectController.add(effect);
  }
}

final stashProvider = NotifierProvider<StashNotifier, StashState>(
  StashNotifier.new,
);

final stashEffectsProvider = StreamProvider.autoDispose<StashEffect>((ref) {
  final notifier = ref.watch(stashProvider.notifier);
  return notifier.effects;
});
