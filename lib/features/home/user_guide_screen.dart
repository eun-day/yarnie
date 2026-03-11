import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/theme/text_styles.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            _Header(onBack: () => Navigator.pop(context)),
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
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
              icon: const Icon(
                Icons.arrow_back,
                size: 16,
                color: Color(0xFF0A0A0A),
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
                  '사용 가이드',
                  style: AppTextStyles.titleH2.copyWith(
                    color: const Color(0xFF0A0A0A),
                  ),
                ),
                Text(
                  'Yarnie와 함께하는 뜨개질 여정',
                  style: AppTextStyles.bodyM.copyWith(
                    color: const Color(0xFF717182),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.6, -0.8),
          end: const Alignment(0.6, 0.8),
          colors: [
            const Color(0xFF637069).withValues(alpha: 0.1),
            const Color(0xFF637069).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF637069).withValues(alpha: 0.2),
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
              color: const Color(0xFF637069).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🦎', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 16),
          // 타이틀
          Text(
            'Yarnie에 오신 것을 환영해요!',
            style: AppTextStyles.titleH2.copyWith(
              color: const Color(0xFF0A0A0A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // 설명
          Text(
            'Yarnie는 뜨개질 프로젝트를 체계적으로 관리하고\n진행 상황을 쉽게 추적할 수 있도록 도와드려요',
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('📱 3개의 탭으로 구성되어 있어요'),
        const SizedBox(height: 12),
        // 홈 탭
        _TabCard(
          icon: Icons.home_outlined,
          title: '홈 탭',
          description: '진행 중인 작업을 빠르게 확인하고 이어서 작업할 수 있어요. 활동 기록과 배지도 여기서 확인해요.',
        ),
        const SizedBox(height: 12),
        // 프로젝트 탭
        _TabCard(
          icon: Icons.folder_outlined,
          title: '프로젝트 탭',
          description:
              '모든 프로젝트를 관리하는 곳이에요. 대형 갤러리, 소형 갤러리, 리스트 보기로 전환할 수 있고, 최근 작업순, 최신순, 오래된순, 이름순으로 정렬할 수 있어요.',
        ),
        const SizedBox(height: 12),
        // 마이 탭
        _TabCard(
          icon: Icons.person_outline,
          title: '마이 탭',
          description: '태그 관리, 휴지통, 설정 등 부가 기능을 사용할 수 있어요.',
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
    return _TipCard(
      emoji: '🏷️',
      title: '태그 필터링',
      description:
          '프로젝트 탭에서 태그를 선택하면 해당 태그가 붙은 프로젝트만 볼 수 있어요. 여러 개의 태그를 동시에 선택하면 모든 태그를 가진 프로젝트만 표시돼요.',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: const Color(0xFF637069).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 24, color: const Color(0xFF0A0A0A)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleH3.copyWith(
                    color: const Color(0xFF0A0A0A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyM.copyWith(
                    color: const Color(0xFF717182),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('🎯 프로젝트 만들기'),
        const SizedBox(height: 12),
        // 설명 + 스텝 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                '프로젝트는 하나의 완성된 작품을 의미해요. 예를 들어 "겨울 스웨터", "아기 담요", "양말" 같은 거예요.',
                style: AppTextStyles.bodyM.copyWith(
                  color: const Color(0xFF717182),
                ),
              ),
              const SizedBox(height: 40),
              // 스텝 1
              _StepRow(
                number: '1',
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: const Color(0xFF0A0A0A),
                    ),
                    children: const [
                      TextSpan(text: '프로젝트 탭에서 '),
                      TextSpan(
                        text: '+ 새 프로젝트',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' 버튼을 눌러요'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 스텝 2
              _StepRow(
                number: '2',
                child: Text(
                  '프로젝트 이름, 바늘 정보, 사진 등을 입력해요',
                  style: AppTextStyles.bodyM.copyWith(
                    color: const Color(0xFF0A0A0A),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 스텝 3
              _StepRow(
                number: '3',
                child: Text(
                  '태그를 추가해서 분류할 수 있어요 (선택사항)',
                  style: AppTextStyles.bodyM.copyWith(
                    color: const Color(0xFF0A0A0A),
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
            color: const Color(0xFF637069).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
              color: Color(0xFF0A0A0A),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('🧩 Part로 나누기'),
        const SizedBox(height: 12),
        // 설명 + 예시 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                '프로젝트는 여러 Part로 나눌 수 있어요. 각 Part는 독립적으로 작업을 진행할 수 있어요.',
                style: AppTextStyles.bodyM.copyWith(
                  color: const Color(0xFF717182),
                ),
              ),
              const SizedBox(height: 36),
              // 예시 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFECECF0).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '예시: 스웨터 프로젝트',
                      style: AppTextStyles.bodyM.copyWith(
                        color: const Color(0xFF0A0A0A),
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
                            '• 앞판',
                            '• 뒷판',
                            '• 왼쪽 소매',
                            '• 오른쪽 소매',
                            '• 목둘레',
                          ])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                part,
                                style: AppTextStyles.bodyM.copyWith(
                                  color: const Color(0xFF717182),
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
          title: 'Part 추가 방법',
          description: '프로젝트 상세 화면에서 왼쪽 상단의',
          highlight: '+ 새 파트',
          descriptionSuffix: '\n버튼을 누르면 새로운 Part를 추가할 수 있어요.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('🔢 카운터 시스템'),
        const SizedBox(height: 12),

        // 카운터 소개 카드
        _SimpleCard(
          text:
              '각 Part는 카운터로 진행 상황을 추적해요.\nMainCounter 1개와 여러 개의 BuddyCounter를 가질 수 있어요.',
        ),
        const SizedBox(height: 12),

        // ── 메인 카운터 ──
        _subSectionTitle('메인 카운터 (MainCounter)'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                      color: const Color(0xFF637069).withValues(alpha: 0.1),
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
                      '단수를 세는 기본 카운터예요. 한 번 탭하면 1단씩 증가해요.',
                      style: AppTextStyles.bodyM.copyWith(
                        color: const Color(0xFF717182),
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
                  color: const Color(0xFFECECF0).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: const Color(0xFF717182),
                    ),
                    children: const [
                      TextSpan(
                        text: '💡 팁:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            ' 목표 단수를 설정하면 진행률을 확인할 수 있어요. 예를 들어 100단을 목표로 설정하면 현재 몇 %까지 진행했는지 알 수 있어요.',
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
        _subSectionTitle('보조 카운터 (BuddyCounter)'),
        const SizedBox(height: 4),
        Text(
          '메인 카운터와 함께 사용하는 보조 카운터예요. 코 카운터와 섹션 카운터가 있어요.',
          style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
        ),
        const SizedBox(height: 12),

        // 코 카운터
        _CounterDetailCard(
          svgPath: 'assets/icons/counter_stitch.svg',
          iconBgColor: const Color(0xFFF3E8FF),
          title: '코 카운터 (Stitch Counter)',
          titleStyle: AppTextStyles.titleH3.copyWith(
            color: const Color(0xFF0A0A0A),
          ),
          description: '한 단 내에서 코 수를 세는 독립적인 카운터예요. 메인 카운터와 연동되지 않아요.',
          tipBox: _UseCaseBox(
            title: '언제 사용하나요?',
            items: const [
              '• 복잡한 패턴에서 현재 어느 코까지 작업했는지 추적',
              '• 늘림/줄임 작업할 때 정확한 코 수 확인',
              '• 케이블이나 레이스 패턴의 반복 구간 세기',
            ],
            backgroundColor: const Color(0xFFFAF5FF).withValues(alpha: 0.5),
            borderColor: const Color(0xFFF3E8FF),
          ),
        ),
        const SizedBox(height: 12),

        // 섹션 카운터
        _CounterDetailCard(
          svgPath: 'assets/icons/counter_section.svg',
          iconBgColor: const Color(0xFF637069).withValues(alpha: 0.2),
          title: '섹션 카운터 (Section Counter)',
          titleStyle: AppTextStyles.titleH3.copyWith(
            color: const Color(0xFF0A0A0A),
          ),
          description: '메인 카운터와 연동되어 특정 구간이나 패턴을 추적하는 카운터예요. 5가지 유형이 있어요.',
          cardBackgroundColor: const Color(0xFF637069).withValues(alpha: 0.05),
          cardBorderColor: const Color(0xFF637069).withValues(alpha: 0.3),
          tipBox: _LinkedInfoBox(
            title: '🔗 메인 카운터 연동',
            description:
                '링크 버튼을 켜면 메인 카운터가 증가할 때 자동으로 함께 계산돼요. 섹션 카운터는 항상 메인 카운터와 연동되어야 작동해요.',
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
                '섹션 카운터 5가지 유형',
                style: AppTextStyles.bodyM.copyWith(
                  color: const Color(0xFF637069),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // 1. 범위 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_range.svg',
                iconBgColor: const Color(0xFFDCFCE7),
                title: '범위 카운터 (Range)',
                description: '특정 구간(시작행~목표행)의 작업을 추적해요.',
                useCases: const [
                  '• "20~40단까지 겉뜨기" 같은 구간 작업',
                  '• 패턴이 바뀌는 특정 구간 표시',
                  '• 여러 색상을 사용하는 구간 관리',
                ],
                example: '"앞판 20~40단: 케이블 패턴"',
                accentBgColor: const Color(0xFFF0FDF4).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFDCFCE7),
                dividerColor: const Color(0xFFB9F8CF),
              ),
              const SizedBox(height: 12),

              // 2. 반복 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_repeat.svg',
                iconBgColor: const Color(0xFFDBEAFE),
                title: '반복 카운터 (Repeat)',
                description: '몇 단마다 반복되는 작업을 추적해요.',
                useCases: const [
                  '• "6단마다 늘림" 같은 반복 작업',
                  '• "4단마다 패턴 반복" 추적',
                  '• 규칙적인 무늬나 기법 세기',
                ],
                example: '"6단마다 양쪽에서 1코씩 늘림 (8회 반복)"',
                accentBgColor: const Color(0xFFEFF6FF).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFDBEAFE),
                dividerColor: const Color(0xFFBEDBFF),
              ),
              const SizedBox(height: 12),

              // 3. 인터벌 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_interval.svg',
                iconBgColor: const Color(0xFFFFEDD4),
                title: '인터벌 카운터 (Interval)',
                description: '일정 간격마다 변화하는 작업을 추적해요.\n(예: 색상 변경)',
                useCases: const [
                  '• 색상을 주기적으로 바꿀 때',
                  '• 스트라이프 패턴 만들기',
                  '• 실 배열 순서 추적',
                ],
                example: '"4단마다 색상 변경: 파란색 → 흰색 → 빨간색\n순서로"',
                accentBgColor: const Color(0xFFFFF7ED).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFFFEDD4),
                dividerColor: const Color(0xFFFFD6A7),
              ),
              const SizedBox(height: 12),

              // 4. 쉐이핑 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_shaping.svg',
                iconBgColor: const Color(0xFFFCE7F3),
                title: '쉐이핑 카운터 (Shaping)',
                description: '늘림/줄임 작업의 진행 상황을 추적해요.',
                useCases: const [
                  '• 소매나 몸판의 늘림/줄임 작업',
                  '• 라글란 소매의 사선 만들기',
                  '• 목둘레나 어깨선 줄임',
                ],
                example: '"양쪽에서 6회 늘림: 68코 → 80코"',
                accentBgColor: const Color(0xFFFDF2F8).withValues(alpha: 0.5),
                accentBorderColor: const Color(0xFFFCE7F3),
                dividerColor: const Color(0xFFFCCEE8),
              ),
              const SizedBox(height: 12),

              // 5. 길이 카운터
              _SectionCounterTypeCard(
                svgPath: 'assets/icons/counter_length.svg',
                iconBgColor: const Color(0xFFFEF9C2),
                title: '길이 카운터 (Length)',
                description: '특정 길이에 도달할 때까지 작업을 추적해요.',
                useCases: const [
                  '• "30cm까지 뜨기" 같은 길이 기반 작업',
                  '• 스카프나 담요의 원하는 길이 도달',
                  '• 소매 길이나 몸통 길이 추적',
                ],
                example: '"겉뜨기로 40cm까지 계속"',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('🔗 섹션 카운터 연동 기능'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                '섹션 카운터는 메인 카운터와 연동할 수 있어요. 연동하면 메인 카운터가 증가할 때 자동으로 함께 계산돼요.',
                style: AppTextStyles.bodyM.copyWith(
                  color: const Color(0xFF717182),
                ),
              ),
              const SizedBox(height: 36),
              // 팁 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECECF0).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text.rich(
                  TextSpan(
                    style: AppTextStyles.bodyM.copyWith(
                      color: const Color(0xFF717182),
                    ),
                    children: [
                      const TextSpan(
                        text: '💡 팁: 링크 버튼 ',
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
                      const TextSpan(
                        text: ' 을 눌러서 연동을 켜거나 끌 수 있어요. 초록색이면 연동 중이에요.',
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
                  '참고: 코 카운터는 한 단 내에서 독립적으로 동작하므로 메인 카운터와 연동되지 않아요.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('✨ 활용 팁'),
        const SizedBox(height: 12),
        _ActivityTipCard(
          title: '📝 메모를 활용하세요',
          description:
              '각 파트마다 메모를 남길 수 있어요. "이 구간에서 실수 많이 함", "다음엔 더 느슨하게" 같은 메모를 남기면 도움이 돼요.',
        ),
        const SizedBox(height: 12),
        _ActivityTipCard(
          title: '🎨 태그로 분류하세요',
          description:
              '프로젝트에 태그를 추가해서 쉽게 찾을 수 있어요. "진행중", "완료", "의류", "소품" 같은 태그를 만들어보세요.',
        ),
        const SizedBox(height: 12),
        _ActivityTipCard(
          title: '📸 사진을 남기세요',
          description: '완성된 작품이나 진행 중인 모습을 사진으로 남기면 나중에 다시 보는 재미가 있어요.',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF637069).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF637069).withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: const Color(0xFF0A0A0A),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            description,
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.7, -0.7),
          end: const Alignment(0.7, 0.7),
          colors: [
            const Color(0xFF637069).withValues(alpha: 0.1),
            const Color(0xFF637069).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF637069).withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          const Text('🦎', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 36),
          Text(
            '이제 시작할 준비가 되셨나요?',
            style: AppTextStyles.titleH3.copyWith(
              color: const Color(0xFF0A0A0A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            'Yarnie와 함께 즐거운 뜨개질 여정을 시작해보세요!\n궁금한 점이 있으면 언제든 다시 확인하세요.',
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            '이 가이드는 홈 화면의 사용 가이드 카드 또는 마이 > 고객 지원에서 다시 볼 수 있어요.',
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
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
                backgroundColor: const Color(0xFF637069),
                foregroundColor: Colors.white,
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
              child: const Text('닫기'),
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

Widget _sectionTitle(String text) {
  return Text(
    text,
    style: AppTextStyles.titleH3.copyWith(color: const Color(0xFF0A0A0A)),
  );
}

Widget _subSectionTitle(String text) {
  return Text(
    text,
    style: AppTextStyles.titleH3.copyWith(color: const Color(0xFF0A0A0A)),
  );
}

class _SimpleCard extends StatelessWidget {
  final String text;
  const _SimpleCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
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
      padding: const EdgeInsets.all(16),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(12),
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
              color: const Color(0xFF0A0A0A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: AppTextStyles.bodyM.copyWith(
                  color: const Color(0xFF717182),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF637069).withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyM.copyWith(
              color: const Color(0xFF0A0A0A),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyM.copyWith(color: const Color(0xFF717182)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor ?? Colors.white,
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
                        color: const Color(0xFF717182),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                        color: const Color(0xFF0A0A0A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTextStyles.bodyM.copyWith(
                        color: const Color(0xFF717182),
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
            padding: const EdgeInsets.all(12),
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
                    color: const Color(0xFF0A0A0A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                for (final item in useCases)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      item,
                      style: AppTextStyles.bodyM.copyWith(
                        color: const Color(0xFF717182),
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
                      color: const Color(0xFF0A0A0A),
                    ),
                    children: [
                      const TextSpan(
                        text: '예시: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
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
