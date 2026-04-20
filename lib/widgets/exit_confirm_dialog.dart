import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/ad_visibility_wrapper.dart';
import 'package:yarnie/common/ad_helper.dart';

class ExitConfirmDialog extends StatefulWidget {
  const ExitConfirmDialog({super.key});

  @override
  State<ExitConfirmDialog> createState() => _ExitConfirmDialogState();
}

class _ExitConfirmDialogState extends State<ExitConfirmDialog> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final adUnitId = AdHelper.exitDialogBannerId;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

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
              l10n.exitAppTitle,
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
              l10n.exitAppMessage,
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
            // 광고 영역 (300x250)
            AdVisibilityWrapper(
              child: SizedBox(
                width: 300,
                height: 250,
                child: _isAdLoaded
                    ? AdWidget(ad: _bannerAd!)
                    : Container(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
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
                        l10n.cancel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.exit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.surface,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
