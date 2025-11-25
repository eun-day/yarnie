import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';

class ColoredTagChip extends StatelessWidget {
  const ColoredTagChip({
    super.key,
    required this.tag,
    this.onDeleted,
    this.showDeleteButton = false,
  });

  final Tag tag;
  final VoidCallback? onDeleted;
  final bool showDeleteButton;

  @override
  Widget build(BuildContext context) {
    final tagColor = Color(tag.color);
    final textColor = ThemeData.estimateBrightnessForColor(tagColor) == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      padding: showDeleteButton
          ? const EdgeInsets.only(left: 12.0, top: 5.0, bottom: 5.0, right: 5.0)
          : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag.name,
            style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          if (showDeleteButton) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDeleted,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: textColor,
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
