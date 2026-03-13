import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    // If current < startRow: 0
    // If current > endRow: totalRows
    final progressValue = (currentMainValue - startRow + 1).clamp(0, totalRows);
    final progressRatio = totalRows > 0 ? progressValue / totalRows : 0.0;

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
            '$progressValue',
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
            '/ $totalRows${AppLocalizations.of(context)!.stitch}${isCompleted ? ' ✓' : ''}',
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
        infoText: '$startRow~$endRow${AppLocalizations.of(context)!.stitch}',
        showLinkButton: true,
        isLinked: isLinked,
        onLinkTap: onLinkTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}