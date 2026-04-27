import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/theme/text_styles.dart';
import 'package:yarnie/core/providers/locale_provider.dart';
import 'package:yarnie/core/providers/length_unit_provider.dart';
import 'package:yarnie/core/providers/settings_provider.dart';
import 'package:yarnie/common/haptic_helper.dart';
import 'package:yarnie/core/services/backup_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class PreferencesSheet extends ConsumerStatefulWidget {
  const PreferencesSheet({super.key});

  @override
  ConsumerState<PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends ConsumerState<PreferencesSheet> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

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
                  _buildSessionSettingSection(settings),
                  const SizedBox(height: 32),
                  _buildTouchFeedbackSection(settings),
                  const SizedBox(height: 48), // Bottom padding
                ],
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
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLanguage(AppLanguage.auto);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _buildLanguageOption(
                label: 'English',
                isSelected: currentLanguage == AppLanguage.en,
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLanguage(AppLanguage.en);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _buildLanguageOption(
                label: l10n.korean,
                isSelected: currentLanguage == AppLanguage.ko,
                onTap: () async {
                  await ref.read(localeProvider.notifier).setLanguage(AppLanguage.ko);
                  if (context.mounted) Navigator.pop(context);
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
        /* _buildOptionCard(
          iconPath: 'assets/icons/data_upload.svg',
          title: l10n.autoBackup,
          subtitle: l10n.autoBackupSub,
          isHighlighted: true,
          trailing: Switch(
            value: false, // 임시 값
            onChanged: (val) {},
            activeColor: Theme.of(context).colorScheme.surface,
            activeTrackColor: const Color(0xFF6FB96F),
            inactiveThumbColor: Theme.of(context).colorScheme.surface,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 12), */
        _buildOptionCard(
          iconPath: 'assets/icons/data_download.svg',
          title: l10n.exportData,
          subtitle: l10n.exportDataSub,
          isHighlighted: false,
          trailing: SvgPicture.asset('assets/icons/chevron_right.svg', width: 20, height: 20),
          onTap: _exportData,
        ),
        const SizedBox(height: 12),
        _buildOptionCard(
          iconPath: 'assets/icons/data_upload.svg',
          title: l10n.importData,
          subtitle: l10n.importDataSub,
          isHighlighted: false,
          trailing: SvgPicture.asset('assets/icons/chevron_right.svg', width: 20, height: 20),
          onTap: _importData,
        ),
      ],
    );
  }

  Widget _buildSessionSettingSection(AppSettings settings) {
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
            value: settings.screenAwake,
            onChanged: (val) => ref.read(settingsProvider.notifier).setScreenAwake(val),
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

  Widget _buildTouchFeedbackSection(AppSettings settings) {
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
                type: TouchFeedbackType.vibration,
                label: l10n.vibrate,
                activeIconPath: 'assets/icons/phone_active.svg',
                inactiveIconPath: 'assets/icons/phone_inactive.svg',
                currentType: settings.touchFeedback,
              ),
              _buildFeedbackCard(
                type: TouchFeedbackType.sound,
                label: l10n.sound,
                activeIconPath: 'assets/icons/sound_inactive.svg', // Assuming sound doesn't change color just usage
                inactiveIconPath: 'assets/icons/sound_inactive.svg',
                currentType: settings.touchFeedback,
              ),
              _buildFeedbackCard(
                type: TouchFeedbackType.both,
                label: l10n.both,
                activeIconPath: 'assets/icons/phone_inactive.svg', 
                inactiveIconPath: 'assets/icons/phone_inactive.svg',
                currentType: settings.touchFeedback,
              ),
              _buildFeedbackCard(
                type: TouchFeedbackType.none,
                label: l10n.none,
                activeIconPath: null,
                inactiveIconPath: null,
                currentType: settings.touchFeedback,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFeedbackCard({
    required TouchFeedbackType type,
    required String label,
    required String? activeIconPath,
    required String? inactiveIconPath,
    required TouchFeedbackType currentType,
  }) {
    final isSelected = currentType == type;
    final iconPath = isSelected ? activeIconPath : inactiveIconPath;

    return InkWell(
      enableFeedback: false,
      onTap: () async {
        await ref.read(settingsProvider.notifier).setTouchFeedback(type);
        HapticHelper.validateAndFeedback(type);
      },
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

  Future<void> _exportData() async {
    _showLoadingDialog();
    try {
      final backupPath = await ref.read(backupServiceProvider).exportBackup();
      
      if (!mounted) return;
      Navigator.pop(context); // 로딩 다이얼로그 닫기

      final xFile = XFile(backupPath);
      final box = context.findRenderObject() as RenderBox?;
      
      // 공유 시트 호출 및 결과 확인
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [xFile],
          sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
        ),
      );
      
      // 실제 전송(Success)되었을 때만 성공 메시지 표시
      if (result.status == ShareResultStatus.success && mounted) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context); // PreferencesSheet 닫기 (스낵바가 보이도록)
        
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('데이터 내보내기가 완료되었습니다!'),
            backgroundColor: Color(0xFF6FB96F),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      
      final file = File(backupPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (mounted) {
        if (Navigator.canPop(context)) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('내보내기 실패: $e')),
        );
      }
    }
  }

  Future<void> _importData() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['yarnie', 'json'],
      );

      if (result == null || result.files.single.path == null) return;

      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.importData),
          content: const Text('기존 데이터가 모두 삭제되고 백업 데이터로 대체됩니다. 계속하시겠습니까?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('계속하기', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      if (!mounted) return;
      _showLoadingDialog(); // 로딩 시작

      await ref.read(backupServiceProvider).importBackup(result.files.single.path!);

      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        Navigator.pop(context); // PreferencesSheet 닫기 (메시지를 보이게 하기 위함)
        
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('데이터 복원이 완료되었습니다!'),
            backgroundColor: Color(0xFF6FB96F),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        if (Navigator.canPop(context)) Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('복원 실패: $e')),
        );
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
