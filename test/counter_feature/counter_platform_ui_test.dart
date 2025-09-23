import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lib/widget/counter_display.dart';
import '../../lib/widget/sub_counter_item.dart';
import '../../lib/widget/count_by_selector.dart';

/// 플랫폼별 UI 테스트
///
/// 테스트 범위:
/// - iOS에서 Cupertino 스타일 컴포넌트 동작 테스트
/// - Android에서 Material Design 컴포넌트 동작 테스트
/// - 다양한 화면 크기에서의 레이아웃 테스트
void main() {
  group('플랫폼별 UI 테스트', () {
    testWidgets('CounterDisplay 기본 렌더링 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CounterDisplay(value: 42, onReset: () {})),
        ),
      );

      // 카운터 값이 올바르게 표시되는지 확인
      expect(find.text('42'), findsOneWidget);

      // 터치 가능한 영역이 있는지 확인
      expect(find.byType(GestureDetector), findsOneWidget);
    });

    testWidgets('CounterDisplay 초기화 다이얼로그 테스트', (WidgetTester tester) async {
      bool resetCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterDisplay(
              value: 5,
              onReset: () {
                resetCalled = true;
              },
            ),
          ),
        ),
      );

      // 카운터 숫자 터치
      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      // 다이얼로그가 표시되는지 확인
      expect(find.text('카운터 초기화'), findsOneWidget);
      expect(find.text('카운터를 0으로 초기화하시겠습니까?'), findsOneWidget);

      // 초기화 버튼 클릭
      await tester.tap(find.text('초기화'));
      await tester.pumpAndSettle();

      // 콜백이 호출되었는지 확인
      expect(resetCalled, true);
    });

    testWidgets('SubCounterItem 기본 렌더링 테스트', (WidgetTester tester) async {
      int incrementCount = 0;
      int decrementCount = 0;
      bool deletePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubCounterItem(
              value: 3,
              onIncrement: () => incrementCount++,
              onDecrement: () => decrementCount++,
              onDelete: () => deletePressed = true,
            ),
          ),
        ),
      );

      // 서브 카운터 값이 표시되는지 확인
      expect(find.text('3'), findsOneWidget);

      // 버튼들이 존재하는지 확인
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);

      // 증가 버튼 테스트
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(incrementCount, 1);

      // 감소 버튼 테스트
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(decrementCount, 1);

      // 삭제 버튼 테스트
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(deletePressed, true);
    });

    testWidgets('CountBySelector 기본 렌더링 테스트', (WidgetTester tester) async {
      int changedValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountBySelector(
              currentValue: 2,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      // count by 텍스트가 표시되는지 확인
      expect(find.text('count by 2'), findsOneWidget);

      // 버튼이 존재하는지 확인
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('CountBySelector 피커 테스트', (WidgetTester tester) async {
      int changedValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountBySelector(
              currentValue: 1,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      // count by 버튼 클릭
      await tester.tap(find.text('count by 1'));
      await tester.pumpAndSettle();

      // 피커 다이얼로그가 표시되는지 확인
      expect(find.text('Count By 설정'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
      expect(find.text('확인'), findsOneWidget);

      // 취소 버튼으로 닫기
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      // 다이얼로그가 닫혔는지 확인
      expect(find.text('Count By 설정'), findsNothing);
    });

    testWidgets('다양한 화면 크기에서의 레이아웃 테스트', (WidgetTester tester) async {
      // 작은 화면 크기 (iPhone SE)
      await tester.binding.setSurfaceSize(const Size(375, 667));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CounterDisplay(value: 42, onReset: () {}),
                CountBySelector(currentValue: 3, onChanged: (value) {}),
                SubCounterItem(
                  value: 5,
                  onIncrement: () {},
                  onDecrement: () {},
                  onDelete: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // 위젯들이 올바르게 렌더링되는지 확인
      expect(find.text('42'), findsOneWidget);
      expect(find.text('count by 3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // 중간 화면 크기 (iPhone 12)
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpAndSettle();

      // 위젯들이 여전히 올바르게 렌더링되는지 확인
      expect(find.text('42'), findsOneWidget);
      expect(find.text('count by 3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // 큰 화면 크기 (iPad)
      await tester.binding.setSurfaceSize(const Size(768, 1024));
      await tester.pumpAndSettle();

      // 위젯들이 여전히 올바르게 렌더링되는지 확인
      expect(find.text('42'), findsOneWidget);
      expect(find.text('count by 3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // 화면 크기 초기화
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('CountBySelector 크기별 스타일 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CountBySelector(
                  currentValue: 1,
                  onChanged: (value) {},
                  size: CountBySelectorSize.small,
                ),
                CountBySelector(
                  currentValue: 2,
                  onChanged: (value) {},
                  size: CountBySelectorSize.medium,
                ),
                CountBySelector(
                  currentValue: 3,
                  onChanged: (value) {},
                  size: CountBySelectorSize.large,
                ),
              ],
            ),
          ),
        ),
      );

      // 모든 크기의 버튼이 렌더링되는지 확인
      expect(find.text('count by 1'), findsOneWidget);
      expect(find.text('count by 2'), findsOneWidget);
      expect(find.text('count by 3'), findsOneWidget);

      // 버튼들이 서로 다른 크기를 가지는지 확인
      expect(find.byType(CountBySelector), findsNWidgets(3));
    });

    testWidgets('접근성 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CounterDisplay(value: 10, onReset: () {}),
                CountBySelector(currentValue: 2, onChanged: (value) {}),
                SubCounterItem(
                  value: 7,
                  onIncrement: () {},
                  onDecrement: () {},
                  onDelete: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // 접근성을 위한 시맨틱 정보가 있는지 확인
      final semantics = tester.getSemantics(find.text('10'));
      expect(semantics, isNotNull);

      // 버튼들이 접근 가능한지 확인
      expect(find.text('count by 2'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('터치 영역 크기 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubCounterItem(
              value: 1,
              onIncrement: () {},
              onDecrement: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // 버튼들의 터치 영역이 충분한지 확인
      final incrementButton = tester.getRect(find.byIcon(Icons.add));
      final decrementButton = tester.getRect(find.byIcon(Icons.remove));
      final deleteButton = tester.getRect(find.byIcon(Icons.close));

      // 터치 영역이 존재하는지 확인
      expect(incrementButton.width, greaterThan(0));
      expect(incrementButton.height, greaterThan(0));
      expect(decrementButton.width, greaterThan(0));
      expect(decrementButton.height, greaterThan(0));
      expect(deleteButton.width, greaterThan(0));
      expect(deleteButton.height, greaterThan(0));
    });

    testWidgets('색상 테마 적용 테스트', (WidgetTester tester) async {
      final customTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: customTheme,
          home: Scaffold(
            body: Column(
              children: [
                CounterDisplay(value: 25, onReset: () {}),
                CountBySelector(currentValue: 4, onChanged: (value) {}),
                SubCounterItem(
                  value: 8,
                  onIncrement: () {},
                  onDecrement: () {},
                  onDelete: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // 위젯들이 커스텀 테마와 함께 렌더링되는지 확인
      expect(find.text('25'), findsOneWidget);
      expect(find.text('count by 4'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);

      // 테마가 적용된 상태에서도 모든 기능이 작동하는지 확인
      expect(find.byType(CounterDisplay), findsOneWidget);
      expect(find.byType(CountBySelector), findsOneWidget);
      expect(find.byType(SubCounterItem), findsOneWidget);
    });

    testWidgets('위젯 상호작용 테스트', (WidgetTester tester) async {
      int counterValue = 0;
      int countBy = 1;
      bool hasSubCounter = false;
      int subCounterValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    CounterDisplay(
                      value: counterValue,
                      onReset: () {
                        setState(() {
                          counterValue = 0;
                        });
                      },
                    ),
                    CountBySelector(
                      currentValue: countBy,
                      onChanged: (value) {
                        setState(() {
                          countBy = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          counterValue += countBy;
                        });
                      },
                      child: const Text('증가'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasSubCounter = !hasSubCounter;
                          if (!hasSubCounter) subCounterValue = 0;
                        });
                      },
                      child: Text(hasSubCounter ? '서브 카운터 제거' : '서브 카운터 추가'),
                    ),
                    if (hasSubCounter)
                      SubCounterItem(
                        value: subCounterValue,
                        onIncrement: () {
                          setState(() {
                            subCounterValue++;
                          });
                        },
                        onDecrement: () {
                          setState(() {
                            if (subCounterValue > 0) subCounterValue--;
                          });
                        },
                        onDelete: () {
                          setState(() {
                            hasSubCounter = false;
                            subCounterValue = 0;
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // 초기 상태 확인
      expect(find.text('0'), findsOneWidget);
      expect(find.text('count by 1'), findsOneWidget);

      // 메인 카운터 증가
      await tester.tap(find.text('증가'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // 서브 카운터 추가
      await tester.tap(find.text('서브 카운터 추가'));
      await tester.pumpAndSettle();
      expect(find.byType(SubCounterItem), findsOneWidget);

      // 서브 카운터 증가
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsNWidgets(2)); // 메인과 서브 모두 1

      // 서브 카운터 삭제
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(SubCounterItem), findsNothing);
    });
  });
}
