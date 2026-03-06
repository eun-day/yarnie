import 'dart:async';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../db/app_db.dart';
import '../../../../db/di.dart';
import 'part_manage_state.dart';
import 'part_manage_event.dart';
import 'part_manage_effect.dart';

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
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);

    _partsSubscription?.cancel();
    _partsSubscription = appDb
        .watchProjectParts(projectId)
        .listen(
          (parts) => onEvent(PartsUpdated(parts)),
          onError: (e, st) => onEvent(ShowPartManageError('파트 로드 실패: $e')),
        );
  }

  Future<void> _createPart(int projectId, String name) async {
    try {
      final exists = await appDb.isPartNameExists(
        projectId: projectId,
        name: name,
      );
      if (exists) {
        _emit(const ShowErrorEffect('이미 존재하는 파트 이름입니다.'));
        return;
      }

      final newPartId = await appDb.createPart(
        projectId: projectId,
        name: name,
      );
      _emit(PartCreatedEffect(newPartId));
    } catch (e) {
      _emit(ShowErrorEffect('파트 생성 실패: $e'));
    }
  }

  Future<void> _updatePart(int partId, String name) async {
    try {
      await appDb.updatePart(
        PartsCompanion(id: Value(partId), name: Value(name)),
      );
    } catch (e) {
      _emit(ShowErrorEffect('파트 수정 실패: $e'));
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
      _emit(ShowErrorEffect('파트 순서 변경 실패: $e'));
    }
  }

  Future<void> _deletePart(int partId) async {
    try {
      await appDb.deletePart(partId);
    } catch (e) {
      _emit(ShowErrorEffect('파트 삭제 실패: $e'));
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
