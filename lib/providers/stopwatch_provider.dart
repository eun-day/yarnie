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
  Duration _baseTime = Duration.zero;

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
        state = state.copyWith(elapsed: _baseTime + _stopwatch.elapsed, isRunning: true);
      }
    });
  }

  void setElapsed(Duration elapsed) {
    // 스톱워치가 돌고 있지 않을 때 외부에서 누적시간을 강제 설정
    _baseTime = elapsed;
    _stopwatch.reset();
    state = state.copyWith(elapsed: _baseTime, isRunning: false);
  }

  /// Start from zero (or a given initial elapsed)
  void start({Duration initialElapsed = Duration.zero}) {
    _ticker?.cancel();
    _stopwatch.reset();
    _baseTime = initialElapsed;
    state = state.copyWith(elapsed: _baseTime, isRunning: true);
    _stopwatch.start();
    _startTicker();
  }

  void pause() {
    if (!_stopwatch.isRunning) return;
    // 현재까지 달린 시간을 base에 더하고, 내부 스톱워치는 리셋
    _baseTime += _stopwatch.elapsed;
    _stopwatch.reset();
    _stopwatch.stop();
    state = state.copyWith(elapsed: _baseTime, isRunning: false);
    _ticker?.cancel();
  }

  void resume() {
    if (_stopwatch.isRunning) return;
    // _baseTime은 이미 pause 시점에 업데이트 되었으므로, stopwatch만 새로 시작
    _stopwatch.start();
    state = state.copyWith(isRunning: true);
    _startTicker();
  }

  /// Stop but keep the elapsed time (not reset)
  void stop() {
    _stopwatch.stop();
    final finalElapsed = _baseTime + _stopwatch.elapsed;
    state = state.copyWith(elapsed: finalElapsed, isRunning: false);
    _ticker?.cancel();
  }

  /// Reset to zero and stop
  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _baseTime = Duration.zero;
    state = state.copyWith(elapsed: Duration.zero, isRunning: false);
    _ticker?.cancel();
  }
}

final stopwatchProvider =
    NotifierProvider<StopwatchNotifier, StopwatchState>(StopwatchNotifier.new);