import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/new_project_screen.dart';
import 'package:yarnie/project_detail_screen.dart';
import 'package:yarnie/features/home/user_guide_screen.dart';
import 'package:yarnie/theme/text_styles.dart';
import 'package:yarnie/widgets/common_banner_ad.dart';
import 'package:yarnie/widgets/ad_visibility_wrapper.dart';
import 'package:yarnie/core/providers/premium_provider.dart';
import 'package:yarnie/core/premium/premium_policy.dart';

const _kGuideCardDismissedKey = 'home_guide_card_dismissed';

/// 뜨개질 팁 데이터
List<({String emoji, String text})> _getKnittingTips(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    (emoji: '🧶', text: l10n.knittingTip1),
    (emoji: '📏', text: l10n.knittingTip2),
    (emoji: '✨', text: l10n.knittingTip3),
    (emoji: '🎨', text: l10n.knittingTip4),
    (emoji: '🌡️', text: l10n.knittingTip5),
    (emoji: '📱', text: l10n.knittingTip6),
    (emoji: '🎯', text: l10n.knittingTip7),
    (emoji: '🌟', text: l10n.knittingTip8),
    (emoji: '📐', text: l10n.knittingTip9),
    (emoji: '💚', text: l10n.knittingTip10),
  ];
}

class HomeRoot extends ConsumerStatefulWidget {
  final ScrollController? controller;
  final String title;

  const HomeRoot({super.key, this.controller, this.title = 'Yarnie'});

  @override
  ConsumerState<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends ConsumerState<HomeRoot> {
  bool _showGuideCard = false; // SharedPreferences 로드 전까지 숨김
  int _currentTipPage = 0;
  late final PageController _tipPageController;

  // 프로젝트 목록 스트림
  StreamSubscription<void>? _projectsSub;
  List<Project> _projects = [];
  Project? _recentProject;
  DateTime? _recentActivity;

  @override
  void initState() {
    super.initState();
    _tipPageController = PageController(viewportFraction: 0.92);
    _loadGuideCardVisibility();
    _projectsSub = appDb.watchProjectActivities().listen((_) async {
      if (!mounted) return;

      final projects = await appDb.watchAll().first;
      if (!mounted) return;

      if (projects.isEmpty) {
        setState(() {
          _projects = projects;
          _recentProject = null;
          _recentActivity = null;
        });
        return;
      }

      Project? latestProj;
      DateTime? latestTime;

      // 각 프로젝트의 마지막 활동 시간 조회
      for (final p in projects) {
        final activity =
            await appDb.getProjectLastActivity(p.id) ?? p.createdAt;
        if (latestTime == null || activity.isAfter(latestTime)) {
          latestTime = activity;
          latestProj = p;
        }
      }

      if (mounted) {
        setState(() {
          _projects = projects;
          _recentProject = latestProj;
          _recentActivity = latestTime;
        });
      }
    });
  }

  Future<void> _loadGuideCardVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getBool(_kGuideCardDismissedKey) ?? false;
    if (mounted && !dismissed) {
      setState(() => _showGuideCard = true);
    }
  }

  Future<void> _dismissGuideCard() async {
    setState(() => _showGuideCard = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kGuideCardDismissedKey, true);
  }

  @override
  void dispose() {
    _tipPageController.dispose();
    _projectsSub?.cancel();
    super.dispose();
  }

  bool get _isActiveUser => _projects.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ref.watch(premiumProvider)
          ? null
          : AdVisibilityWrapper(
              child: CommonBannerAdWidget(
                adUnitId: Platform.isAndroid
                    ? 'ca-app-pub-3940256099942544/6300978111'
                    : 'ca-app-pub-3940256099942544/2934735716',
              ),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.controller,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 33),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeMessage(isActiveUser: _isActiveUser),
              const SizedBox(height: 24),
              if (_isActiveUser &&
                  _recentProject != null &&
                  _recentActivity != null)
                _RecentWorkProject(
                  project: _recentProject!,
                  lastActivity: _recentActivity!,
                  onContinue: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProjectDetailScreen(projectId: _recentProject!.id),
                      ),
                    );
                  },
                )
              else
                _NewProjectCard(
                  projectCount: _projects.length,
                  onTap: () {
                    final isPremium = ref.read(premiumProvider);
                    if (PremiumPolicy.canCreateProject(_projects.length, isPremium)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NewProjectScreen(),
                        ),
                      );
                    } else {
                      PremiumUIHelper.showUpsellSnackbar(context);
                    }
                  },
                ),
              const SizedBox(height: 16),
              if (_showGuideCard)
                _UserGuideCard(
                  onClose: _dismissGuideCard,
                  onGuide: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserGuideScreen(),
                      ),
                    );
                  },
                ),
              if (_showGuideCard) const SizedBox(height: 16),
              _KnittingTipSection(
                pageController: _tipPageController,
                currentPage: _currentTipPage,
                onPageChanged: (page) => setState(() => _currentTipPage = page),
              ),
              const SizedBox(height: 16),
              const _CheeringMessage(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. WelcomeMessage
// ─────────────────────────────────────────────────────────────────────────────

class _WelcomeMessage extends StatelessWidget {
  final bool isActiveUser;
  const _WelcomeMessage({this.isActiveUser = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isActiveUser ? l10n.welcomeUser : l10n.helloUser,
          style: AppTextStyles.titleH1.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          isActiveUser ? l10n.enjoyKnitting : l10n.startKnitting,
          style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2a. NewProjectCard (신규 사용자)
// ─────────────────────────────────────────────────────────────────────────────

class _NewProjectCard extends ConsumerWidget {
  final int projectCount;
  final VoidCallback onTap;
  const _NewProjectCard({required this.projectCount, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);
    final isLocked = !PremiumPolicy.canCreateProject(projectCount, isPremium);
    final buttonStyle = PremiumUIHelper.getButtonStyle(
      isLocked: isLocked,
      defaultIcon: Icons.bolt,
      defaultBackgroundColor: Theme.of(context).colorScheme.primary,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // 🦎 아이콘 in 원형 컨테이너
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('🦎', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 16),
          // 타이틀
          Text(
            AppLocalizations.of(context)!.startFirstProject,
            style: AppTextStyles.titleH2.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 설명 텍스트
          Text(
            AppLocalizations.of(context)!.startJourneyWithChameleon,
            style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // CTA 버튼
          SizedBox(
            width: double.infinity,
            height: 36,
            child: FilledButton.icon(
              onPressed: onTap,
              icon: Icon(buttonStyle.$1, size: 16),
              label: Text(
                AppLocalizations.of(context)!.createNewProject,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: buttonStyle.$2,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2b. RecentWorkProject (활성 사용자)
// ─────────────────────────────────────────────────────────────────────────────

class _RecentWorkProject extends StatefulWidget {
  final Project project;
  final DateTime lastActivity;
  final VoidCallback onContinue;

  const _RecentWorkProject({
    required this.project,
    required this.lastActivity,
    required this.onContinue,
  });

  @override
  State<_RecentWorkProject> createState() => _RecentWorkProjectState();
}

class _RecentWorkProjectState extends State<_RecentWorkProject> {
  String? _currentPartName;

  @override
  void initState() {
    super.initState();
    _loadPartName();
  }

  @override
  void didUpdateWidget(_RecentWorkProject oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.currentPartId != widget.project.currentPartId ||
        oldWidget.project.id != widget.project.id) {
      _loadPartName();
    }
  }

  Future<void> _loadPartName() async {
    final partId = widget.project.currentPartId;
    if (partId != null) {
      final part = await appDb.getPart(partId);
      if (mounted && part != null) {
        setState(() => _currentPartName = part.name);
      }
    } else {
      if (mounted) setState(() => _currentPartName = null);
    }
  }

  String _timeAgo(BuildContext context, DateTime dateTime) {
    final now = DateTime.now().toUtc();
    final diff = now.difference(dateTime);
    final l10n = AppLocalizations.of(context)!;

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inMinutes < 60) {
      return l10n.minutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return l10n.hoursAgo(diff.inHours);
    }
    if (diff.inDays < 7) {
      return l10n.daysAgo(diff.inDays);
    }
    if (diff.inDays < 30) {
      return l10n.weeksAgo(diff.inDays ~/ 7);
    }
    return l10n.monthsAgo(diff.inDays ~/ 30);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final lastTime = widget.lastActivity;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentProjects,
          style: AppTextStyles.titleH3.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              // 프로젝트 이미지
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B9D).withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text('🧶', style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(width: 16),
              // 프로젝트 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 프로젝트명
                    Text(
                      project.name,
                      style: AppTextStyles.titleH3.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 현재 Part
                    if (_currentPartName != null)
                      Text(
                        _currentPartName!,
                        style: AppTextStyles.bodyM.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    // 상대 시간
                    Text(
                      _timeAgo(context, lastTime),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 이어하기 버튼
              SizedBox(
                height: 36,
                child: FilledButton(
                  onPressed: widget.onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.15,
                    ),
                  ),
                  child: Text(l10n.continueWorking),
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
// 3. UserGuideCard
// ─────────────────────────────────────────────────────────────────────────────

class _UserGuideCard extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onGuide;
  const _UserGuideCard({required this.onClose, required this.onGuide});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBEDBFF), width: 0.5),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 파란 원형 아이콘
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDBEAFE),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.info_outline,
                    size: 24,
                    color: Color(0xFF1447E6),
                  ),
                ),
                const SizedBox(width: 16),
                // 텍스트 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        l10n.firstTimeUsing,
                        style: AppTextStyles.titleH3.copyWith(
                          color: const Color(0xFF1C398E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.yarnieBriefDesc,
                        style: AppTextStyles.bodyM.copyWith(
                          color: const Color(0xFF1447E6),
                          height: 22.75 / 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 사용 가이드 보기 버튼
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: onGuide,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1447E6),
                            side: const BorderSide(
                              color: Color(0xFF8EC5FF),
                              width: 0.5,
                            ),
                            backgroundColor: Theme.of(context).colorScheme.surface,
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
                          child: Text(l10n.viewUserGuide),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 우상단 X 닫기 버튼
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. KnittingTipSlide
// ─────────────────────────────────────────────────────────────────────────────

class _KnittingTipSection extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _KnittingTipSection({
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tips = _getKnittingTips(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.knittingTips,
          style: AppTextStyles.titleH3.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        // PageView
        SizedBox(
          height: 97,
          child: PageView.builder(
            controller: pageController,
            itemCount: tips.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _KnittingTipCard(emoji: tip.emoji, text: tip.text),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dot Indicator
        _DotIndicator(count: tips.length, current: currentPage),
      ],
    );
  }
}

class _KnittingTipCard extends StatelessWidget {
  final String emoji;
  final String text;
  const _KnittingTipCard({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB9F8CF), width: 0.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyM.copyWith(
                color: const Color(0xFF008236),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00A63E) : const Color(0xFF7BF1A8),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. CheeringMessage
// ─────────────────────────────────────────────────────────────────────────────

class _CheeringMessage extends StatelessWidget {
  const _CheeringMessage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9D4FF), width: 0.5),
      ),
      child: Column(
        children: [
          const Text('💝', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 24),
          Text(
            l10n.knittingToday,
            style: AppTextStyles.titleH3.copyWith(
              color: const Color(0xFF59168B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.smallStart,
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF8200DB)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
