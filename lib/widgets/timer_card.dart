import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:yarnie/widget/labelpill.dart';

/// 카드 위젯: 상단 중앙 라벨 + 중앙 큰 시간
class TimerCard extends StatelessWidget {
  const TimerCard({
    super.key,
    required this.timeText,
    required this.labelText,
    required this.onTapLabel,
  });

  final String timeText;
  final String labelText;
  final VoidCallback onTapLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color.fromRGBO(
            (theme.colorScheme.outlineVariant.r * 255.0).round() & 0xff,
            (theme.colorScheme.outlineVariant.g * 255.0).round() & 0xff,
            (theme.colorScheme.outlineVariant.b * 255.0).round() & 0xff,
            0.6,
          ),
        ),
        boxShadow: kElevationToShadow[1],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 라벨 (상단 중앙)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: LabelPill(text: labelText, onTap: onTapLabel, isIOS: isIOS),
          ),
          // 큰 시간
          Expanded(
            child: Center(
              child: Text(
                timeText,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [
                    FontFeature.tabularFigures(),
                  ], // ← 숫자 폭 고정
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
