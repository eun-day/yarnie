import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/features/projects/end_session_result.dart';
import 'package:yarnie/features/projects/end_session_sheet_cupertino.dart';
import 'package:yarnie/features/projects/end_session_sheet_material.dart';
import 'package:yarnie/widget/labelpill.dart';

void main() {
  group('세션 종료 다이얼로그 테스트', () {
    testWidgets('EndSessionSheetCupertino 렌더링 테스트', (tester) async {
      // Given
      const testDuration = Duration(minutes: 30, seconds: 45);
      const initialLabel = '뜨개질';
      String? selectedLabel = initialLabel;

      Future<String?> mockLabelPicker(String? initial) async {
        return selectedLabel;
      }

      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: EndSessionSheetCupertino(
              segment: testDuration,
              initialLabel: initialLabel,
              onPickLabel: mockLabelPicker,
            ),
          ),
        ),
      );

      // Then
      expect(find.byType(EndSessionSheetCupertino), findsOneWidget);
      expect(find.text('뜨개질'), findsOneWidget);
      expect(find.text('작업 메모'), findsOneWidget);
      expect(find.text('작업 시간 00:30:45을 저장하시겠습니까?'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
      expect(find.text('저장'), findsOneWidget);
      expect(find.byType(CupertinoTextField), findsOneWidget);
    });

    testWidgets('EndSessionSheetMaterial 렌더링 테스트', (tester) async {
      // Given
      const testDuration = Duration(hours: 1, minutes: 15, seconds: 30);
      const initialLabel = '자수';
      String? selectedLabel = initialLabel;

      Future<String?> mockLabelPicker(String? initial) async {
        return selectedLabel;
      }

      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: EndSessionSheetMaterial(
              segment: testDuration,
              initialLabel: initialLabel,
              onPickLabel: mockLabelPicker,
            ),
          ),
        ),
      );

      // Then
      expect(find.byType(EndSessionSheetMaterial), findsOneWidget);
      expect(find.text('자수'), findsOneWidget);
      expect(find.text('메모를 입력하세요'), findsOneWidget);
      expect(find.text('작업 시간 01:15:30을 저장하시겠습니까?'), findsOneWidget);
      expect(find.text('취소'), findsOneWidget);
      expect(find.text('저장'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('라벨 선택 기능 테스트 - Cupertino', (tester) async {
      // Given
      const testDuration = Duration(minutes: 10);
      String? currentLabel = '미분류';
      bool labelPickerCalled = false;

      Future<String?> mockLabelPicker(String? initial) async {
        labelPickerCalled = true;
        expect(initial, currentLabel);
        return '새 라벨';
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: EndSessionSheetCupertino(
              segment: testDuration,
              initialLabel: currentLabel,
              onPickLabel: mockLabelPicker,
            ),
          ),
        ),
      );

      // When: 라벨 탭
      await tester.tap(find.byType(LabelPill));
      await tester.pumpAndSettle();

      // Then
      expect(labelPickerCalled, true);
      expect(find.text('새 라벨'), findsOneWidget);
    });

    testWidgets('메모 입력 기능 테스트 - Material', (tester) async {
      // Given
      const testDuration = Duration(minutes: 5);
      const testMemo = '오늘은 패턴을 많이 진행했다';

      Future<String?> mockLabelPicker(String? initial) async => initial;

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: EndSessionSheetMaterial(
              segment: testDuration,
              initialLabel: '미분류',
              onPickLabel: mockLabelPicker,
            ),
          ),
        ),
      );

      // When: 메모 입력
      await tester.enterText(find.byType(TextField), testMemo);
      await tester.pump();

      // Then
      expect(find.text(testMemo), findsOneWidget);
    });

    testWidgets('저장 버튼 클릭 시 세션 완료 테스트 - Cupertino', (tester) async {
      // Given
      const testDuration = Duration(minutes: 20);
      const testLabel = '뜨개질';
      const testMemo = '스웨터 소매 완성';
      EndSessionResult? result;

      Future<String?> mockLabelPicker(String? initial) async => testLabel;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                child: const Text('테스트 시작'),
                onPressed: () async {
                  result = await showDialog<EndSessionResult>(
                    context: context,
                    builder: (_) => Dialog(
                      child: Material(
                        child: EndSessionSheetCupertino(
                          segment: testDuration,
                          initialLabel: testLabel,
                          onPickLabel: mockLabelPicker,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // When: 테스트 시작 버튼 탭
      await tester.tap(find.text('테스트 시작'));
      await tester.pumpAndSettle();

      // 메모 입력
      await tester.enterText(find.byType(CupertinoTextField), testMemo);
      await tester.pump();

      // 저장 버튼 탭
      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      // Then: 결과 확인
      expect(result, isNotNull);
      expect(result!.confirmed, true);
      expect(result!.label, testLabel);
      expect(result!.memo, testMemo);
    });

    testWidgets('취소 버튼 클릭 시 세션 상태 유지 테스트 - Material', (tester) async {
      // Given
      const testDuration = Duration(minutes: 15);
      const testLabel = '자수';
      EndSessionResult? result;

      Future<String?> mockLabelPicker(String? initial) async => testLabel;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                child: const Text('테스트 시작'),
                onPressed: () async {
                  result = await showDialog<EndSessionResult>(
                    context: context,
                    builder: (_) => Dialog(
                      child: Material(
                        child: EndSessionSheetMaterial(
                          segment: testDuration,
                          initialLabel: testLabel,
                          onPickLabel: mockLabelPicker,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // When: 테스트 시작 버튼 탭
      await tester.tap(find.text('테스트 시작'));
      await tester.pumpAndSettle();

      // 메모 입력 (저장되지 않아야 함)
      await tester.enterText(find.byType(TextField), '취소될 메모');
      await tester.pump();

      // 취소 버튼 탭
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      // Then: 취소 결과 확인
      expect(result, isNotNull);
      expect(result!.confirmed, false);
      expect(result!.memo, isNull);
    });

    testWidgets('미분류 라벨 기본값 테스트', (tester) async {
      // Given
      const testDuration = Duration(minutes: 5);

      Future<String?> mockLabelPicker(String? initial) async => initial;

      // When: 초기 라벨이 null인 경우
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: EndSessionSheetMaterial(
              segment: testDuration,
              initialLabel: null,
              onPickLabel: mockLabelPicker,
            ),
          ),
        ),
      );

      // Then: 미분류가 기본값으로 표시되어야 함
      expect(find.text('미분류'), findsOneWidget);
    });

    testWidgets('빈 메모 처리 테스트', (tester) async {
      // Given
      const testDuration = Duration(minutes: 3);
      EndSessionResult? result;

      Future<String?> mockLabelPicker(String? initial) async => '테스트';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                child: const Text('테스트 시작'),
                onPressed: () async {
                  result = await showDialog<EndSessionResult>(
                    context: context,
                    builder: (_) => Dialog(
                      child: Material(
                        child: EndSessionSheetCupertino(
                          segment: testDuration,
                          initialLabel: '테스트',
                          onPickLabel: mockLabelPicker,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // When: 빈 메모로 저장
      await tester.tap(find.text('테스트 시작'));
      await tester.pumpAndSettle();

      // 빈 문자열 입력
      await tester.enterText(find.byType(CupertinoTextField), '   ');
      await tester.pump();

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      // Then: 빈 메모는 빈 문자열로 처리됨 (trim 결과)
      expect(result, isNotNull);
      expect(result!.confirmed, true);
      expect(result!.memo, '');
    });
  });

  group('showEndSessionSheet 함수 테스트', () {
    testWidgets('플랫폼별 다이얼로그 표시 테스트', (tester) async {
      // Given
      const testDuration = Duration(minutes: 10);
      Future<String?> mockLabelPicker(String? initial) async => initial;

      // Material 앱에서 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                child: const Text('다이얼로그 열기'),
                onPressed: () async {
                  await showEndSessionSheet(
                    context: context,
                    segment: testDuration,
                    initialLabel: '테스트',
                    onPickLabel: mockLabelPicker,
                  );
                },
              ),
            ),
          ),
        ),
      );

      // When
      await tester.tap(find.text('다이얼로그 열기'));
      await tester.pumpAndSettle();

      // Then: Material 다이얼로그가 표시되어야 함 (iOS가 아닌 경우)
      if (!Platform.isIOS) {
        expect(find.byType(EndSessionSheetMaterial), findsOneWidget);
      }
    });
  });
}
