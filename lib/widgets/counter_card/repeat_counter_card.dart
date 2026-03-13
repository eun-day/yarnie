import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yarnie/widgets/counter_card/base_counter_card.dart';

class RepeatCounterCard extends StatelessWidget {
  final String label;
  final int currentRepeatCount; // 0-based index or count
  final int maxRepeatCount;
  final int currentRowInPattern; // 1 ~ rowsPerRepeat
  final int rowsPerRepeat;
  final int startRow;
  final bool isLinked;
  final VoidCallback onLinkTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final bool isCompleted;

  const RepeatCounterCard({
    super.key,
    required this.label,
    required this.currentRepeatCount,
    required this.maxRepeatCount,
    required this.currentRowInPattern,
    required this.rowsPerRepeat,
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
    // Total progress across all repeats? Or just current repeat?
    // Design shows progress bar. Usually represents total completion.
    // Let's assume linear progress: (currentRepeat * rowsPerRepeat + currentRow) / (maxRepeat * rowsPerRepeat)
    final totalRows = maxRepeatCount * rowsPerRepeat;
    final currentTotal = (currentRepeatCount * rowsPerRepeat) + currentRowInPattern;
    final progressRatio = totalRows > 0 ? currentTotal / totalRows : 0.0;

    return BaseCounterCard(
      label: label,
      progress: progressRatio,
      backgroundColor: backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${currentRepeatCount + 1}', // Display 1-based for user? Or 0? Design shows '0 / 5회' -> maybe completed count?
                // If '0 / 5회' means 0 completed, then we use currentRepeatCount.
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
                '/ ${maxRepeatCount}회${isCompleted ? ' ✓' : ''}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: -0.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            AppLocalizations.of(context)!.patternRows(currentRowInPattern, rowsPerRepeat),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: -0.15,
            ),
          ),
        ],
      ),
      bottomToolbar: CounterCardToolbar(
        infoText: AppLocalizations.of(context)!.fromRow(startRow),
        showLinkButton: true,
        isLinked: isLinked,
        onLinkTap: onLinkTap,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}