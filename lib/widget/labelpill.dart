import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LabelPill extends StatelessWidget {
  const LabelPill({
    required this.text,
    required this.onTap,
    required this.isIOS,
  });

  final String text;
  final VoidCallback onTap;
  final bool isIOS;

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        borderRadius: BorderRadius.circular(20),
        color: CupertinoColors.systemGrey6,
        onPressed: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 26), // 칩 높이 느낌
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(CupertinoIcons.chevron_down,
                  size: 16, color: CupertinoColors.black),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
              Theme.of(context).colorScheme.surface,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.expand_more, size: 18),
            ],
          ),
        ),
      );
    }
  }
}