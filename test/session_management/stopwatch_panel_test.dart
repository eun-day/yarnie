import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';
import 'package:yarnie/stopwatch_panel.dart';

void main() {
  group('StopwatchPanel 위젯 테스트', () {
    late int testProjectId;

    setUp(() async {
      testProjectId = 1;
    });

    /// 테스트용 앱 위젯 생성 헬퍼
    Widget createTestApp({required Widget child}) {
      return ProviderScope(
        child: MaterialApp(home: Scaffold(body: child)),
      );
    }

    group('초기 상태 렌더링 테스트', () {
      testWidgets('초기 상태에서 기본 UI 요소들이 표시되어야 함', (tester) async {
        // Given
        await tester.pumpWidget(
          createTestApp(
            child: StopwatchPanel(
              projectId: testProjectId,
              initialLabels: const ['소매', '몸통', '목둘레'],
            ),
          ),
        );

        // 초기 렌더링 대기
        await tester.pump();

        // Then: 시작 버튼 표시 확인
        expect(find.text('시작'), findsOneWidget);
        expect(find.byIcon(Icons.play_arrow), findsOneWidget);

        // Then: 랩 버튼 표시 확인
        expect(find.text('랩'), findsOneWidget);
        expect(find.byIcon(Icons.flag), findsOneWidget);

        // Then: 초기화 버튼 표시 확인
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });

      testWidgets('초기 라벨이 올바르게 표시되어야 함', (tester) async {
        // Given
        await tester.pumpWidget(
          createTestApp(
            child: StopwatchPanel(
              projectId: testProjectId,
              initialLabels: const ['테스트라벨1', '테스트라벨2'],
            ),
          ),
        );

        await tester.pump();

        // Then: 첫 번째 라벨이 표시되어야 함
        expect(find.text('테스트라벨1'), findsOneWidget);
      });
    });

    group('StopwatchProvider 상태 관리 테스트', () {
      testWidgets('StopwatchProvider 초기 상태가 올바르게 설정되어야 함', (tester) async {
        late StopwatchState initialState;

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, child) {
                initialState = ref.watch(stopwatchProvider);
                return Container();
              },
            ),
          ),
        );

        // Then: 초기 상태 확인
        expect(initialState.elapsed, Duration.zero);
        expect(initialState.isRunning, false);
      });

      testWidgets('StopwatchProvider start 호출 시 상태가 변경되어야 함', (tester) async {
        late StopwatchNotifier notifier;
        late StopwatchState state;

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, child) {
                notifier = ref.read(stopwatchProvider.notifier);
                state = ref.watch(stopwatchProvider);
                return Container();
              },
            ),
          ),
        );

        // When: start 호출
        notifier.start();
        await tester.pump();

        // Then: 상태가 running으로 변경되어야 함
        expect(state.isRunning, true);

        // 타이머 정리
        notifier.reset();
        await tester.pump();
      });

      testWidgets('StopwatchProvider pause 호출 시 상태가 변경되어야 함', (tester) async {
        late StopwatchNotifier notifier;
        late StopwatchState state;

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, child) {
                notifier = ref.read(stopwatchProvider.notifier);
                state = ref.watch(stopwatchProvider);
                return Container();
              },
            ),
          ),
        );

        // Given: 먼저 시작
        notifier.start();
        await tester.pump();

        // When: pause 호출
        notifier.pause();
        await tester.pump();

        // Then: 상태가 paused로 변경되어야 함
        expect(state.isRunning, false);
        expect(state.elapsed, greaterThanOrEqualTo(Duration.zero));
      });

      testWidgets('StopwatchProvider reset 호출 시 상태가 초기화되어야 함', (tester) async {
        late StopwatchNotifier notifier;
        late StopwatchState state;

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, child) {
                notifier = ref.read(stopwatchProvider.notifier);
                state = ref.watch(stopwatchProvider);
                return Container();
              },
            ),
          ),
        );

        // Given: 시작 후 일시정지
        notifier.start();
        await tester.pump();
        notifier.pause();
        await tester.pump();

        // When: reset 호출
        notifier.reset();
        await tester.pump();

        // Then: 상태가 초기화되어야 함
        expect(state.isRunning, false);
        expect(state.elapsed, Duration.zero);
      });

      testWidgets('StopwatchProvider setElapsed 호출 시 경과 시간이 설정되어야 함', (
        tester,
      ) async {
        late StopwatchNotifier notifier;
        late StopwatchState state;

        await tester.pumpWidget(
          ProviderScope(
            child: Consumer(
              builder: (context, ref, child) {
                notifier = ref.read(stopwatchProvider.notifier);
                state = ref.watch(stopwatchProvider);
                return Container();
              },
            ),
          ),
        );

        // When: setElapsed 호출
        const testDuration = Duration(minutes: 5);
        notifier.setElapsed(testDuration);
        await tester.pump();

        // Then: 경과 시간이 설정되어야 함
        expect(state.elapsed, testDuration);
        expect(state.isRunning, false);
      });
    });

    group('UI 상호작용 테스트', () {
      testWidgets('버튼들이 올바른 아이콘과 텍스트를 가져야 함', (tester) async {
        // Given
        await tester.pumpWidget(
          createTestApp(
            child: StopwatchPanel(
              projectId: testProjectId,
              initialLabels: const ['테스트'],
            ),
          ),
        );

        await tester.pump();

        // Then: 시작 버튼 확인
        expect(
          find.widgetWithIcon(ElevatedButton, Icons.play_arrow),
          findsOneWidget,
        );
        expect(find.widgetWithText(ElevatedButton, '시작'), findsOneWidget);

        // Then: 랩 버튼 확인
        expect(find.widgetWithIcon(OutlinedButton, Icons.flag), findsOneWidget);
        expect(find.widgetWithText(OutlinedButton, '랩'), findsOneWidget);

        // Then: 초기화 버튼 확인
        expect(find.widgetWithIcon(IconButton, Icons.refresh), findsOneWidget);
      });
    });

    group('시간 표시 형식 테스트', () {
      testWidgets('시간이 올바른 형식으로 표시되어야 함', (tester) async {
        late StopwatchNotifier notifier;

        await tester.pumpWidget(
          createTestApp(
            child: Consumer(
              builder: (context, ref, child) {
                notifier = ref.read(stopwatchProvider.notifier);
                return StopwatchPanel(
                  projectId: testProjectId,
                  initialLabels: const ['테스트'],
                );
              },
            ),
          ),
        );

        await tester.pump();

        // When: 특정 시간 설정
        notifier.setElapsed(const Duration(hours: 1, minutes: 23, seconds: 45));
        await tester.pump();

        // Then: 시간이 올바른 형식으로 표시되어야 함
        expect(find.text('01:23:45'), findsOneWidget);
      });

      testWidgets('0시간이 올바르게 표시되어야 함', (tester) async {
        late StopwatchNotifier notifier;

        await tester.pumpWidget(
          createTestApp(
            child: Consumer(
              builder: (context, ref, child) {
                notifier = ref.read(stopwatchProvider.notifier);
                return StopwatchPanel(
                  projectId: testProjectId,
                  initialLabels: const ['테스트'],
                );
              },
            ),
          ),
        );

        await tester.pump();

        // When: 0시간 설정
        notifier.setElapsed(Duration.zero);
        await tester.pump();

        // Then: 0시간이 올바르게 표시되어야 함
        expect(find.text('00:00:00'), findsOneWidget);
      });
    });

    group('에러 처리 테스트', () {
      testWidgets('잘못된 projectId로도 위젯이 렌더링되어야 함', (tester) async {
        // Given: 잘못된 projectId
        const invalidProjectId = -1;

        // When: 위젯 생성
        await tester.pumpWidget(
          createTestApp(
            child: StopwatchPanel(
              projectId: invalidProjectId,
              initialLabels: const ['테스트'],
            ),
          ),
        );

        await tester.pump();

        // Then: 기본 UI 요소들이 표시되어야 함
        expect(find.text('시작'), findsOneWidget);
        expect(find.text('랩'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });

      testWidgets('빈 라벨 리스트로도 위젯이 렌더링되어야 함', (tester) async {
        // Given: 빈 라벨 리스트
        await tester.pumpWidget(
          createTestApp(
            child: StopwatchPanel(
              projectId: testProjectId,
              initialLabels: const [],
            ),
          ),
        );

        await tester.pump();

        // Then: 기본 UI 요소들이 표시되어야 함
        expect(find.text('시작'), findsOneWidget);
        expect(find.text('랩'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);

        // Then: 미분류 라벨이 표시되어야 함
        expect(find.text('미분류'), findsOneWidget);
      });
    });
  });
}
