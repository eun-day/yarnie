import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/counter_card/base_counter_card.dart';

class IntervalCounterCard extends StatelessWidget {
  final String label;
  final int intervalRows; // e.g. 3행마다
  final int currentCount; // e.g. 0
  final int totalCount; // e.g. 5
  final int startRow;
  final bool isLinked;
  final VoidCallback onLinkTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final bool isCompleted;
  final Color? currentColor; // 현재 활성 인터벌의 색상
  final String? currentColorLabel; // 현재 활성 인터벌의 라벨

  const IntervalCounterCard({
    super.key,
    required this.label,
    required this.intervalRows,
    required this.currentCount,
    required this.totalCount,
    required this.startRow,
    required this.isLinked,
    required this.onLinkTap,
    this.onEdit,
    this.onDelete,
    this.backgroundColor,
    this.isCompleted = false,
    this.currentColor,
    this.currentColorLabel,
  });

  @override
  Widget build(BuildContext context) {
    final progressRatio = totalCount > 0 ? currentCount / totalCount : 0.0;
    final l10n = AppLocalizations.of(context)!;

    // 하단 info text: "시작행~종료행" or "시작행~"
    final endRow = totalCount > 0
        ? startRow + (intervalRows * totalCount) - 1
        : null;
    final infoText = endRow != null
        ? '$startRow~$endRow${l10n.row}'
        : l10n.fromRow(startRow);

    return BaseCounterCard(
      label: label,
      progress: progressRatio,
      backgroundColor: backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.everyNRows(intervalRows),
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 4),
          if (currentColor != null) ...[
            // 컬러칩 + 라벨 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 0.5,
                    ),
                  ),
                ),
                if (currentColorLabel != null && currentColorLabel!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      currentColorLabel!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ] else ...[
            // 컬러칩 없는 경우: 기존 숫자 표시
            Text(
              '$currentCount/$totalCount${isCompleted ? ' ✓' : ''}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.07,
                height: 1.33,
              ),
            ),
          ],
        ],
      ),
      bottomToolbar: CounterCardToolbar(
        infoText: infoText,
        showLinkButton: true,
        isLinked: isLinked,
        onLinkTap: onLinkTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}