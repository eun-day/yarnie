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
    // 로딩 중이어도 다른 파트 요청은 받아야 하므로 막지 않는다 (기존 구독은 아래에서 교체)
    state = state.copyWith(isLoading: true, clearError: true);

    _countSubscription?.cancel();
    _countSubscription = appDb
        .watchBuddyCountersCount(partId)
        .listen(
          (count) => onEvent(TotalCountUpdated(count)),
          onError: (e, st) => state = state.copyWith(
            error: e.toString(),
            isLoading: false,
          ),
        );
  }
}

final partCountersProvider =
    NotifierProvider.autoDispose<PartCountersNotifier, PartCountersState>(
      PartCountersNotifier.new,
    );
