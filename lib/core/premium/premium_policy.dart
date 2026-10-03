import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/features/my/yarnie_premium_screen.dart';

class PremiumPolicy {
  static const int maxProjects = 1;
  static const int maxPartsPerProject = 3;
  static const int maxCountersPerPart = 3;

  static bool canCreateProject(int currentProjectCount, bool isPremium) {
    if (isPremium) return true;
    return currentProjectCount < maxProjects;
  }

  static bool canCreatePart(int currentPartCount, bool isPremium) {
    if (isPremium) return true;
    return currentPartCount < maxPartsPerProject;
  }

  static bool canCreateCounter(int currentCounterCount, bool isPremium) {
    if (isPremium) return true;
    return currentCounterCount < maxCountersPerPart;
  }
}

class PremiumUIHelper {
  static (IconData icon, Color? backgroundColor) getButtonStyle({
    required bool isLocked,
    required IconData defaultIcon,
    required Color defaultBackgroundColor,
  }) {
    if (isLocked) {
      return (Icons.lock, const Color(0xFF9CA3AF));
    }
    return (defaultIcon, defaultBackgroundColor);
  }

  static void showUpsellSnackbar(BuildContext context) {
    // 바텀시트·메뉴에서 호출한 뒤 그 화면이 닫혀도 버튼이 동작하도록 지금 찾아 둔다
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context)!;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(l10n.upsellSnackbarMessage),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                messenger.hideCurrentSnackBar();
                navigator.push(
                  MaterialPageRoute(builder: (_) => const YarniePremiumScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFA8C5B0),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(l10n.upsellSnackbarAction),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
      ),
    );
  }
}
