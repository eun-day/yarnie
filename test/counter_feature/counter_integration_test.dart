import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../lib/providers/counter_provider.dart';
import '../../lib/providers/stopwatch_provider.dart';

import '../../lib/widget/sub_counter_item.dart';
import '../../lib/widget/count_by_selector.dart';

/// 카운터 기능 전체 플로우 통합 테스트
///
/// 테스트 범위:
/// - 메인 카운터 증감, 초기화 기능
/// - 서브 카운터 생성, 조작, 삭제 기능
/// - count by 설정 기능
/// - 스톱워치 연동 기능
void main() {
  group('카운터 기능 전체 플로우 테스트', () {
    late ProviderContainer container;

    setUp(() async {
      // SharedPreferences 모킹
      SharedPreferences.setMockInitialValues({});

      // 새로운 ProviderContainer 생성
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('메인 카운터 증감 및 초기화 기능 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final counterState = ref.watch(counterProvider);
                  return Column(
                    children: [
                      Text('${counterState.mainCounter}'),
                      ElevatedButton(
                        key: const Key('increment'),
                        onPressed: () =>
                            ref.read(counterProvider.notifier).incrementMain(),
                        child: const Text('증가'),
                      ),
                      ElevatedButton(
                        key: const Key('decrement'),
                        onPressed: () =>
                            ref.read(counterProvider.notifier).decrementMain(),
                        child: const Text('감소'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // 초기 상태 확인
      expect(find.text('0'), findsOneWidget);

      // 메인 카운터 증가 테스트
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // 여러 번 증가
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('increment')));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      // 메인 카운터 감소 테스트
      await tester.tap(find.byKey(const Key('decrement')));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // 초기화 테스트 - 직접 초기화 호출
      container.read(counterProvider.notifier).resetMain();
      final resetState = container.read(counterProvider);
      expect(resetState.mainCounter, 0);
    });

    testWidgets('서브 카운터 생성, 조작, 삭제 기능 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final counterState = ref.watch(counterProvider);
                  return Column(
                    children: [
                      // 서브 카운터 추가 버튼
                      ElevatedButton(
                        key: const Key('add_counter'),
                        onPressed: () =>
                            ref.read(counterProvider.notifier).addSubCounter(),
                        child: const Text('카운터 추가'),
                      ),

                      // 서브 카운터 표시
                      if (counterState.hasSubCounter)
                        SubCounterItem(
                          value: counterState.subCounter ?? 0,
                          onIncrement: () =>
                              ref.read(counterProvider.notifier).incrementSub(),
                          onDecrement: () =>
                              ref.read(counterProvider.notifier).decrementSub(),
                          onDelete: () => ref
                              .read(counterProvider.notifier)
                              .removeSubCounter(),
                          onReset: () =>
                              ref.read(counterProvider.notifier).resetSub(),
                          countByValue: counterState.subCountBy,
                          onCountByChanged: (value) => ref
                              .read(counterProvider.notifier)
                              .setSubCountBy(value),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // 초기 상태: 서브 카운터 없음
      expect(find.byType(SubCounterItem), findsNothing);

      // 서브 카운터 추가
      await tester.tap(find.byKey(const Key('add_counter')));
      await tester.pumpAndSettle();

      // 서브 카운터가 생성되었는지 확인
      expect(find.byType(SubCounterItem), findsOneWidget);

      // 서브 카운터 증가 테스트
      final incrementButton = find.byIcon(Icons.add).last;
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      // 서브 카운터 값이 증가했는지 확인
      final subCounterState = container.read(counterProvider);
      expect(subCounterState.subCounter, 1);

      // 서브 카운터 감소 테스트
      final decrementButton = find.byIcon(Icons.remove).last;
      await tester.tap(decrementButton);
      await tester.pumpAndSettle();

      final subCounterStateAfterDecrement = container.read(counterProvider);
      expect(subCounterStateAfterDecrement.subCounter, 0);

      // 서브 카운터 삭제 테스트
      final deleteButton = find.byIcon(Icons.close);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // 서브 카운터가 삭제되었는지 확인
      expect(find.byType(SubCounterItem), findsNothing);
      final finalState = container.read(counterProvider);
      expect(finalState.hasSubCounter, false);
    });

    test('count by 설정 기능 테스트', () {
      final counterNotifier = container.read(counterProvider.notifier);

      // 초기 count by 값 확인
      final initialState = container.read(counterProvider);
      expect(initialState.mainCountBy, 1);

      // count by 값 변경
      counterNotifier.setMainCountBy(3);
      final changedState = container.read(counterProvider);
      expect(changedState.mainCountBy, 3);

      // count by 3으로 증가 테스트
      counterNotifier.incrementMain();
      final afterIncrement1 = container.read(counterProvider);
      expect(afterIncrement1.mainCounter, 3);

      // 한 번 더 증가
      counterNotifier.incrementMain();
      final afterIncrement2 = container.read(counterProvider);
      expect(afterIncrement2.mainCounter, 6);

      // count by 3으로 감소 테스트
      counterNotifier.decrementMain();
      final afterDecrement = container.read(counterProvider);
      expect(afterDecrement.mainCounter, 3);
    });

    test('스톱워치 연동 기능 테스트', () async {
      // 스톱워치 상태 확인
      final stopwatchNotifier = container.read(stopwatchProvider.notifier);
      final initialStopwatchState = container.read(stopwatchProvider);

      expect(initialStopwatchState.isRunning, false);
      expect(initialStopwatchState.elapsed, Duration.zero);

      // 스톱워치 시작
      stopwatchNotifier.start();
      await Future.delayed(const Duration(milliseconds: 100));

      final runningState = container.read(stopwatchProvider);
      expect(runningState.isRunning, true);
      expect(runningState.elapsed.inMilliseconds, greaterThan(0));

      // 스톱워치 일시정지
      stopwatchNotifier.pause();
      final pausedState = container.read(stopwatchProvider);
      expect(pausedState.isRunning, false);
      expect(pausedState.elapsed.inMilliseconds, greaterThan(0));

      // 스톱워치 재개
      stopwatchNotifier.resume();
      final resumedState = container.read(stopwatchProvider);
      expect(resumedState.isRunning, true);

      // 스톱워치 중지
      stopwatchNotifier.stop();
      final stoppedState = container.read(stopwatchProvider);
      expect(stoppedState.isRunning, false);
    });

    test('카운터와 스톱워치 독립적 동작 테스트', () async {
      // 카운터 조작
      final counterNotifier = container.read(counterProvider.notifier);
      counterNotifier.incrementMain();

      final counterState = container.read(counterProvider);
      expect(counterState.mainCounter, 1);

      // 스톱워치 조작
      final stopwatchNotifier = container.read(stopwatchProvider.notifier);
      stopwatchNotifier.start();

      final stopwatchState = container.read(stopwatchProvider);
      expect(stopwatchState.isRunning, true);

      // 카운터 추가 조작이 스톱워치에 영향을 주지 않는지 확인
      counterNotifier.incrementMain();
      final counterStateAfter = container.read(counterProvider);
      final stopwatchStateAfter = container.read(stopwatchProvider);

      expect(counterStateAfter.mainCounter, 2);
      expect(stopwatchStateAfter.isRunning, true); // 여전히 실행 중
    });

    test('음수 방지 기능 테스트', () {
      final counterNotifier = container.read(counterProvider.notifier);

      // 초기 상태에서 감소 시도
      counterNotifier.decrementMain();
      final state1 = container.read(counterProvider);
      expect(state1.mainCounter, 0); // 음수가 되지 않음

      // 서브 카운터도 동일하게 테스트
      counterNotifier.addSubCounter();
      counterNotifier.decrementSub();
      final state2 = container.read(counterProvider);
      expect(state2.subCounter, 0); // 음수가 되지 않음
    });

    test('count by 값 유효성 검증 테스트', () {
      final counterNotifier = container.read(counterProvider.notifier);

      // 유효하지 않은 count by 값 설정 시도
      counterNotifier.setMainCountBy(0);
      final state1 = container.read(counterProvider);
      expect(state1.mainCountBy, 1); // 기본값 유지

      counterNotifier.setMainCountBy(-1);
      final state2 = container.read(counterProvider);
      expect(state2.mainCountBy, 1); // 기본값 유지

      // 유효한 값 설정
      counterNotifier.setMainCountBy(5);
      final state3 = container.read(counterProvider);
      expect(state3.mainCountBy, 5); // 정상 설정
    });

    test('서브 카운터 count by 설정 테스트', () {
      final counterNotifier = container.read(counterProvider.notifier);

      // 서브 카운터 추가
      counterNotifier.addSubCounter();

      // 서브 카운터 count by 값 변경
      counterNotifier.setSubCountBy(2);
      final state = container.read(counterProvider);
      expect(state.subCountBy, 2);

      // 서브 카운터 증가 테스트 (count by 2)
      counterNotifier.incrementSub();
      final afterIncrement = container.read(counterProvider);
      expect(afterIncrement.subCounter, 2);

      // 서브 카운터 감소 테스트 (count by 2)
      counterNotifier.decrementSub();
      final afterDecrement = container.read(counterProvider);
      expect(afterDecrement.subCounter, 0);
    });
  });
}
