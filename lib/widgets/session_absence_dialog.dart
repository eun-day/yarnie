import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';

/// 앱을 오래 떠났다 돌아왔을 때, 그동안의 시간을 진행 중인 세션에 반영할지 묻는다.
/// 반영하면 true, 반영하지 않으면 false를 돌려준다.
class SessionAbsenceDialog extends StatelessWidget {
  final Duration absence;

  const SessionAbsenceDialog({super.key, required this.absence});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.sessionAbsenceTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                letterSpacing: -0.44,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.sessionAbsenceMessage(absence.inMinutes),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurfaceVariant,
                letterSpacing: -0.15,
                height: 1.43,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context, true),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.sessionAbsenceInclude,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.surface,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outline,
                    width: 0.694,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.sessionAbsenceExclude,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
