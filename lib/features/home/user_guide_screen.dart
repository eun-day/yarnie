import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yarnie/theme/text_styles.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _Header(onBack: () => Navigator.pop(context)),
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _WelcomeCard(),
                    const SizedBox(height: 24),
                    const _TabsSection(),
                    const SizedBox(height: 24),
                    const _CreateProjectSection(),
                    const SizedBox(height: 24),
                    const _TagFilteringSection(),
                    const SizedBox(height: 24),
                    const _PartSection(),
                    const SizedBox(height: 24),
                    const _CounterSystemSection(),
                    const SizedBox(height: 24),
                    const _LinkedSection(),
                    const SizedBox(height: 24),
                    const _TipsSection(),
                    const SizedBox(height: 24),
                    _CtaCard(onClose: () => Navigator.pop(context)),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
      ),
      height: 80,
      child: Row(
        children: [
          // 뒤로가기 버튼
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: onBack,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 타이틀 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.userGuide,
                  style: AppTextStyles.titleH2.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Yarnie와 함께하는 뜨개질 여정',
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Welcome Card
// ─────────────────────────────────────────────────────────────────────────────

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.6, -0.8),
          end: const Alignment(0.6, 0.8),
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 🦎 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('🦎', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 16),
          // 타이틀
          Text(
            AppLocalizations.of(context)!.welcome,
            style: AppTextStyles.titleH2.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // 설명
          Text(
            AppLocalizations.of(context)!.welcomeDesc,
            style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Tabs Section
// ─────────────────────────────────────────────────────────────────────────────

class _TabsSection extends StatelessWidget {
  const _TabsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.tabsConfigTitle),
        const SizedBox(height: 12),
        // 홈 탭
        _TabCard(
          icon: Icons.home_outlined,
          title: l10n.homeTab,
          description: l10n.homeTabDesc,
        ),
        const SizedBox(height: 12),
        // 프로젝트 탭
        _TabCard(
          icon: Icons.folder_outlined,
          title: l10n.projectsTab,
          description: l10n.projectsTabDesc,
        ),
        const SizedBox(height: 12),
        // 마이 탭
        _TabCard(
          icon: Icons.person_outline,
          title: l10n.myTab,
          description: l10n.myTabDesc,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tag Filtering Section
// ─────────────────────────────────────────────────────────────────────────────

class _TagFilteringSection extends StatelessWidget {
  const _TagFilteringSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _TipCard(
      emoji: '🏷️',
      title: l10n.tagFiltering,
      description: l10n.tagFilteringDesc,
      backgroundColor: const Color(0xFFF0FDF4).withValues(alpha: 0.5),
      borderColor: const Color(0xFFB9F8CF),
      titleColor: const Color(0xFF0D542B),
      descriptionColor: const Color(0xFF008236),
    );
  }
}

class _TabCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _TabCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 원형
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 24, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleH3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Create Project Section
// ─────────────────────────────────────────────────────────────────────────────

class _CreateProjectSection extends StatelessWidget {
  const _CreateProjectSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.createProjectTitle),
        const SizedBox(height: 12),
        // 설명 + 스텝 카드
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.createProjectDesc,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              // 스텝 1
              _StepRow(
                number: '1',
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(text: l10n.createProjectGuide1),
                      TextSpan(
                        text: l10n.createProjectGuide2,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: l10n.createProjectGuide3),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 스텝 2
              _StepRow(
                number: '2',
                child: Text(
                  l10n.createProjectGuide4,
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 스텝 3
              _StepRow(
                number: '3',
                child: Text(
                  l10n.createProjectGuide5,
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final String number;
  final Widget child;
  const _StepRow({required this.number, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Part Section
// ─────────────────────────────────────────────────────────────────────────────

class _PartSection extends StatelessWidget {
  const _PartSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.splitPartTitle),
        const SizedBox(height: 12),
        // 설명 + 예시 카드
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.splitPartDesc,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 36),
              // 예시 박스
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sweaterExample,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final part in [
                            '• ${l10n.frontPanel}',
                            '• ${l10n.backPanel}',
                            '• ${l10n.leftSleeve}',
                            '• ${l10n.rightSleeve}',
                            '• ${l10n.neckline}',
                          ])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                part,
                                style: AppTextStyles.bodyM.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Part 추가 방법 팁 (블루)
        _InfoCard(
          icon: Icons.info_outline,
          title: l10n.addPartMethod,
          description: l10n.addPartMethodDesc,
          highlight: l10n.newPart,
          descriptionSuffix: l10n.addPartMethodSuffix,
          backgroundColor: const Color(0xFFEFF6FF).withValues(alpha: 0.5),
          borderColor: const Color(0xFFBEDBFF),
          titleColor: const Color(0xFF1C398E),
          descriptionColor: const Color(0xFF1447E6),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Counter System Section
// ─────────────────────────────────────────────────────────────────────────────

class _CounterSystemSection extends StatelessWidget {
  const _CounterSystemSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.counterSystemTitle),
        const SizedBox(height: 12),

        // 카운터 소개 카드
        _SimpleCard(
          text: l10n.counterSystemDesc,
        ),
        const SizedBox(height: 12),

        // ── 메인 카운터 ──
        _subSectionTitle(context, l10n.mainCounterTitle),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/counter_main.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.mainCounterDesc,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: l10n.tip,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: l10n.mainCounterTip,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── 보조 카운터 ──
        _subSectionTitle(context, l10n.buddyCounterTitle),
        const SizedBox(height: 4),
        Text(
          l10n.buddyCounterDesc,
          style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),

        // 코 카운터
        _CounterDetailCard(
          svgPath: 'assets/icons/counter_stitch.svg',
          iconBgColor: const Color(0xFFF3E8FF),
          title: l10n.stitchCounterTitle,
          titleStyle: AppTextStyles.titleH3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          description: l10n.stitchCounterDesc,
          tipBox: _UseCaseBox(
            title: l10n.whenToUse,
            items: [
              l10n.stitchCounterUsage1,
              l10n.stitchCounterUsage2,
              l10n.stitchCounterUsage3,
            ],
            backgroundColor: const Color(0xFFFAF5FF).withValues(alpha: 0.5),
            borderColor: const Color(0xFFF3E8FF),
          ),
        ),
        const SizedBox(height: 12),

        // 섹션 카운터
        _CounterDetailCard(
          svgPath: 'assets/icons/counter_section.svg',
          iconBgColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          title: l10n.sectionCounterTitle,
          titleStyle: AppTextStyles.titleH3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          description: l10n.sectionCounterDesc,
          cardBackgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          cardBorderColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          tipBox: _LinkedInfoBox(
            title: l10n.mainCounterLink,
            description: l10n.mainCounterLinkDesc,
          ),
        ),
        const SizedBox(height: 16),

        // ── 섹션 카운터 5가지 유형 (왼쪽 보더) ──
        Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Color(0x4D637069), width: 1.5),
            ),
          ),
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sectionCounterTypes,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // 1. 범위 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_range.svg',
                iconBgColor: const Color(0xFFDCFCE7),
                title: l10n.rangeCounter,
                description: l10n.rangeCounterDesc,
                useCases: [
                  l10n.rangeCounterUsage1,
                  l10n.rangeCounterUsage2,
                  l10n.rangeCounterUsage3,
                ],
                example: l10n.rangeCounterExample,
                accentBgColor: const Color(0xFFF0FDF4).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFDCFCE7),
                dividerColor: const Color(0xFFB9F8CF),
              ),
              const SizedBox(height: 12),

              // 2. 반복 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_repeat.svg',
                iconBgColor: const Color(0xFFDBEAFE),
                title: l10n.repeatCounter,
                description: l10n.repeatCounterDesc,
                useCases: [
                  l10n.repeatCounterUsage1,
                  l10n.repeatCounterUsage2,
                  l10n.repeatCounterUsage3,
                ],
                example: l10n.repeatCounterExample,
                accentBgColor: const Color(0xFFEFF6FF).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFDBEAFE),
                dividerColor: const Color(0xFFBEDBFF),
              ),
              const SizedBox(height: 12),

              // 3. 인터벌 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_interval.svg',
                iconBgColor: const Color(0xFFFFEDD4),
                title: l10n.intervalCounter,
                description: l10n.intervalCounterDesc,
                useCases: [
                  l10n.intervalCounterUsage1,
                  l10n.intervalCounterUsage2,
                  l10n.intervalCounterUsage3,
                ],
                example: l10n.intervalCounterExample,
                accentBgColor: const Color(0xFFFFF7ED).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFFFEDD4),
                dividerColor: const Color(0xFFFFD6A7),
              ),
              const SizedBox(height: 12),

              // 4. 쉐이핑 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_shaping.svg',
                iconBgColor: const Color(0xFFFCE7F3),
                title: l10n.shapingCounter,
                description: l10n.shapingCounterDesc,
                useCases: [
                  l10n.shapingCounterUsage1,
                  l10n.shapingCounterUsage2,
                  l10n.shapingCounterUsage3,
                ],
                example: l10n.shapingCounterExample,
                accentBgColor: const Color(0xFFFDF2F8).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFFCE7F3),
                dividerColor: const Color(0xFFFCCEE8),
              ),
              const SizedBox(height: 12),

              // 5. 길이 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_length.svg',
                iconBgColor: const Color(0xFFFEF9C2),
                title: l10n.lengthCounter,
                description: l10n.lengthCounterDesc,
                useCases: [
                  l10n.lengthCounterUsage1,
                  l10n.lengthCounterUsage2,
                  l10n.lengthCounterUsage3,
                ],
                example: l10n.lengthCounterExample,
                accentBgColor: const Color(0xFFFEFCE8).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFFEF9C2),
                dividerColor: const Color(0xFFFFF085),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Linked Section (섹션 카운터 연동 기능)
// ─────────────────────────────────────────────────────────────────────────────

class _LinkedSection extends StatelessWidget {
  const _LinkedSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.sectionCounterLinkTitle),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sectionCounterLinkDesc,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 36),
              // 팁 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: l10n.tipLinkButton,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '🔗',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: l10n.tipLinkButtonDesc,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 참고 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFE9D4FF),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  l10n.stitchCounterNote,
                  style: AppTextStyles.bodyM.copyWith(
                    color: const Color(0xFF59168B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. Tips Section (✨ 활용 팁)
// ─────────────────────────────────────────────────────────────────────────────

class _TipsSection extends StatelessWidget {
  const _TipsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l10n.proTips),
        const SizedBox(height: 12),
        _ActivityTipCard(
          title: l10n.useMemo,
          description: l10n.useMemoDesc,
        ),
        const SizedBox(height: 12),
        _ActivityTipCard(
          title: l10n.useTags,
          description: l10n.useTagsDesc,
        ),
        const SizedBox(height: 12),
        _ActivityTipCard(
          title: l10n.takePhotos,
          description: l10n.takePhotosDesc,
        ),
      ],
    );
  }
}

class _ActivityTipCard extends StatelessWidget {
  final String title;
  final String description;
  const _ActivityTipCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            description,
            style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. CTA Card
// ─────────────────────────────────────────────────────────────────────────────

class _CtaCard extends StatelessWidget {
  final VoidCallback onClose;
  const _CtaCard({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.7, -0.7),
          end: const Alignment(0.7, 0.7),
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          const Text('🦎', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 36),
          Text(
            l10n.readyToStart,
            style: AppTextStyles.titleH3.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.startJourney,
            style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.guideAgain,
            style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          // 닫기 버튼
          SizedBox(
            width: double.infinity,
            height: 36,
            child: FilledButton(
              onPressed: onClose,
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15,
                ),
              ),
              child: Text(l10n.close),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────────────────────────────────────────

Widget _sectionTitle(BuildContext context, String text) {
  return Text(
    text,
    style: AppTextStyles.titleH3.copyWith(color: Theme.of(context).colorScheme.onSurface),
  );
}

Widget _subSectionTitle(BuildContext context, String text) {
  return Text(
    text,
    style: AppTextStyles.titleH3.copyWith(color: Theme.of(context).colorScheme.onSurface),
  );
}

class _SimpleCard extends StatelessWidget {
  final String text;
  const _SimpleCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color descriptionColor;

  const _TipCard({
    required this.emoji,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyM.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyM.copyWith(color: descriptionColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String highlight;
  final String descriptionSuffix;
  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color descriptionColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlight,
    required this.descriptionSuffix,
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: descriptionColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyM.copyWith(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: descriptionColor,
                    ),
                    children: [
                      TextSpan(text: '$description '),
                      TextSpan(
                        text: highlight,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: descriptionSuffix),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UseCaseBox extends StatelessWidget {
  final String title;
  final List<String> items;
  final Color backgroundColor;
  final Color borderColor;

  const _UseCaseBox({
    required this.title,
    required this.items,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: AppTextStyles.bodyM.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LinkedInfoBox extends StatelessWidget {
  final String title;
  final String description;
  const _LinkedInfoBox({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _CounterDetailCard extends StatelessWidget {
  final String svgPath;
  final Color iconBgColor;
  final String title;
  final TextStyle titleStyle;
  final String description;
  final Widget tipBox;
  final Color? cardBackgroundColor;
  final Color? cardBorderColor;

  const _CounterDetailCard({
    required this.svgPath,
    required this.iconBgColor,
    required this.title,
    required this.titleStyle,
    required this.description,
    required this.tipBox,
    this.cardBackgroundColor,
    this.cardBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cardBorderColor ?? Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(svgPath, width: 20, height: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          tipBox,
        ],
      ),
    );
  }
}

class _SectionCounterTypeCard extends StatelessWidget {
  final String svgPath;
  final Color iconBgColor;
  final String title;
  final String description;
  final List<String> useCases;
  final String example;
  final Color accentBgColor;
  final Color accentBorderColor;
  final Color dividerColor;

  const _SectionCounterTypeCard({
    required this.svgPath,
    required this.iconBgColor,
    required this.title,
    required this.description,
    required this.useCases,
    required this.example,
    required this.accentBgColor,
    required this.accentBorderColor,
    required this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 + 타이틀 + 설명
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(svgPath, width: 20, height: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleH3.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          // 사용 사례 + 예시 박스
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentBgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accentBorderColor, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '언제 사용하나요?',
                  style: AppTextStyles.bodyM.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in useCases)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      item,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                // 구분선
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: dividerColor,
                ),
                const SizedBox(height: 12),
                // 예시
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                      text: AppLocalizations.of(context)!.examplePrefix,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(text: example),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
