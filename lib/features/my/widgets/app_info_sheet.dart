import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/theme/text_styles.dart';

class AppInfoSheet extends StatelessWidget {
  const AppInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // as per Figma <div className="rounded-tl-[10px] rounded-tr-[10px]">
        border: Border(top: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1), width: 0.5)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              const SizedBox(height: 16),
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 24),

              // Title Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '앱 정보',
                    style: AppTextStyles.titleH2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // App Logo & Version
              Text(
                '🦎',
                style: TextStyle(fontSize: 60, height: 1.0),
              ),
              const SizedBox(height: 16),
              Text(
                'Yarnie',
                style: AppTextStyles.titleH1.copyWith(
                  fontWeight: FontWeight.w400, // or font-normal in figma text-[24px]
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '버전 1.0.0',
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '© 2026 Yarnie. All rights reserved.',
                style: AppTextStyles.bodyM.copyWith(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Card: 카멜레온 이야기
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(236, 236, 240, 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0.1),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '카멜레온 이야기',
                        style: AppTextStyles.bodyM.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '우리의 카멜레온 친구는 색을 변환하는 능력이 없어요. 하지만 뜨개질로 다양한 색과 무늬의 옷을 만들어 입으며 매일 새로운 모습으로 행복하게 살아가고 있답니다. 여러분도 카멜레온처럼 뜨개질과 함께 즐거운 시간을 보내세요!',
                        style: AppTextStyles.bodyM.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.6, // 22.75 / 14
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildButton(
                      text: '피드백 보내기',
                      iconPath: 'assets/icons/feedback.svg',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _buildButton(
                      text: '개인정보 처리방침',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _buildButton(
                      text: '서비스 이용약관',
                      onTap: () {},
                    ),
                    const SizedBox(height: 8),
                    _buildButton(
                      text: '오픈소스 라이선스',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    String? iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(iconPath, width: 16, height: 16),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: AppTextStyles.bodyM.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
