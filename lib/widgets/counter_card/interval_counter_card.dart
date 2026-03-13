import 'package:flutter/material.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final progressRatio = totalCount > 0 ? currentCount / totalCount : 0.0;

    return BaseCounterCard(
      label: label,
      progress: progressRatio,
      backgroundColor: backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${intervalRows}행마다',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 2),
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