import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/theme/text_styles.dart';
import 'package:yarnie/core/providers/locale_provider.dart';
import 'package:yarnie/core/providers/length_unit_provider.dart';

enum TouchFeedback { vibration, sound, both, none }

class PreferencesSheet extends ConsumerStatefulWidget {
  const PreferencesSheet({super.key});

  @override
  ConsumerState<PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends ConsumerState<PreferencesSheet> {
  TouchFeedback _touchFeedback = TouchFeedback.vibration;
  bool _autoBackup = true;
  bool _screenAwake = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5)),
      ),
      child: SafeArea(
        child: Column(
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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.preferencesTitle,
                      style: AppTextStyles.titleH3.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.preferencesSubtitle,
                      style: AppTextStyles.bodyM.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Content List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildLanguageSection(),
                  const SizedBox(height: 32),
                  _buildLengthUnitSection(),
                  const SizedBox(height: 32),
                  _buildDataManageSection(),
                  const SizedBox(height: 32),
                  _buildSessionSettingSection(),
                  const SizedBox(height: 32),
                  _buildTouchFeedbackSection(),
                  const SizedBox(height: 48), // Bottom padding before save button
                ],
              ),
            ),
            // Save Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    l10n.save,
                    style: AppTextStyles.bodyM.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }

  Widget _buildHelperText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 16 / 12,
        ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    final language = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    String languageText;
    switch (language) {
      case AppLanguage.ko:
        languageText = l10n.korean;
        break;
      case AppLanguage.en:
        languageText = 'English';
        break;
      case AppLanguage.auto:
        languageText = l10n.languageCurrentKorean;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.language),
        InkWell(
          onTap: () {
            _showLanguageSelectionBottomSheet();
          }, // Language selection logic
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Text('🌐', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(
                  languageText,
                  style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/icons/chevron_down.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        _buildHelperText(l10n.languageSub),
      ],
    );
  }

  void _showLanguageSelectionBottomSheet() {
    final currentLanguage = ref.read(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.language,
                    style: AppTextStyles.titleH3.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                label: l10n.autoWithDeviceSetting,
                isSelected: currentLanguage == AppLanguage.auto,
                onTap: () {
                  ref.read(localeProvider.notifier).setLanguage(AppLanguage.auto);
                  Navigator.pop(context);
                },
              ),
              _buildLanguageOption(
                label: 'English',
                isSelected: currentLanguage == AppLanguage.en,
                onTap: () {
                  ref.read(localeProvider.notifier).setLanguage(AppLanguage.en);
                  Navigator.pop(context);
                },
              ),
              _buildLanguageOption(
                label: l10n.korean,
                isSelected: currentLanguage == AppLanguage.ko,
                onTap: () {
                  ref.read(localeProvider.notifier).setLanguage(AppLanguage.ko);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.bodyM.copyWith(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? SvgPicture.asset('assets/icons/check_active.svg', width: 24, height: 24)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildLengthUnitSection() {
    final l10n = AppLocalizations.of(context)!;
    final lengthUnit = ref.watch(lengthUnitProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.lengthUnit),
        Row(
          children: [
            Expanded(
              child: _buildRadioOption(
                label: l10n.lengthCm,
                isSelected: lengthUnit == LengthUnit.cm,
                onTap: () => ref.read(lengthUnitProvider.notifier).setLengthUnit(LengthUnit.cm),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRadioOption(
                label: l10n.lengthInch,
                isSelected: lengthUnit == LengthUnit.inch,
                onTap: () => ref.read(lengthUnitProvider.notifier).setLengthUnit(LengthUnit.inch),
              ),
            ),
          ],
        ),
        _buildHelperText(l10n.lengthSub),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(99, 112, 105, 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : const Color.fromRGBO(0, 0, 0, 0.1),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildDataManageSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.dataManage),
        _buildOptionCard(
          iconPath: 'assets/icons/data_upload.svg',
          title: l10n.autoBackup,
          subtitle: l10n.autoBackupSub,
          isHighlighted: true,
          trailing: Switch(
            value: _autoBackup,
            onChanged: (val) => setState(() => _autoBackup = val),
            activeColor: Theme.of(context).colorScheme.surface,
            activeTrackColor: const Color(0xFF6FB96F),
            inactiveThumbColor: Theme.of(context).colorScheme.surface,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          iconPath: 'assets/icons/data_download.svg',
          title: l10n.exportData,
          subtitle: l10n.exportDataSub,
          isHighlighted: false,
          trailing: SvgPicture.asset('assets/icons/chevron_right.svg', width: 20, height: 20),
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          iconPath: 'assets/icons/data_upload.svg',
          title: l10n.importData,
          subtitle: l10n.importDataSub,
          isHighlighted: false,
          trailing: SvgPicture.asset('assets/icons/chevron_right.svg', width: 20, height: 20),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSessionSettingSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.sessionSetting),
        _buildOptionCard(
          iconPath: 'assets/icons/phone_active.svg',
          title: l10n.screenAwake,
          subtitle: l10n.screenAwakeSub,
          isHighlighted: true,
          trailing: Switch(
            value: _screenAwake,
            onChanged: (val) => setState(() => _screenAwake = val),
            activeColor: Theme.of(context).colorScheme.surface,
            activeTrackColor: const Color(0xFF6FB96F),
            inactiveThumbColor: Theme.of(context).colorScheme.surface,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String iconPath,
    required String title,
    required String subtitle,
    required bool isHighlighted,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: isHighlighted ? const Color.fromRGBO(236, 236, 240, 0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isHighlighted
              ? null
              : Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1), width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 20, height: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.31,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildTouchFeedbackSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.touchFeedback),
        _buildHelperText(l10n.touchFeedbackSub),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 176 / 83,
          physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildFeedbackCard(
                type: TouchFeedback.vibration,
                label: l10n.vibrate,
                activeIconPath: 'assets/icons/phone_active.svg',
                inactiveIconPath: 'assets/icons/phone_inactive.svg',
              ),
              _buildFeedbackCard(
                type: TouchFeedback.sound,
                label: l10n.sound,
                activeIconPath: 'assets/icons/sound_inactive.svg', // Assuming sound doesn't change color just usage
                inactiveIconPath: 'assets/icons/sound_inactive.svg',
              ),
              _buildFeedbackCard(
                type: TouchFeedback.both,
                label: l10n.both,
                activeIconPath: 'assets/icons/phone_inactive.svg', 
                inactiveIconPath: 'assets/icons/phone_inactive.svg',
              ),
              _buildFeedbackCard(
                type: TouchFeedback.none,
                label: l10n.none,
                activeIconPath: null,
                inactiveIconPath: null,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFeedbackCard({
    required TouchFeedback type,
    required String label,
    required String? activeIconPath,
    required String? inactiveIconPath,
  }) {
    final isSelected = _touchFeedback == type;
    final iconPath = isSelected ? activeIconPath : inactiveIconPath;

    return InkWell(
      onTap: () => setState(() => _touchFeedback = type),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(99, 112, 105, 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : const Color.fromRGBO(0, 0, 0, 0.1),
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconPath != null) ...[
                  SvgPicture.asset(iconPath, width: 20, height: 20),
                  const SizedBox(height: 8),
                ],
                Text(
                  label,
                  style: AppTextStyles.bodyM.copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: SvgPicture.asset('assets/icons/check_active.svg', width: 16, height: 16),
              ),
          ],
        ),
      ),
    );
  }
}
