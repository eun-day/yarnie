import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stopwatch state
class StopwatchState {
  final Duration elapsed;
  final bool isRunning;

  const StopwatchState({
    this.elapsed = Duration.zero,
    this.isRunning = false,
  });

  StopwatchState copyWith({
    Duration? elapsed,
    bool? isRunning,
  }) =>
      StopwatchState(
        elapsed: elapsed ?? this.elapsed,
        isRunning: isRunning ?? this.isRunning,
      );
}

/// Riverpod Notifier-based implementation (no StateNotifier needed)
class StopwatchNotifier extends Notifier<StopwatchState> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  @override
  StopwatchState build() {
    // initial state
    ref.onDispose(() {
      _ticker?.cancel();
    });
    return const StopwatchState();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (_stopwatch.isRunning) {
        state = state.copyWith(elapsed: _stopwatch.elapsed, isRunning: true);
      }
    });
  }

  void setElapsed(Duration elapsed) {
    // 스톱워치는 건드리지 않고 state만 업데이트
    state = state.copyWith(elapsed: elapsed);
  }

  /// Start from zero (or a given initial elapsed)
  void start({Duration initialElapsed = Duration.zero}) {
    _ticker?.cancel();
    _stopwatch.reset();
    if (initialElapsed > Duration.zero) {
      // Stopwatch 자체에 오프셋 설정은 없으므로 state로 반영
      state = state.copyWith(elapsed: initialElapsed, isRunning: true);
    } else {
      state = state.copyWith(elapsed: Duration.zero, isRunning: true);
    }
    _stopwatch.start();
    _startTicker();
  }

  void pause() {
    if (!_stopwatch.isRunning) return;
    _stopwatch.stop();
    state = state.copyWith(elapsed: _stopwatch.elapsed, isRunning: false);
    _ticker?.cancel();
  }

  void resume() {
    if (_stopwatch.isRunning) return;
    _stopwatch.start();
    state = state.copyWith(isRunning: true);
    _startTicker();
  }

  /// Stop but keep the elapsed time (not reset)
  void stop() {
    _stopwatch.stop();
    state = state.copyWith(elapsed: _stopwatch.elapsed, isRunning: false);
    _ticker?.cancel();
  }

  /// Reset to zero and stop
  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    state = state.copyWith(elapsed: Duration.zero, isRunning: false);
    _ticker?.cancel();
  }
}

final stopwatchProvider =
    NotifierProvider<StopwatchNotifier, StopwatchState>(StopwatchNotifier.new);
