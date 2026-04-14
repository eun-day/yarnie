import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/counter_card/base_counter_card.dart';

class ShapingCounterCard extends StatelessWidget {
  final String label;
  final int amount; // e.g. -2 (코 줄임)
  final int nextActionRow; // e.g. 다음: 22행
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
  final bool isActionRow; // 현재 행이 코 줄임/늘림을 실행해야 하는 행인지 여부

  const ShapingCounterCard({
    super.key,
    required this.label,
    required this.amount,
    required this.nextActionRow,
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
    this.isActionRow = false,
  });

  @override
  Widget build(BuildContext context) {
    final progressRatio = totalCount > 0 ? currentCount / totalCount : 0.0;
    
    final l10n = AppLocalizations.of(context)!;
    // Determine icon and text based on amount
    final isIncrease = amount > 0;
    final amountAbs = amount.abs();
    final actionText = isIncrease ? l10n.shapingIncrease(amountAbs) : l10n.shapingDecrease(amountAbs);
    final color = isIncrease ? const Color(0xFF6FB96F) : const Color(0xFFF08C1F); // Green for +, Orange for -

    return BaseCounterCard(
      label: label,
      progress: progressRatio,
      backgroundColor: backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header Row (Icon + Text)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon placeholder if asset missing, or SvgPicture
              Icon(
                Icons.show_chart, // Fallback icon
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                actionText,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: -0.15,
                ),
              ),
            ],
          ),
          
          // Next Action Row
          if (isCompleted)
            Text(
              '${l10n.complete} ✓',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.44,
                height: 1.4,
              ),
            )
          else if (isActionRow)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                l10n.shapingActionNow,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: -0.3,
                ),
              ),
            )
          else
            Text(
              l10n.shapingActionNotYet(nextActionRow), 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.44,
                height: 1.4,
              ),
            ),
          
          // Sub Info
          Text(
            '${intervalRows}${l10n.stitch} · $currentCount/${totalCount}회',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: -0.15,
            ),
          ),
        ],
      ),
      bottomToolbar: CounterCardToolbar(
        infoText: l10n.fromRow(startRow),
        showLinkButton: true,
        isLinked: isLinked,
        onLinkTap: onLinkTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}