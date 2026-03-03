import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final progressRatio = totalCount > 0 ? currentCount / totalCount : 0.0;
    
    // Determine icon and text based on amount
    final isIncrease = amount > 0;
    final typeText = isIncrease ? '코 늘림' : '코 줄임';
    final amountText = isIncrease ? '+$amount코' : '$amount코';
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
                '$typeText $amountText',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF717182),
                  letterSpacing: -0.15,
                ),
              ),
            ],
          ),
          
          // Next Action Row
          Text(
            isCompleted ? '완료 ✓' : '다음:${nextActionRow}행',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0A0A0A),
              letterSpacing: -0.44,
              height: 1.4,
            ),
          ),
          
          // Sub Info
          Text(
            '${intervalRows}행마다 · $currentCount/${totalCount}회',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF717182),
              letterSpacing: -0.15,
            ),
          ),
        ],
      ),
      bottomToolbar: CounterCardToolbar(
        infoText: '${startRow}행부터',
        showLinkButton: true,
        isLinked: isLinked,
        onLinkTap: onLinkTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}