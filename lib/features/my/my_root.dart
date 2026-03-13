import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/features/my/widgets/setting_section.dart';
import 'package:yarnie/features/my/widgets/setting_item.dart';
import 'package:yarnie/features/my/widgets/preferences_sheet.dart';
import 'package:yarnie/features/trash/trash_root.dart';
import 'package:yarnie/features/home/user_guide_screen.dart';
import 'package:yarnie/features/my/widgets/app_info_sheet.dart';
import 'package:yarnie/core/providers/theme_provider.dart';

class MyRoot extends ConsumerStatefulWidget {
  final ScrollController? controller;
  const MyRoot({super.key, this.controller});

  @override
  ConsumerState<MyRoot> createState() => _MyRootState();
}

class _MyRootState extends ConsumerState<MyRoot> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return CustomScrollView(
      controller: widget.controller,
      key: const PageStorageKey('my_scroll'),
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(AppLocalizations.of(context)!.my),
        ),
        SliverPadding(
          padding:  const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SettingSection(
                title: AppLocalizations.of(context)!.settings,
                children: [
                  SettingItem(
                    iconPath: 'assets/icons/notification.svg',
                    title: AppLocalizations.of(context)!.notificationSettings,
                    subtitle: AppLocalizations.of(context)!.notificationSettingsSub,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.comingSoon)),
                      );
                    },
                  ),
                  SettingItem(
                    iconPath: isDarkMode
                        ? 'assets/icons/dark_mode_on.svg'
                        : 'assets/icons/dark_mode.svg',
                    title: AppLocalizations.of(context)!.darkMode,
                    subtitle: isDarkMode ? AppLocalizations.of(context)!.on : AppLocalizations.of(context)!.off,
                    isSwitch: true,
                    initialSwitchValue: isDarkMode,
                    onSwitchChanged: (value) {
                      ref.read(themeProvider.notifier).setThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                    },
                  ),
                  SettingItem(
                    iconPath: 'assets/icons/preferences.svg',
                    title: AppLocalizations.of(context)!.preferencesTitle,
                    subtitle: AppLocalizations.of(context)!.mySubtitle,
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
                title: AppLocalizations.of(context)!.customerSupport,
                children: [
                  SettingItem(
                    iconPath: 'assets/icons/trash.svg',
                    title: AppLocalizations.of(context)!.trash,
                    subtitle: AppLocalizations.of(context)!.trashSub,
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
                    title: AppLocalizations.of(context)!.userGuide,
                    subtitle: AppLocalizations.of(context)!.userGuideSub,
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
                    title: AppLocalizations.of(context)!.appInfo,
                    subtitle: AppLocalizations.of(context)!.appVersion,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AppInfoSheet(),
                      );
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
