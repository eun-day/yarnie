import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../db/di.dart';
import 'part_counters_state.dart';
import 'part_counters_event.dart';

class PartCountersNotifier extends Notifier<PartCountersState> {
  StreamSubscription? _countSubscription;

  @override
  PartCountersState build() {
    ref.onDispose(() {
      _countSubscription?.cancel();
    });
    return const PartCountersState();
  }

  void onEvent(PartCountersEvent event) {
    switch (event) {
      case LoadPartCountersCount(:final partId):
        _loadCount(partId);
      case TotalCountUpdated(:final count):
        state = state.copyWith(
          totalCount: count,
          isLoading: false,
          clearError: true,
        );
    }
  }

  void _loadCount(int partId) {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);

    _countSubscription?.cancel();
    _countSubscription = appDb
        .watchBuddyCountersCount(partId)
        .listen(
          (count) => onEvent(TotalCountUpdated(count)),
          onError: (e, st) => state = state.copyWith(
            error: '카운터 수 로드 실패: $e',
            isLoading: false,
          ),
        );
  }
}

final partCountersProvider =
    NotifierProvider.autoDispose<PartCountersNotifier, PartCountersState>(
      PartCountersNotifier.new,
    );
