import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/core/providers/premium_provider.dart';
import 'package:yarnie/common/ad_helper.dart';

class ExitConfirmDialog extends ConsumerStatefulWidget {
  const ExitConfirmDialog({super.key});

  @override
  ConsumerState<ExitConfirmDialog> createState() => _ExitConfirmDialogState();
}

class _ExitConfirmDialogState extends ConsumerState<ExitConfirmDialog> {
  static const _adWidth = 300.0; // AdSize.mediumRectangle (300x250)

  BannerAd? _bannerAd; // null이면 광고 영역 없음 (프리미엄 또는 로드 실패)
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // 프리미엄 회원에게는 광고를 요청하지 않는다
    if (!ref.read(premiumProvider)) _loadAd();
  }

  void _loadAd() {
    final adUnitId = AdHelper.exitDialogBannerId;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          // 로딩 표시가 계속 남지 않도록 광고 영역을 숨긴다
          if (!mounted) return;
          setState(() {
            _bannerAd = null;
          });
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
      // 기본 여백(inset 40 + padding 24)으로는 360dp 폰에서 폭이 232dp라 300dp 광고가 잘린다
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            // 광고 영역 (300x250). 화면이 너무 좁으면 광고가 잘리므로 표시하지 않는다
            if (_bannerAd != null)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < _adWidth) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: _adWidth,
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
                  );
                },
              ),
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
