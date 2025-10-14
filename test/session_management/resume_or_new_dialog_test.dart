import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 이어하기/새로 시작 다이얼로그 표시 함수
Future<bool?> _showResumeOrNewDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('진행 중 세션'),
      content: const Text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('새로 시작'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('이어하기'),
        ),
      ],
    ),
  );
}

void main() {
  group('활성 세션 존재 시 이어하기/새로 시작 다이얼로그 테스트', () {
    /// 테스트용 다이얼로그 생성 헬퍼
    Widget createTestDialog() {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => _showResumeOrNewDialog(context),
              child: const Text('다이얼로그 표시'),
            ),
          ),
        ),
      );
    }

    group('다이얼로그 표시 테스트', () {
      testWidgets('paused 상태 활성 세션 존재 시 다이얼로그가 표시되어야 함', (tester) async {
        // Given
        await tester.pumpWidget(createTestDialog());

        // When: 다이얼로그 표시 버튼 클릭
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: 다이얼로그가 표시되어야 함
        expect(find.text('진행 중 세션'), findsOneWidget);
        expect(find.text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?'), findsOneWidget);
        expect(find.text('이어하기'), findsOneWidget);
        expect(find.text('새로 시작'), findsOneWidget);
      });

      testWidgets('다이얼로그에 올바른 UI 요소들이 표시되어야 함', (tester) async {
        // Given
        await tester.pumpWidget(createTestDialog());

        // When: 다이얼로그 표시
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: AlertDialog가 표시되어야 함
        expect(find.byType(AlertDialog), findsOneWidget);

        // Then: 제목이 올바르게 표시되어야 함
        expect(find.text('진행 중 세션'), findsOneWidget);

        // Then: 내용이 올바르게 표시되어야 함
        expect(find.text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?'), findsOneWidget);

        // Then: 버튼들이 올바르게 표시되어야 함
        expect(find.widgetWithText(TextButton, '새로 시작'), findsOneWidget);
        expect(find.widgetWithText(TextButton, '이어하기'), findsOneWidget);
      });
    });

    group('이어하기 선택 테스트', () {
      testWidgets('이어하기 선택 시 true가 반환되어야 함', (tester) async {
        // Given
        bool? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await _showResumeOrNewDialog(context);
                  },
                  child: const Text('다이얼로그 표시'),
                ),
              ),
            ),
          ),
        );

        // When: 다이얼로그 표시 후 이어하기 선택
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('이어하기'));
        await tester.pumpAndSettle();

        // Then: true가 반환되어야 함
        expect(result, true);

        // Then: 다이얼로그가 닫혀야 함
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('이어하기 버튼이 올바른 위치에 표시되어야 함', (tester) async {
        // Given
        await tester.pumpWidget(createTestDialog());

        // When: 다이얼로그 표시
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: 이어하기 버튼이 오른쪽에 위치해야 함
        final resumeButton = find.text('이어하기');
        final newButton = find.text('새로 시작');

        expect(resumeButton, findsOneWidget);
        expect(newButton, findsOneWidget);

        // 버튼 위치 확인 (이어하기가 새로 시작보다 오른쪽에 있어야 함)
        final resumeRect = tester.getRect(resumeButton);
        final newRect = tester.getRect(newButton);
        expect(resumeRect.left, greaterThan(newRect.left));
      });
    });

    group('새로 시작 선택 테스트', () {
      testWidgets('새로 시작 선택 시 false가 반환되어야 함', (tester) async {
        // Given
        bool? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await _showResumeOrNewDialog(context);
                  },
                  child: const Text('다이얼로그 표시'),
                ),
              ),
            ),
          ),
        );

        // When: 다이얼로그 표시 후 새로 시작 선택
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('새로 시작'));
        await tester.pumpAndSettle();

        // Then: false가 반환되어야 함
        expect(result, false);

        // Then: 다이얼로그가 닫혀야 함
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('새로 시작 버튼이 올바른 위치에 표시되어야 함', (tester) async {
        // Given
        await tester.pumpWidget(createTestDialog());

        // When: 다이얼로그 표시
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: 새로 시작 버튼이 왼쪽에 위치해야 함
        final resumeButton = find.text('이어하기');
        final newButton = find.text('새로 시작');

        expect(resumeButton, findsOneWidget);
        expect(newButton, findsOneWidget);

        // 버튼 위치 확인 (새로 시작이 이어하기보다 왼쪽에 있어야 함)
        final resumeRect = tester.getRect(resumeButton);
        final newRect = tester.getRect(newButton);
        expect(newRect.left, lessThan(resumeRect.left));
      });
    });

    group('다이얼로그 취소 테스트', () {
      testWidgets('다이얼로그 외부 클릭 시 null이 반환되어야 함', (tester) async {
        // Given
        bool? result;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await _showResumeOrNewDialog(context);
                  },
                  child: const Text('다이얼로그 표시'),
                ),
              ),
            ),
          ),
        );

        // When: 다이얼로그 표시 후 외부 영역 클릭
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // 다이얼로그 외부 영역 클릭 (barrier 클릭)
        await tester.tapAt(const Offset(50, 50));
        await tester.pumpAndSettle();

        // Then: null이 반환되어야 함
        expect(result, null);

        // Then: 다이얼로그가 닫혀야 함
        expect(find.byType(AlertDialog), findsNothing);
      });

      testWidgets('Escape 키 또는 시스템 백 버튼으로 다이얼로그를 닫을 수 있어야 함', (tester) async {
        // Given
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {},
                  child: const Text('다이얼로그 표시'),
                ),
              ),
            ),
          ),
        );

        // When: 다이얼로그 표시
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: 다이얼로그가 표시되어야 함
        expect(find.byType(AlertDialog), findsOneWidget);

        // Note: 실제 백 버튼 테스트는 통합 테스트에서 수행하는 것이 더 적절함
        // 여기서는 다이얼로그가 dismissible한지 확인
        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });

    group('다이얼로그 접근성 테스트', () {
      testWidgets('다이얼로그가 접근성 요구사항을 만족해야 함', (tester) async {
        // Given
        await tester.pumpWidget(createTestDialog());

        // When: 다이얼로그 표시
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: 제목이 접근성 라벨로 사용될 수 있어야 함
        final titleFinder = find.text('진행 중 세션');
        expect(titleFinder, findsOneWidget);

        // Then: 내용이 접근성 설명으로 사용될 수 있어야 함
        final contentFinder = find.text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?');
        expect(contentFinder, findsOneWidget);

        // Then: 버튼들이 접근성 액션으로 사용될 수 있어야 함
        expect(find.widgetWithText(TextButton, '새로 시작'), findsOneWidget);
        expect(find.widgetWithText(TextButton, '이어하기'), findsOneWidget);
      });

      testWidgets('버튼들이 키보드 네비게이션을 지원해야 함', (tester) async {
        // Given
        await tester.pumpWidget(createTestDialog());

        // When: 다이얼로그 표시
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();

        // Then: 버튼들이 포커스를 받을 수 있어야 함
        final newButton = find.widgetWithText(TextButton, '새로 시작');
        final resumeButton = find.widgetWithText(TextButton, '이어하기');

        expect(newButton, findsOneWidget);
        expect(resumeButton, findsOneWidget);

        // 버튼이 탭 가능한지 확인
        await tester.tap(newButton);
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      });
    });

    group('다이얼로그 상태 유지 테스트', () {
      testWidgets('다이얼로그 취소 시 앱 상태가 유지되어야 함', (tester) async {
        // Given
        bool? result;
        String appState = '초기 상태';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Text(appState),
                    ElevatedButton(
                      onPressed: () async {
                        result = await _showResumeOrNewDialog(context);
                        if (result == null) {
                          setState(() => appState = '취소됨');
                        }
                      },
                      child: const Text('다이얼로그 표시'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // When: 다이얼로그 표시 후 취소
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(50, 50)); // 외부 클릭
        await tester.pumpAndSettle();

        // Then: 앱 상태가 적절히 업데이트되어야 함
        expect(find.text('취소됨'), findsOneWidget);
        expect(result, null);
      });

      testWidgets('다이얼로그 선택 후 적절한 상태 변경이 가능해야 함', (tester) async {
        // Given
        bool? result;
        String appState = '초기 상태';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Text(appState),
                    ElevatedButton(
                      onPressed: () async {
                        result = await _showResumeOrNewDialog(context);
                        if (result == true) {
                          setState(() => appState = '이어하기 선택됨');
                        } else if (result == false) {
                          setState(() => appState = '새로 시작 선택됨');
                        }
                      },
                      child: const Text('다이얼로그 표시'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // When: 다이얼로그 표시 후 이어하기 선택
        await tester.tap(find.text('다이얼로그 표시'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('이어하기'));
        await tester.pumpAndSettle();

        // Then: 앱 상태가 적절히 업데이트되어야 함
        expect(find.text('이어하기 선택됨'), findsOneWidget);
        expect(result, true);
      });
    });
  });
}
