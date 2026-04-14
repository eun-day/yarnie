import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/counter_card/base_counter_card.dart';

class RangeCounterCard extends StatelessWidget {
  final String label;
  final int currentMainValue;
  final int startRow;
  final int endRow;
  final int totalRows;
  final bool isLinked;
  final VoidCallback onLinkTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final bool isCompleted;

  const RangeCounterCard({
    super.key,
    required this.label,
    required this.currentMainValue,
    required this.startRow,
    required this.endRow,
    required this.totalRows,
    required this.isLinked,
    required this.onLinkTap,
    this.onEdit,
    this.onDelete,
    this.backgroundColor,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress (clamp 0..totalRows)
    // Range: startRow ~ endRow
    // Progress = completed rows (not including current row)
    // e.g. startRow=1, current=1 → 0 completed (0%), current=2 → 1 completed (10%)
    final completedRows = (currentMainValue - startRow).clamp(0, totalRows);
    final progressRatio = totalRows > 0 ? completedRows / totalRows : 0.0;
    
    // Display = current active row in this range (1-based index)
    final displayValue = (currentMainValue - startRow + 1).clamp(0, totalRows);

    return BaseCounterCard(
      label: label,
      progress: progressRatio,
      backgroundColor: backgroundColor,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '$displayValue',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.37,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '/ $totalRows${AppLocalizations.of(context)!.row}${isCompleted ? ' ✓' : ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: -0.15,
            ),
          ),
        ],
      ),
      bottomToolbar: CounterCardToolbar(
        infoText: '$startRow~$endRow${AppLocalizations.of(context)!.row}',
        showLinkButton: true,
        isLinked: isLinked,
        onLinkTap: onLinkTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}