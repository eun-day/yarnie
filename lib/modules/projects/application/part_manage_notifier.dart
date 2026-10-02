import 'dart:async';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../db/app_db.dart';
import '../../../../db/di.dart';
import 'part_manage_state.dart';
import 'part_manage_event.dart';
import 'part_manage_effect.dart';
import 'package:yarnie/common/error_text_helper.dart';

class PartManageNotifier extends Notifier<PartManageState> {
  StreamSubscription? _partsSubscription;
  final _effectController = StreamController<PartManageEffect>.broadcast();

  Stream<PartManageEffect> get effects => _effectController.stream;

  @override
  PartManageState build() {
    ref.onDispose(() {
      _partsSubscription?.cancel();
      _effectController.close();
    });
    return const PartManageState();
  }

  Future<void> onEvent(PartManageEvent event) async {
    switch (event) {
      case LoadParts(:final projectId):
        _loadParts(projectId);
      case PartsUpdated(:final parts):
        state = state.copyWith(
          parts: parts,
          isLoading: false,
          clearError: true,
        );
      case CreatePart(:final projectId, :final name):
        await _createPart(projectId, name);
      case UpdatePart(:final partId, :final name):
        await _updatePart(partId, name);
      case ReorderParts(:final projectId, :final partIds):
        await _reorderParts(projectId, partIds);
      case DeletePart(:final partId):
        await _deletePart(partId);
      case ShowPartManageError(:final message):
        state = state.copyWith(error: message, isLoading: false);
        _emit(ShowErrorEffect(message));
    }
  }

  void _loadParts(int projectId) {
    // 로딩 중이어도 새 요청은 받는다 (기존 구독은 아래에서 교체, 실패 후 재시도도 가능)
    state = state.copyWith(isLoading: true, clearError: true);

    _partsSubscription?.cancel();
    _partsSubscription = appDb
        .watchProjectParts(projectId)
        .listen(
          (parts) => onEvent(PartsUpdated(parts)),
          onError: (e, st) {
            state = state.copyWith(isLoading: false);
            _emit(ShowLocalizedErrorEffect((l10n) => l10n.loadPartsFailed(l10n.errorText(e))));
          },
        );
  }

  Future<void> _createPart(int projectId, String name) async {
    try {
      final exists = await appDb.isPartNameExists(
        projectId: projectId,
        name: name,
      );
      if (exists) {
        _emit(ShowLocalizedErrorEffect((l10n) => l10n.duplicatePartName));
        return;
      }

      final newPartId = await appDb.createPart(
        projectId: projectId,
        name: name,
      );
      _emit(PartCreatedEffect(newPartId));
    } catch (e) {
      _emit(ShowLocalizedErrorEffect((l10n) => l10n.createPartFailed(l10n.errorText(e))));
    }
  }

  Future<void> _updatePart(int partId, String name) async {
    try {
      await appDb.updatePart(
        PartsCompanion(id: Value(partId), name: Value(name)),
      );
    } catch (e) {
      _emit(ShowLocalizedErrorEffect((l10n) => l10n.updatePartFailed(l10n.errorText(e))));
    }
  }

  Future<void> _reorderParts(int projectId, List<int> partIds) async {
    try {
      // Optimistic update
      final newParts = List<Part>.from(state.parts);
      newParts.sort((a, b) {
        final indexA = partIds.indexOf(a.id);
        final indexB = partIds.indexOf(b.id);
        if (indexA == -1 || indexB == -1) return 0;
        return indexA.compareTo(indexB);
      });
      state = state.copyWith(parts: newParts);

      await appDb.reorderParts(projectId: projectId, partIds: partIds);
    } catch (e) {
      _emit(ShowLocalizedErrorEffect((l10n) => l10n.reorderPartsFailed(l10n.errorText(e))));
    }
  }

  Future<void> _deletePart(int partId) async {
    try {
      await appDb.deletePart(partId);
    } catch (e) {
      _emit(ShowLocalizedErrorEffect((l10n) => l10n.deletePartFailed(l10n.errorText(e))));
    }
  }

  void _emit(PartManageEffect effect) {
    _effectController.add(effect);
  }
}

final partManageProvider =
    NotifierProvider.autoDispose<PartManageNotifier, PartManageState>(
      PartManageNotifier.new,
    );

final partManageEffectsProvider = StreamProvider.autoDispose<PartManageEffect>((
  ref,
) {
  final notifier = ref.watch(partManageProvider.notifier);
  return notifier.effects;
});
