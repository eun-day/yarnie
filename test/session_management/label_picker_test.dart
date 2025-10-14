import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yarnie/widget/labelpill.dart';

void main() {
  group('플랫폼별 라벨 선택기 테스트', () {
    group('iOS - CupertinoModalBottomSheet 테스트', () {
      testWidgets('Cupertino 라벨 선택기 렌더링 테스트', (tester) async {
        // Given
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        final testLabels = ['뜨개질', '자수', '퀼트'];
        String? selectedLabel;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  child: const Text('라벨 선택'),
                  onPressed: () async {
                    selectedLabel = await showCupertinoModalBottomSheet<String>(
                      context: context,
                      expand: false,
                      backgroundColor: CupertinoColors.systemBackground,
                      builder: (ctx) {
                        final bottomPad = MediaQuery.of(ctx).viewInsets.bottom;
                        return SafeArea(
                          top: false,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.label,
                              decoration: TextDecoration.none,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                16 + bottomPad,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // 상단 제목 + 라벨 관리 버튼
                                  Row(
                                    children: [
                                      const Text(
                                        '라벨 선택',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        child: const Icon(
                                          CupertinoIcons.pencil,
                                        ),
                                        onPressed: () {
                                          // 라벨 관리 기능 (테스트용 간소화)
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // 라벨 목록
                                  ...testLabels.map(
                                    (label) => CupertinoButton(
                                      child: Text(label),
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(label),
                                    ),
                                  ),
                                  // 미분류 옵션
                                  CupertinoButton(
                                    child: const Text('미분류'),
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(null),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    // 결과를 화면에 표시
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('selected:${selectedLabel ?? "미분류"}'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );

        // When: 라벨 선택 버튼 탭
        await tester.tap(find.text('라벨 선택'));
        await tester.pumpAndSettle();

        // Then: Cupertino 스타일 요소들이 표시되어야 함
        expect(find.text('라벨 선택'), findsWidgets); // 버튼과 제목 모두
        expect(find.byIcon(CupertinoIcons.pencil), findsOneWidget);
        expect(find.text('뜨개질'), findsOneWidget);
        expect(find.text('자수'), findsOneWidget);
        expect(find.text('퀼트'), findsOneWidget);
        expect(find.text('미분류'), findsOneWidget);

        // When: 특정 라벨 선택
        await tester.tap(find.text('뜨개질'));
        await tester.pumpAndSettle();

        // Then: 선택된 라벨이 반환되어야 함
        expect(find.text('selected:뜨개질'), findsOneWidget);

        // Cleanup
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('미분류 라벨 선택 테스트', (tester) async {
        // Given
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        String? selectedLabel = '초기값';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  child: const Text('미분류 선택'),
                  onPressed: () async {
                    selectedLabel = await showCupertinoModalBottomSheet<String>(
                      context: context,
                      expand: false,
                      backgroundColor: CupertinoColors.systemBackground,
                      builder: (ctx) => SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoButton(
                                child: const Text('미분류'),
                                onPressed: () => Navigator.of(ctx).pop(null),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('result:${selectedLabel ?? "null"}'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );

        // When: 미분류 선택
        await tester.tap(find.text('미분류 선택'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('미분류'));
        await tester.pumpAndSettle();

        // Then: null이 반환되어야 함
        expect(find.text('result:null'), findsOneWidget);

        // Cleanup
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('Android - Material BottomSheet 테스트', () {
      testWidgets('Material 라벨 선택기 렌더링 테스트', (tester) async {
        // Given
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final testLabels = ['뜨개질', '자수', '퀼트'];
        String? selectedLabel;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  child: const Text('라벨 선택'),
                  onPressed: () async {
                    selectedLabel = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (ctx) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 상단 제목 + 라벨 관리 버튼
                            Row(
                              children: [
                                Text(
                                  '라벨 선택',
                                  style: Theme.of(ctx).textTheme.titleLarge,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // 라벨 관리 기능
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // ChoiceChip 기반 라벨 선택
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ...testLabels.map(
                                  (label) => ChoiceChip(
                                    label: Text(label),
                                    selected: false,
                                    onSelected: (_) =>
                                        Navigator.of(ctx).pop(label),
                                  ),
                                ),
                                ChoiceChip(
                                  label: const Text('미분류'),
                                  selected: false,
                                  onSelected: (_) =>
                                      Navigator.of(ctx).pop(null),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('selected:${selectedLabel ?? "미분류"}'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );

        // When: 라벨 선택 버튼 탭
        await tester.tap(find.text('라벨 선택'));
        await tester.pumpAndSettle();

        // Then: Material 스타일 요소들이 표시되어야 함
        expect(find.text('라벨 선택'), findsWidgets); // 버튼과 제목 모두
        expect(find.byIcon(Icons.edit), findsOneWidget);
        expect(find.byType(ChoiceChip), findsNWidgets(4)); // 3개 라벨 + 미분류
        expect(find.text('뜨개질'), findsOneWidget);
        expect(find.text('자수'), findsOneWidget);
        expect(find.text('퀼트'), findsOneWidget);
        expect(find.text('미분류'), findsOneWidget);

        // When: 특정 라벨 선택
        await tester.tap(find.text('자수'));
        await tester.pumpAndSettle();

        // Then: 선택된 라벨이 반환되어야 함
        expect(find.text('selected:자수'), findsOneWidget);

        // Cleanup
        debugDefaultTargetPlatformOverride = null;
      });

      testWidgets('ChoiceChip 기반 라벨 선택 테스트', (tester) async {
        // Given
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        final testLabels = ['패턴A', '패턴B'];
        String? selectedLabel;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  child: const Text('ChoiceChip 테스트'),
                  onPressed: () async {
                    selectedLabel = await showModalBottomSheet<String>(
                      context: context,
                      builder: (ctx) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          children: testLabels
                              .map(
                                (label) => ChoiceChip(
                                  label: Text(label),
                                  selected: false,
                                  onSelected: (_) =>
                                      Navigator.of(ctx).pop(label),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('chip_selected:$selectedLabel')),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );

        // When: ChoiceChip 테스트 버튼 탭
        await tester.tap(find.text('ChoiceChip 테스트'));
        await tester.pumpAndSettle();

        // ChoiceChip 선택
        await tester.tap(find.text('패턴B'));
        await tester.pumpAndSettle();

        // Then: ChoiceChip으로 선택된 라벨이 반환되어야 함
        expect(find.text('chip_selected:패턴B'), findsOneWidget);

        // Cleanup
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('라벨 관리 기능 테스트', () {
      testWidgets('라벨 추가 기능 테스트', (tester) async {
        // Given
        final labels = <String>['기존라벨'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Text('라벨 개수: ${labels.length}'),
                    ...labels.map((label) => Text('라벨: $label')),
                    ElevatedButton(
                      child: const Text('라벨 추가'),
                      onPressed: () {
                        setState(() {
                          labels.add('새라벨');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // When: 라벨 추가 버튼 탭
        await tester.tap(find.text('라벨 추가'));
        await tester.pump();

        // Then: 새 라벨이 추가되어야 함
        expect(find.text('라벨 개수: 2'), findsOneWidget);
        expect(find.text('라벨: 새라벨'), findsOneWidget);
      });

      testWidgets('라벨 삭제 기능 테스트', (tester) async {
        // Given
        final labels = <String>['라벨1', '라벨2', '삭제될라벨'];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Text('라벨 개수: ${labels.length}'),
                    ...labels.map(
                      (label) => Row(
                        children: [
                          Text('라벨: $label'),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                labels.remove(label);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // When: 특정 라벨 삭제
        await tester.tap(find.byIcon(Icons.delete).at(2)); // 세 번째 삭제 버튼
        await tester.pump();

        // Then: 해당 라벨이 삭제되어야 함
        expect(find.text('라벨 개수: 2'), findsOneWidget);
        expect(find.text('라벨: 삭제될라벨'), findsNothing);
        expect(find.text('라벨: 라벨1'), findsOneWidget);
        expect(find.text('라벨: 라벨2'), findsOneWidget);
      });

      testWidgets('빈 라벨 목록 처리 테스트', (tester) async {
        // Given
        final labels = <String>[];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Text('라벨 개수: ${labels.length}'),
                    if (labels.isEmpty)
                      const Text('라벨이 없습니다')
                    else
                      ...labels.map((label) => Text('라벨: $label')),
                    ElevatedButton(
                      child: const Text('첫 라벨 추가'),
                      onPressed: () {
                        setState(() {
                          labels.add('첫번째라벨');
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Then: 빈 상태가 올바르게 표시되어야 함
        expect(find.text('라벨 개수: 0'), findsOneWidget);
        expect(find.text('라벨이 없습니다'), findsOneWidget);

        // When: 첫 라벨 추가
        await tester.tap(find.text('첫 라벨 추가'));
        await tester.pump();

        // Then: 라벨이 추가되고 빈 상태 메시지가 사라져야 함
        expect(find.text('라벨 개수: 1'), findsOneWidget);
        expect(find.text('라벨이 없습니다'), findsNothing);
        expect(find.text('라벨: 첫번째라벨'), findsOneWidget);
      });
    });

    group('LabelPill 위젯 테스트', () {
      testWidgets('LabelPill 렌더링 및 탭 기능 테스트', (tester) async {
        // Given
        bool tapped = false;
        const labelText = '테스트라벨';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LabelPill(
                text: labelText,
                isIOS: false,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        // Then: LabelPill이 올바르게 렌더링되어야 함
        expect(find.byType(LabelPill), findsOneWidget);
        expect(find.text(labelText), findsOneWidget);

        // When: LabelPill 탭
        await tester.tap(find.byType(LabelPill));
        await tester.pump();

        // Then: onTap 콜백이 호출되어야 함
        expect(tapped, true);
      });

      testWidgets('iOS 스타일 LabelPill 테스트', (tester) async {
        // Given
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: LabelPill(
                text: 'iOS라벨',
                isIOS: true,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        // When: iOS 스타일 LabelPill 탭
        await tester.tap(find.text('iOS라벨'));
        await tester.pump();

        // Then: 탭 기능이 정상 작동해야 함
        expect(tapped, true);

        // Cleanup
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
