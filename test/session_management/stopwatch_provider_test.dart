import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';

void main() {
  group('StopwatchProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('StopwatchState', () {
      test('should have correct initial state', () {
        // Given & When
        final state = container.read(stopwatchProvider);

        // Then
        expect(state.elapsed, Duration.zero);
        expect(state.isRunning, false);
      });

      test('should create new state with copyWith', () {
        // Given
        const initialState = StopwatchState();
        final newElapsed = Duration(minutes: 5);

        // When
        final newState = initialState.copyWith(
          elapsed: newElapsed,
          isRunning: true,
        );

        // Then
        expect(newState.elapsed, newElapsed);
        expect(newState.isRunning, true);
        // Original state should remain unchanged
        expect(initialState.elapsed, Duration.zero);
        expect(initialState.isRunning, false);
      });

      test('should preserve existing values when copyWith with null', () {
        // Given
        final initialState = StopwatchState(
          elapsed: Duration(minutes: 3),
          isRunning: true,
        );

        // When
        final newState = initialState.copyWith();

        // Then
        expect(newState.elapsed, Duration(minutes: 3));
        expect(newState.isRunning, true);
      });
    });

    group('StopwatchNotifier - Basic Operations', () {
      test('should start timer with zero initial elapsed time', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);

        // When
        notifier.start();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, true);
        expect(state.elapsed, Duration.zero);
      });

      test('should start timer with custom initial elapsed time', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        final initialElapsed = Duration(minutes: 5);

        // When
        notifier.start(initialElapsed: initialElapsed);

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, true);
        expect(state.elapsed, initialElapsed);
      });

      test('should pause running timer', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();

        // Wait a bit for timer to run
        await Future.delayed(Duration(milliseconds: 100));

        // When
        notifier.pause();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, false);
        expect(state.elapsed, greaterThan(Duration.zero));
      });

      test('should not pause when timer is not running', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        final initialState = container.read(stopwatchProvider);

        // When
        notifier.pause();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, initialState.isRunning);
        expect(state.elapsed, initialState.elapsed);
      });

      test('should resume paused timer', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));
        notifier.pause();
        final pausedElapsed = container.read(stopwatchProvider).elapsed;

        // When
        notifier.resume();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, true);
        expect(state.elapsed, pausedElapsed);
      });

      test('should not resume when timer is already running', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));
        final runningState = container.read(stopwatchProvider);

        // When
        notifier.resume();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, true);
        // Elapsed time should continue from where it was
        expect(state.elapsed, greaterThanOrEqualTo(runningState.elapsed));
      });

      test('should stop timer and keep elapsed time', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // When
        notifier.stop();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, false);
        expect(state.elapsed, greaterThan(Duration.zero));
      });

      test('should reset timer to zero', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // When
        notifier.reset();

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, false);
        expect(state.elapsed, Duration.zero);
      });

      test('should set elapsed time when not running', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        final targetElapsed = Duration(minutes: 10);

        // When
        notifier.setElapsed(targetElapsed);

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.elapsed, targetElapsed);
        expect(state.isRunning, false);
      });
    });

    group('StopwatchNotifier - Timer Accuracy', () {
      test('should maintain timer accuracy over short duration', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        const testDuration = Duration(milliseconds: 200);

        // When
        notifier.start();
        await Future.delayed(testDuration);
        notifier.pause();

        // Then
        final elapsed = container.read(stopwatchProvider).elapsed;
        expect(
          elapsed.inMilliseconds,
          closeTo(testDuration.inMilliseconds, 50),
        );
      });

      test(
        'should accumulate time correctly across pause/resume cycles',
        () async {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          const firstRun = Duration(milliseconds: 100);
          const secondRun = Duration(milliseconds: 100);

          // When
          notifier.start();
          await Future.delayed(firstRun);
          notifier.pause();

          await Future.delayed(Duration(milliseconds: 50)); // Pause duration

          notifier.resume();
          await Future.delayed(secondRun);
          notifier.pause();

          // Then
          final elapsed = container.read(stopwatchProvider).elapsed;
          final expectedTotal = firstRun + secondRun;
          expect(
            elapsed.inMilliseconds,
            closeTo(expectedTotal.inMilliseconds, 50),
          );
        },
      );

      test('should not accumulate time when paused', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);

        // When
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));
        notifier.pause();
        final pausedElapsed = container.read(stopwatchProvider).elapsed;

        await Future.delayed(Duration(milliseconds: 100)); // Wait while paused

        // Then
        final finalElapsed = container.read(stopwatchProvider).elapsed;
        expect(finalElapsed, pausedElapsed);
      });
    });

    group('StopwatchNotifier - Real-time Updates', () {
      test('should update elapsed time every 50ms when running', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();

        // When - Wait for multiple timer ticks
        await Future.delayed(Duration(milliseconds: 150)); // ~3 ticks

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.isRunning, true);
        expect(state.elapsed.inMilliseconds, greaterThan(100));
        expect(state.elapsed.inMilliseconds, lessThan(200));
      });

      test('should stop updating when paused', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // When
        notifier.pause();
        final pausedElapsed = container.read(stopwatchProvider).elapsed;
        await Future.delayed(Duration(milliseconds: 100));

        // Then
        final finalElapsed = container.read(stopwatchProvider).elapsed;
        expect(finalElapsed, pausedElapsed);
        expect(container.read(stopwatchProvider).isRunning, false);
      });

      test('should resume real-time updates after resume', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));
        notifier.pause();
        final pausedElapsed = container.read(stopwatchProvider).elapsed;

        // When
        notifier.resume();
        await Future.delayed(Duration(milliseconds: 100));

        // Then
        final resumedElapsed = container.read(stopwatchProvider).elapsed;
        expect(resumedElapsed, greaterThan(pausedElapsed));
        expect(container.read(stopwatchProvider).isRunning, true);
      });
    });

    group('StopwatchNotifier - setElapsed Method', () {
      test('should set elapsed time when stopwatch is not running', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        final targetElapsed = Duration(minutes: 5, seconds: 30);

        // When
        notifier.setElapsed(targetElapsed);

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.elapsed, targetElapsed);
        expect(state.isRunning, false);
      });

      test(
        'should reset base time and internal stopwatch when setting elapsed',
        () {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();
          // Let it run briefly
          final targetElapsed = Duration(minutes: 10);

          // When
          notifier.setElapsed(targetElapsed);

          // Then
          final state = container.read(stopwatchProvider);
          expect(state.elapsed, targetElapsed);
          expect(state.isRunning, false);
        },
      );

      test('should allow starting from set elapsed time', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        final baseElapsed = Duration(minutes: 5);
        notifier.setElapsed(baseElapsed);

        // When
        notifier.start(initialElapsed: baseElapsed);
        await Future.delayed(Duration(milliseconds: 100));

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.elapsed, greaterThan(baseElapsed));
        expect(state.isRunning, true);
      });
    });

    group('StopwatchNotifier - Resource Management', () {
      test('should dispose timer resources properly', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();

        // When
        container.dispose();

        // Then - No exception should be thrown
        // Timer should be cancelled automatically via ref.onDispose
        expect(() => container.dispose(), returnsNormally);
      });

      test('should handle multiple dispose calls gracefully', () {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();

        // When & Then - Multiple dispose calls should not throw
        expect(() {
          container.dispose();
          container.dispose(); // Second call should be safe
        }, returnsNormally);
      });

      test('should cancel timer when reset is called', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // When
        notifier.reset();
        await Future.delayed(Duration(milliseconds: 100));

        // Then
        final state = container.read(stopwatchProvider);
        expect(state.elapsed, Duration.zero);
        expect(state.isRunning, false);
      });

      test('should cancel timer when stop is called', () async {
        // Given
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // When
        notifier.stop();
        final stoppedElapsed = container.read(stopwatchProvider).elapsed;
        await Future.delayed(Duration(milliseconds: 100));

        // Then - Elapsed time should not change after stop
        final finalElapsed = container.read(stopwatchProvider).elapsed;
        expect(finalElapsed, stoppedElapsed);
        expect(container.read(stopwatchProvider).isRunning, false);
      });
    });
  });
}
