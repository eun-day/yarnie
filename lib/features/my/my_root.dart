import 'package:flutter/material.dart';
import 'package:yarnie/features/my/widgets/setting_section.dart';
import 'package:yarnie/features/my/widgets/setting_item.dart';
import 'package:yarnie/features/my/widgets/preferences_sheet.dart';
import 'package:yarnie/features/trash/trash_root.dart';
import 'package:yarnie/features/home/user_guide_screen.dart';
import 'package:yarnie/core/l10n/app_strings.dart';

class MyRoot extends StatefulWidget {
  final ScrollController? controller;
  const MyRoot({super.key, this.controller});

  @override
  State<MyRoot> createState() => _MyRootState();
}

class _MyRootState extends State<MyRoot> {
  // Temporary state for the UI mockup
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      key: const PageStorageKey('my_scroll'),
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(AppStrings.tr(context, '마이')), // temporary generic string fallback
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SettingSection(
                title: '설정',
                children: [
                  SettingItem(
                    iconPath: 'assets/icons/notification.svg',
                    title: '알림 설정',
                    subtitle: '작업 리마인더, 배지 알림',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('추후 제공될 기능입니다.')),
                      );
                    },
                  ),
                  SettingItem(
                    iconPath: _isDarkMode
                        ? 'assets/icons/dark_mode_on.svg'
                        : 'assets/icons/dark_mode.svg',
                    title: '다크 모드',
                    subtitle: _isDarkMode ? '켜짐' : '꺼짐',
                    isSwitch: true,
                    initialSwitchValue: _isDarkMode,
                    onSwitchChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                  SettingItem(
                    iconPath: 'assets/icons/preferences.svg',
                    title: AppStrings.tr(context, AppStrings.preferencesTitle),
                    subtitle: AppStrings.tr(context, '언어, 단위, 백업'), // temp fallback
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const FractionallySizedBox(
                          heightFactor: 0.8,
                          child: PreferencesSheet(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SettingSection(
                title: '고객 지원',
                children: [
                  SettingItem(
                    iconPath: 'assets/icons/trash.svg',
                    title: '휴지통',
                    subtitle: '삭제된 프로젝트 관리',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrashRoot(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    iconPath: 'assets/icons/user_guide.svg',
                    title: '사용 가이드',
                    subtitle: 'Yarnie 사용법 배우기',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserGuideScreen(),
                        ),
                      );
                    },
                  ),
                  SettingItem(
                    iconPath: 'assets/icons/app_info.svg',
                    title: '앱 정보',
                    subtitle: '버전 1.0.0',
                    onTap: () {
                      // TODO: Navigate to App Info
                    },
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
