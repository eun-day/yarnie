import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/widgets/counter_card/base_counter_card.dart';

class LengthCounterCard extends StatelessWidget {
  final String label;
  final double remainingLength;
  final String unit; // e.g. cm
  final int startRow;
  final int endRow;
  final double currentProgress; // 0.0 ~ 1.0
  final bool isLinked;
  final VoidCallback onLinkTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color? backgroundColor;
  final bool isCompleted;

  const LengthCounterCard({
    super.key,
    required this.label,
    required this.remainingLength,
    this.unit = 'cm',
    required this.startRow,
    required this.endRow,
    required this.currentProgress,
    required this.isLinked,
    required this.onLinkTap,
    this.onEdit,
    this.onDelete,
    this.backgroundColor,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCounterCard(
      label: label,
      progress: currentProgress,
      backgroundColor: backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              SvgPicture.asset(
                'assets/icons/counter_length.svg',
                width: 14,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn),
              ),
              const SizedBox(width: 4),
              Text(
                isCompleted ? AppLocalizations.of(context)!.achieved : AppLocalizations.of(context)!.remainingLength,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: -0.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                remainingLength.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.07,
                  height: 1.33,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: -0.15,
                ),
              ),
            ],
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