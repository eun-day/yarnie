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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(AppLocalizations.of(context)!.upsellSnackbarMessage),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const YarniePremiumScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFA8C5B0),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: Text(AppLocalizations.of(context)!.upsellSnackbarAction),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
      ),
    );
  }
}
