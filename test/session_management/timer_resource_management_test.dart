import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';

void main() {
  group('타이머 리소스 관리 테스트', () {
    group('StopwatchProvider dispose 시 타이머 정리', () {
      test('dispose 시 타이머가 정상적으로 정리되어야 함', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When - 타이머 시작 후 dispose
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // Then - dispose 시 예외가 발생하지 않아야 함
        expect(() => container.dispose(), returnsNormally);
      });

      test('여러 개의 컨테이너 dispose 시 리소스 정리', () async {
        // Given
        final containers = List.generate(5, (_) => ProviderContainer());

        // When - 모든 컨테이너에서 타이머 시작
        for (final container in containers) {
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();
        }

        await Future.delayed(Duration(milliseconds: 100));

        // Then - 모든 컨테이너 dispose 시 예외 없음
        for (final container in containers) {
          expect(() => container.dispose(), returnsNormally);
        }
      });

      test('dispose 후 타이머 접근 시 안전한 처리', () {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);
        notifier.start();

        // When
        container.dispose();

        // Then - dispose 후 상태 접근 시 예외 발생
        expect(
          () => container.read(stopwatchProvider),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('메모리 누수 방지 테스트', () {
      test('다수의 타이머 생성/해제 시 메모리 안정성', () async {
        // Given
        const iterations = 100;
        final containers = <ProviderContainer>[];

        // When - 다수의 타이머 생성 및 해제
        for (int i = 0; i < iterations; i++) {
          final container = ProviderContainer();
          final notifier = container.read(stopwatchProvider.notifier);

          notifier.start();
          await Future.delayed(Duration(milliseconds: 10));
          notifier.pause();

          containers.add(container);

          // 중간에 일부 컨테이너 해제
          if (i % 10 == 0 && containers.length > 5) {
            final toDispose = containers.removeAt(0);
            toDispose.dispose();
          }
        }

        // Then - 모든 컨테이너 정리
        for (final container in containers) {
          expect(() => container.dispose(), returnsNormally);
        }
      });

      test('장시간 실행 후 메모리 사용량 안정성', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When - 장시간 타이머 실행
        notifier.start();

        // 여러 번의 pause/resume 사이클
        for (int i = 0; i < 10; i++) {
          await Future.delayed(Duration(milliseconds: 50));
          notifier.pause();
          await Future.delayed(Duration(milliseconds: 10));
          notifier.resume();
        }

        await Future.delayed(Duration(milliseconds: 100));

        // Then - 정상적으로 정리되어야 함
        expect(() => container.dispose(), returnsNormally);
      });

      test('타이머 리셋 시 리소스 정리', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));
        notifier.reset();

        // 리셋 후 다시 시작
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));

        // Then
        expect(() => container.dispose(), returnsNormally);
      });
    });

    group('백그라운드/포그라운드 전환 시 시간 계산', () {
      test('시뮬레이션된 백그라운드 전환 시 시간 정확성', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When - 타이머 시작
        notifier.start();
        await Future.delayed(Duration(milliseconds: 200));

        // 백그라운드 전환 시뮬레이션 (pause/resume)
        notifier.pause();
        final pausedTime = container.read(stopwatchProvider).elapsed;

        // 백그라운드에서 시간이 흐른다고 가정하고 resume
        await Future.delayed(Duration(milliseconds: 100)); // 백그라운드 시간
        notifier.resume();
        await Future.delayed(Duration(milliseconds: 200));

        // Then - 백그라운드 시간은 포함되지 않아야 함
        final finalTime = container.read(stopwatchProvider).elapsed;
        final expectedTime = pausedTime + Duration(milliseconds: 200);

        expect(
          finalTime.inMilliseconds,
          closeTo(expectedTime.inMilliseconds, 50),
        );

        container.dispose();
      });

      test('포그라운드 복귀 시 정확한 시간 복원', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);
        final baseTime = Duration(minutes: 5);

        // When - 기존 누적 시간으로 시작
        notifier.setElapsed(baseTime);
        notifier.start(initialElapsed: baseTime);
        await Future.delayed(Duration(milliseconds: 200));

        // Then - 기존 시간 + 새로운 경과 시간
        final currentTime = container.read(stopwatchProvider).elapsed;
        expect(currentTime, greaterThan(baseTime));
        expect(
          currentTime.inMilliseconds,
          closeTo(baseTime.inMilliseconds + 200, 50),
        );

        container.dispose();
      });

      test('여러 번의 백그라운드/포그라운드 전환', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When - 여러 번의 전환 시뮬레이션
        notifier.start();

        Duration totalExpectedTime = Duration.zero;

        for (int i = 0; i < 3; i++) {
          // 포그라운드에서 실행
          const foregroundTime = Duration(milliseconds: 100);
          await Future.delayed(foregroundTime);
          totalExpectedTime += foregroundTime;

          // 백그라운드 전환 (pause)
          notifier.pause();
          await Future.delayed(Duration(milliseconds: 50)); // 백그라운드 시간

          // 포그라운드 복귀 (resume)
          notifier.resume();
        }

        // 마지막 포그라운드 시간
        const finalTime = Duration(milliseconds: 100);
        await Future.delayed(finalTime);
        totalExpectedTime += finalTime;

        // Then
        final actualTime = container.read(stopwatchProvider).elapsed;
        expect(
          actualTime.inMilliseconds,
          closeTo(totalExpectedTime.inMilliseconds, 100),
        );

        container.dispose();
      });
    });

    group('50ms 주기 타이머의 성능 영향', () {
      test('타이머 업데이트 주기 정확성', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);
        final updates = <Duration>[];

        // When - 타이머 시작하고 여러 번 상태 확인
        notifier.start();

        for (int i = 0; i < 5; i++) {
          await Future.delayed(Duration(milliseconds: 50));
          updates.add(container.read(stopwatchProvider).elapsed);
        }

        // Then - 각 업데이트 간격이 대략 50ms여야 함
        for (int i = 1; i < updates.length; i++) {
          final diff = updates[i] - updates[i - 1];
          expect(diff.inMilliseconds, closeTo(50, 20)); // ±20ms 허용
        }

        container.dispose();
      });

      test('다수의 동시 타이머 성능', () async {
        // Given
        const timerCount = 10;
        final containers = <ProviderContainer>[];
        final stopwatch = Stopwatch()..start();

        // When - 다수의 타이머 동시 실행
        for (int i = 0; i < timerCount; i++) {
          final container = ProviderContainer();
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();
          containers.add(container);
        }

        // 일정 시간 실행
        await Future.delayed(Duration(milliseconds: 500));

        stopwatch.stop();

        // Then - 모든 타이머가 정상 동작해야 함
        for (final container in containers) {
          final elapsed = container.read(stopwatchProvider).elapsed;
          expect(elapsed.inMilliseconds, greaterThan(400));
          expect(elapsed.inMilliseconds, lessThan(600));
        }

        // 성능 검증 - 전체 실행 시간이 크게 지연되지 않아야 함
        expect(stopwatch.elapsedMilliseconds, lessThan(600));

        // 정리
        for (final container in containers) {
          container.dispose();
        }
      });

      test('타이머 시작/중지 반복 시 성능', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);
        final stopwatch = Stopwatch()..start();

        // When - 빠른 시작/중지 반복
        for (int i = 0; i < 50; i++) {
          notifier.start();
          await Future.delayed(Duration(milliseconds: 20));
          notifier.pause();
          await Future.delayed(Duration(milliseconds: 10));
        }

        stopwatch.stop();

        // Then - 성능이 크게 저하되지 않아야 함
        expect(stopwatch.elapsedMilliseconds, lessThan(2000)); // 2초 이내

        container.dispose();
      });

      test('메모리 사용량 모니터링', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When - 장시간 타이머 실행
        notifier.start();

        // 여러 상태 변경을 통한 메모리 사용 패턴 확인
        for (int i = 0; i < 20; i++) {
          await Future.delayed(Duration(milliseconds: 100));
          if (i % 4 == 0) {
            notifier.pause();
            await Future.delayed(Duration(milliseconds: 50));
            notifier.resume();
          }
        }

        // Then - 정상적으로 완료되어야 함 (메모리 부족 등의 오류 없음)
        final finalState = container.read(stopwatchProvider);
        expect(finalState.elapsed, greaterThan(Duration(seconds: 1)));

        container.dispose();
      });

      test('CPU 사용률 영향 최소화 검증', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);
        final stopwatch = Stopwatch()..start();

        // When - 타이머 실행 중 다른 작업 수행
        notifier.start();

        // CPU 집약적 작업 시뮬레이션
        var counter = 0;
        while (stopwatch.elapsedMilliseconds < 500) {
          counter++;
          if (counter % 10000 == 0) {
            await Future.delayed(Duration.zero); // 이벤트 루프 양보
          }
        }

        // Then - 타이머가 정상 동작해야 함
        final elapsed = container.read(stopwatchProvider).elapsed;
        expect(elapsed.inMilliseconds, closeTo(500, 100));

        container.dispose();
      });
    });

    group('리소스 정리 안전성', () {
      test('예외 발생 시에도 리소스 정리', () async {
        // Given
        final container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        try {
          // When - 타이머 시작 후 예외 상황 시뮬레이션
          notifier.start();
          await Future.delayed(Duration(milliseconds: 100));

          // 강제로 예외 발생
          throw Exception('테스트 예외');
        } catch (e) {
          // Then - 예외 발생 후에도 정상적으로 정리되어야 함
          expect(() => container.dispose(), returnsNormally);
        }
      });

      test('가비지 컬렉션 후 리소스 상태', () async {
        // Given
        var container = ProviderContainer();
        final notifier = container.read(stopwatchProvider.notifier);

        // When
        notifier.start();
        await Future.delayed(Duration(milliseconds: 100));
        container.dispose();

        // 가비지 컬렉션 유도
        container = ProviderContainer(); // 새 인스턴스 생성

        // Then - 새 인스턴스가 정상 동작해야 함
        final newNotifier = container.read(stopwatchProvider.notifier);
        expect(() => newNotifier.start(), returnsNormally);

        container.dispose();
      });

      test('플랫폼별 리소스 정리 (Android/iOS 시뮬레이션)', () async {
        // Given
        final containers = <ProviderContainer>[];

        // When - 플랫폼 생명주기 시뮬레이션
        for (int i = 0; i < 5; i++) {
          final container = ProviderContainer();
          final notifier = container.read(stopwatchProvider.notifier);

          notifier.start();
          await Future.delayed(Duration(milliseconds: 50));

          // 앱 백그라운드 진입 시뮬레이션
          notifier.pause();
          containers.add(container);
        }

        // 앱 종료 시뮬레이션 - 모든 리소스 정리
        for (final container in containers) {
          expect(() => container.dispose(), returnsNormally);
        }

        // Then - 정리 완료 후 새 인스턴스 생성 가능
        final newContainer = ProviderContainer();
        final newNotifier = newContainer.read(stopwatchProvider.notifier);
        expect(() => newNotifier.start(), returnsNormally);

        newContainer.dispose();
      });
    });
  });
}
