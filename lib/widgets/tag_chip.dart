import 'package:flutter/material.dart';

/// 재사용 가능한 태그 칩 위젯
class TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCloseButton;

  const TagChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 12,
              color: isSelected ? Theme.of(context).colorScheme.surface : primary,
            ),
          ),
          if (isSelected && showCloseButton) ...[
            const SizedBox(width: 4),
            Icon(Icons.close, size: 14, color: Theme.of(context).colorScheme.surface),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      showCheckmark: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: primary,
      side: BorderSide(color: primary.withOpacity(0.3), width: 1),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      labelPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
