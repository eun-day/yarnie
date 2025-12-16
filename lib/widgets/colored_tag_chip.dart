import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/tag_color_preset.dart';

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
    final tagColorValue = tag.color;
    final tagColor = Color(tagColorValue);
    
    // Use preset text color if available, otherwise calculate based on brightness
    final presetTextColor = TagColorPreset.getTextColor(tagColorValue);
    final textColor = presetTextColor ?? (ThemeData.estimateBrightnessForColor(tagColor) == Brightness.dark
            ? Colors.white
            : Colors.black87);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 2.5),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag.name,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
          ),
          if (showDeleteButton) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(
                Icons.close,
                size: 12,
                color: textColor,
              ),
            )
          ]
        ],
      ),
    );
  }
}

