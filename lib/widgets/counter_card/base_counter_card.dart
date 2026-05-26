import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/widgets/counter_card/counter_settings_button.dart';
import 'package:yarnie/theme/app_theme.dart';

/// 공통으로 사용할 카드 베이스 위젯
class BaseCounterCard extends StatelessWidget {
  final String label;
  final Widget content;
  final Widget bottomToolbar;
  final double? progress; // 0.0 ~ 1.0 (null이면 프로그레스 바 숨김)
  final Color? backgroundColor;

  const BaseCounterCard({
    super.key,
    required this.label,
    required this.content,
    required this.bottomToolbar,
    this.progress,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.64),
      ),
      child: Column(
        children: [
          // 1. Label Area (Top)
          Padding(
            padding: EdgeInsets.only(top: 13, left: 13, right: 13),
            child: SizedBox(
              height: 20,
              width: double.infinity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final textStyle = TextStyle(
                    fontSize: 14,
                    color: context.counterLabelColor,
                    letterSpacing: -0.15,
                    fontWeight: FontWeight.w400,
                  );
                  final textSpan = TextSpan(text: label, style: textStyle);
                  final textPainter = TextPainter(
                    text: textSpan,
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                    textScaler: MediaQuery.textScalerOf(context),
                    locale: Localizations.localeOf(context), // 디바이스 언어(일본어 등)에 적합한 폰트 메트릭을 적용
                  )..layout(maxWidth: double.infinity);
                  // 폰트 자간 및 글리프 미세 오차(Tolerance)를 잡아내기 위해 4.0픽셀의 안전 마진을 적용합니다.
                  final isOverflowing = textPainter.width > (constraints.maxWidth - 4.0);

                  final textWidget = Text(
                    label,
                    style: textStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );

                  if (!isOverflowing) return textWidget;

                  return Tooltip(
                    message: label,
                    triggerMode: TooltipTriggerMode.tap,
                    preferBelow: false,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      letterSpacing: -0.15,
                    ),
                    child: textWidget,
                  );
                },
              ),
            ),
          ),

          // 2. Main Content Area (Center)
          Expanded(
            child: Center(child: content),
          ),

          // 3. Bottom Toolbar Area
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: SizedBox(
              height: 32, // Toolbar height based on design
              child: bottomToolbar,
            ),
          ),
          
          // 4. Progress Bar Area
          if (progress != null) ...[
            const SizedBox(height: 8), // Spacing before progress
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.antiAlias,
              child: FractionallySizedBox(
                widthFactor: progress!.clamp(0.0, 1.0),
                child: Container(color: const Color(0xFF6FB96F)),
              ),
            ),
          ] else ...[
             const SizedBox(height: 8), // Maintain bottom spacing if no progress
          ],
        ],
      ),
    );
  }
}

/// 공통 툴바 위젯 (좌측 정보 텍스트 + 우측 링크/설정 버튼)
class CounterCardToolbar extends StatelessWidget {
  final String? infoText;
  final bool showLinkButton;
  final bool isLinked;
  final VoidCallback? onLinkTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CounterCardToolbar({
    super.key,
    this.infoText,
    this.showLinkButton = false,
    this.isLinked = true,
    this.onLinkTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Info Text
        Expanded(
          child: infoText != null
              ? Text(
                  infoText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: -0.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : const SizedBox.shrink(),
        ),
        
        // Right Buttons
        Row(
          children: [
            if (showLinkButton) ...[
              GestureDetector(
                onTap: onLinkTap,
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    isLinked 
                        ? 'assets/icons/counter_link_active.svg'
                        : 'assets/icons/counter_link_inactive.svg',
                    width: 28,
                  ),
                ),
              ),
              const SizedBox(width: 2),
            ],
            CounterSettingsButton(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}
