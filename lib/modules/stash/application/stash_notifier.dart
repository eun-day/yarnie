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

class StashNotifier extends Notifier<StashState> {
  StreamSubscription<List<StashYarn>>? _stashSubscription;
  final _effectController = StreamController<StashEffect>.broadcast();

  Stream<StashEffect> get effects => _effectController.stream;

  @override
  StashState build() {
    ref.onDispose(() {
      _stashSubscription?.cancel();
      _effectController.close();
    });
    return const StashState();
  }

  Future<void> onEvent(StashEvent event) async {
    switch (event) {
      case LoadStash():
        await _loadData();

      case StashUpdatedEvent(:final yarns):
        final tags = await appDb.getAllStashTags();
        state = state.copyWith(
          allYarns: yarns,
          allTags: tags,
          isLoading: false,
          error: null,
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

      case ClearFilters():
        state = state.copyWith(selectedTagIds: const {}, searchQuery: '');
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
      final tags = await appDb.getAllStashTags();
      await _stashSubscription?.cancel();
      _stashSubscription = appDb.watchAllStashYarns().listen(
        (yarns) => onEvent(StashUpdatedEvent(yarns)),
        onError: (e) => _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.loadDataFailed(e.toString()))),
      );
      state = state.copyWith(allTags: tags);
    } catch (e) {
      await _stashSubscription?.cancel();
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.initFailed(e.toString())));
    }
  }

  void _applyFilters() {
    final ids = state.selectedTagIds;
    final query = state.searchQuery.trim().toLowerCase();
    var list = state.allYarns;

    // 1. 태그 필터링
    if (ids.isNotEmpty) {
      list = list.where((y) => ids.every(parseTagIds(y.tagIds).contains)).toList();
    }

    // 2. 검색어 필터링 (별명, 제품명, 브랜드명, 색상명 등 검색)
    if (query.isNotEmpty) {
      list = list.where((y) {
        final nameMatch = y.nickname?.toLowerCase().contains(query) ?? false;
        final yarnNameMatch = y.yarnName.toLowerCase().contains(query);
        final brandNameMatch = y.brandName?.toLowerCase().contains(query) ?? false;
        final colorMatch = y.colorwayName?.toLowerCase().contains(query) ?? false;
        return nameMatch || yarnNameMatch || brandNameMatch || colorMatch;
      }).toList();
    }

    state = state.copyWith(filteredYarns: list);
  }

  Future<void> _createStashYarn(StashYarnsCompanion companion, {bool isFromSelectionSheet = false}) async {
    try {
      final id = await appDb.createStashYarn(companion);
      _emit(StashYarnCreated(id, isFromSelectionSheet: isFromSelectionSheet));
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.addComplete));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.saveProjectFailed(e.toString()))); // 기존 번역 키 재활용
    }
  }

  Future<void> _updateStashYarn(StashYarnsCompanion companion) async {
    try {
      await appDb.updateStashYarn(companion);
      final id = companion.id.value;
      _emit(StashYarnUpdated(id));
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.editComplete));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.saveProjectFailed(e.toString())));
    }
  }

  Future<void> _deleteStashYarn(int id) async {
    try {
      await appDb.deleteStashYarn(id);
      _emit(const StashYarnDeleted());
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.stashDeleted));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.deleteFailed(e.toString())));
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
      // skeins가 변경되었으므로 totalLength와 totalWeight도 비례하여 자동 계산해야 함
      double? newTotalLength;
      double? newTotalWeight;

      if (yarn.yarnLengthPerSkein != null) {
        newTotalLength = double.parse((newSkeins * yarn.yarnLengthPerSkein!).toStringAsFixed(2));
      }
      if (yarn.yarnWeightPerSkein != null) {
        newTotalWeight = double.parse((newSkeins * yarn.yarnWeightPerSkein!).toStringAsFixed(2));
      }

      await appDb.updateStashYarn(
        StashYarnsCompanion(
          id: Value(yarnId),
          skeins: Value(newSkeins),
          totalLength: Value(newTotalLength),
          totalWeight: Value(newTotalWeight),
        ),
      );
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(e.toString())));
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
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(e.toString())));
    }
  }

  Future<void> _assignTagsToStashYarn(int yarnId, List<int> tagIds) async {
    try {
      await appDb.updateStashYarnTags(yarnId: yarnId, tagIds: tagIds);
      _emit(ShowStashLocalizedSuccessMessage((l10n) => l10n.editComplete));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(e.toString())));
    }
  }

  void _openAssignStashTagsDialog(int yarnId) {
    try {
      final yarn = state.allYarns.firstWhere((y) => y.id == yarnId);
      final currentTagIds = parseTagIds(yarn.tagIds);
      _emit(ShowAssignStashTagsDialog(yarnId, currentTagIds));
    } catch (e) {
      _emit(ShowStashLocalizedErrorMessage((l10n) => l10n.errorOccurred(e.toString())));
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
