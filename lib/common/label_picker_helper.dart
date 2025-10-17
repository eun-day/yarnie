import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LabelPickerHelper {
  // iOS/Android 공용 라벨 선택기: 선택한 라벨(String?)을 리턴
  static Future<String?> openLabelPicker({
    required BuildContext context,
    required List<String> labels,
    String? initial,
    Function(List<String>)? onLabelsUpdated,
  }) async {
    if (Platform.isIOS) {
      // iOS: Cupertino 스타일 (modal_bottom_sheet 사용)
      return showCupertinoModalBottomSheet<String>(
        context: context,
        expand: false,
        backgroundColor: CupertinoColors.systemBackground,
        builder: (ctx) {
          final bottomPad = MediaQuery.of(ctx).viewInsets.bottom;
          return Material(
            type: MaterialType.transparency,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
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
                        if (onLabelsUpdated != null)
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.pencil),
                            onPressed: () async {
                              final updated = await _openLabelManager(
                                ctx,
                                labels,
                              );
                              if (updated != null) {
                                onLabelsUpdated(updated);
                              }
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CupertinoScrollbar(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final l in labels)
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: (initial == l)
                                    ? CupertinoColors.activeBlue
                                    : CupertinoColors.systemGrey6,
                                onPressed: () => Navigator.pop(ctx, l),
                                child: Text(
                                  l,
                                  style: TextStyle(
                                    color: (initial == l)
                                        ? CupertinoColors.white
                                        : CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: (initial == null)
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.systemGrey6,
                              onPressed: () => Navigator.pop(ctx, ''),
                              child: Text(
                                '미분류',
                                style: TextStyle(
                                  color: (initial == null)
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Android: Material 바텀시트 + ChoiceChip
      return showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          final bottomPad =
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom;
          return SafeArea(
            top: true,
            left: true,
            right: true,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (onLabelsUpdated != null)
                        IconButton(
                          tooltip: '라벨 관리',
                          onPressed: () async {
                            final updated = await _openLabelManager(
                              ctx,
                              labels,
                            );
                            if (updated != null) {
                              onLabelsUpdated(updated);
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final l in labels)
                        ChoiceChip(
                          label: Text(l),
                          selected: initial == l,
                          onSelected: (_) => Navigator.pop(ctx, l),
                        ),
                      ChoiceChip(
                        label: const Text('미분류'),
                        selected: initial == null,
                        onSelected: (_) => Navigator.pop(ctx, ''),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static Future<List<String>?> _openLabelManager(
    BuildContext ctx,
    List<String> initial,
  ) async {
    final temp = [...initial];
    final controller = TextEditingController();
    return showModalBottomSheet<List<String>>(
      context: ctx,
      isScrollControlled: true,
      builder: (ctx2) {
        final mq = MediaQuery.of(ctx2);
        final bottomPad = mq.viewInsets.bottom + mq.viewPadding.bottom;

        return SafeArea(
          top: true,
          left: true,
          right: true,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
            child: StatefulBuilder(
              builder: (_, setSB) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '라벨 관리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final l in temp)
                        Chip(
                          label: Text(l),
                          onDeleted: () => setSB(() => temp.remove(l)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: '라벨 추가',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (v) {
                            final t = v.trim();
                            if (t.isNotEmpty && !temp.contains(t)) {
                              setSB(() => temp.add(t));
                            }
                            controller.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final t = controller.text.trim();
                          if (t.isNotEmpty && !temp.contains(t)) {
                            setSB(() => temp.add(t));
                          }
                          controller.clear();
                        },
                        child: const Text('추가'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx2, null),
                        child: const Text('취소'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx2, temp),
                        child: const Text('저장'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
