import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/l10n/app_localizations.dart';

class AddBuddyCounterMenu extends StatelessWidget {
  final VoidCallback? onStitchSelected;
  final VoidCallback? onRangeSelected;
  final VoidCallback? onRepeatSelected;
  final VoidCallback? onIntervalSelected;
  final VoidCallback? onShapingSelected;
  final VoidCallback? onLengthSelected;

  const AddBuddyCounterMenu({
    super.key,
    this.onStitchSelected,
    this.onRangeSelected,
    this.onRepeatSelected,
    this.onIntervalSelected,
    this.onShapingSelected,
    this.onLengthSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 220, 
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text(
                l10n.selectCounterType,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.15,
                ),
              ),
            ),
            Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.outline),
            
            // Stitch Counter
            InkWell(
              onTap: onStitchSelected,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/counter_stitch.svg', width: 14, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.stitchCounter,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.independentCounter,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.outline),

            // Section Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                l10n.sectionCounter,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Items
            _buildItem(context, 'assets/icons/counter_range.svg', l10n.range, onRangeSelected),
            _buildItem(context, 'assets/icons/counter_repeat.svg', l10n.repeat, onRepeatSelected),
            _buildItem(context, 'assets/icons/counter_interval.svg', l10n.interval, onIntervalSelected),
            _buildItem(context, 'assets/icons/counter_shaping.svg', l10n.shaping, onShapingSelected),
            _buildItem(context, 'assets/icons/counter_length.svg', l10n.length, onLengthSelected),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String iconPath, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
             Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: SvgPicture.asset(iconPath, width: 14, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn)),
             ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
