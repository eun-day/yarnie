import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/theme/text_styles.dart';

class SettingItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final bool isSwitch;
  final bool initialSwitchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.isSwitch = false,
    this.initialSwitchValue = false,
    this.onSwitchChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSwitch ? null : onTap,
      child: Container(
        height: 76.5,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFECECF0),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: (isSwitch && initialSwitchValue) 
                    ? null 
                    : const ColorFilter.mode(
                        Color(0xFF717182),
                        BlendMode.srcIn,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleH3.copyWith(height: 1.0),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyM.copyWith(
                      color: const Color(0xFF717182),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            if (isSwitch)
              CupertinoSwitch(
                value: initialSwitchValue,
                onChanged: onSwitchChanged,
                activeColor: const Color(0xFF6FB96F),
              )
            else
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFCBCED4),
              ),
          ],
        ),
      ),
    );
  }
}
