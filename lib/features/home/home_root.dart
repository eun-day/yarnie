import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/new_project_screen.dart';
import 'package:yarnie/project_detail_screen.dart';
import 'package:yarnie/theme/text_styles.dart';

const _kGuideCardDismissedKey = 'home_guide_card_dismissed';

/// 뜨개질 팁 데이터
const _knittingTips = <({String emoji, String text})>[
  (emoji: '🧶', text: '실 끝은 최소 10cm 남겨두면 마무리가 편해요'),
  (emoji: '📏', text: '게이지 샘플을 꼭 떠보세요. 프로젝트 성공의 비결이에요!'),
  (emoji: '✨', text: '한 코 한 코 천천히, 서두르지 마세요'),
  (emoji: '🎨', text: '색 조합이 고민된다면 자연에서 영감을 받아보세요'),
  (emoji: '🌡️', text: '뜨개질 텐션이 너무 세면 손목이 아플 수 있어요. 편안하게!'),
  (emoji: '📱', text: 'Yarnie의 섹션 카운터로 복잡한 패턴도 쉽게 추적할 수 있어요'),
  (emoji: '🎯', text: '패턴을 읽을 때는 한 줄씩 체크하면서 진행하세요'),
  (emoji: '🌟', text: '휴식을 자주 가지세요. 피로하면 실수가 늘어납니다'),
  (emoji: '📐', text: '바늘 사이즈가 맞는지 확인하세요. 작품의 완성도가 달라집니다'),
  (emoji: '💚', text: '실수를 두려워하지 마세요. 풀고 다시 뜨는 것도 연습입니다'),
];

class HomeRoot extends StatefulWidget {
  final ScrollController? controller;
  final String title;

  const HomeRoot({super.key, this.controller, this.title = 'Yarnie'});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          controller: widget.controller,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 33),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NewProjectScreen(),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),
              if (_showGuideCard)
                _UserGuideCard(
                  onClose: _dismissGuideCard,
                  onGuide: () {
                    // TODO: 사용 가이드 화면으로 이동
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isActiveUser ? '환영합니다! 🦎' : '안녕하세요! 🦎',
          style: AppTextStyles.titleH1.copyWith(color: const Color(0xFF0A0A0A)),
        ),
        const SizedBox(height: 4),
        Text(
          isActiveUser ? '오늘도 즐거운 뜨개질 하세요' : '뜨개질과 함께하는 즐거운 시간을 시작해보세요',
          style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2a. NewProjectCard (신규 사용자)
// ─────────────────────────────────────────────────────────────────────────────

class _NewProjectCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewProjectCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF637069).withValues(alpha: 0.2),
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
              color: const Color(0xFF637069).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🦎', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 16),
          // 타이틀
          Text(
            '첫 프로젝트를 시작해보세요!',
            style: AppTextStyles.titleH2.copyWith(
              color: const Color(0xFF0A0A0A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 설명 텍스트
          Text(
            '카멜레온과 함께 뜨개질 여정을 시작해요\n한 코 한 코가 모여 멋진 작품이 됩니다',
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // CTA 버튼
          SizedBox(
            width: double.infinity,
            height: 36,
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.bolt, size: 16),
              label: const Text(
                '새 프로젝트 시작하기',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF637069),
                foregroundColor: Colors.white,
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

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now().toUtc();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}주 전';
    return '${diff.inDays ~/ 30}개월 전';
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final lastTime = widget.lastActivity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '최근 작업 프로젝트',
          style: AppTextStyles.titleH3.copyWith(color: const Color(0xFF0A0A0A)),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF637069).withValues(alpha: 0.2),
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
                child: const Text('🧶', style: TextStyle(fontSize: 30)),
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
                        color: const Color(0xFF0A0A0A),
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
                          color: const Color(0xFF717182),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    // 상대 시간
                    Text(
                      _timeAgo(lastTime),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12,
                        color: Color(0xFF717182),
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
                    backgroundColor: const Color(0xFF637069),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: const Text('이어하기'),
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
                        '처음 사용하시나요?',
                        style: AppTextStyles.titleH3.copyWith(
                          color: const Color(0xFF1C398E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Yarnie는 프로젝트를 Part로 나누고, 각 Part마다 카운터로 진행 상황을 추적해요.',
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
                            backgroundColor: Colors.white,
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
                          child: const Text('사용 가이드 보기'),
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
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, size: 14, color: Color(0xFF717182)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '뜨개질 팁',
          style: AppTextStyles.titleH3.copyWith(color: const Color(0xFF0A0A0A)),
        ),
        const SizedBox(height: 12),
        // PageView
        SizedBox(
          height: 97,
          child: PageView.builder(
            controller: pageController,
            itemCount: _knittingTips.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final tip = _knittingTips[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _KnittingTipCard(emoji: tip.emoji, text: tip.text),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dot Indicator
        _DotIndicator(count: _knittingTips.length, current: currentPage),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB9F8CF), width: 0.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
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
          margin: const EdgeInsets.symmetric(horizontal: 3),
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
            '오늘도 뜨개질해볼까요?',
            style: AppTextStyles.titleH3.copyWith(
              color: const Color(0xFF59168B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            '작은 시작이 큰 작품을 만들어요\n지금 바로 첫 번째 코를 떠보세요!',
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF8200DB)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
