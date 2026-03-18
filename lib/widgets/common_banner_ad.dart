import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CommonBannerAdWidget extends StatefulWidget {
  final String adUnitId;

  const CommonBannerAdWidget({
    super.key,
    required this.adUnitId,
  });

  @override
  State<CommonBannerAdWidget> createState() => _CommonBannerAdWidgetState();
}

class _CommonBannerAdWidgetState extends State<CommonBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  AdSize? _adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    if (_bannerAd != null) return;

    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width.truncate();

    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
      orientation,
      width,
    );

    if (size == null) {
      debugPrint('Unable to get adaptive banner size.');
      return;
    }

    if (!mounted) return;

    _adSize = size;

    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isAdLoaded = false;
            });
          }
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
    if (!_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: SizedBox(
        width: _adSize?.width.toDouble() ?? double.infinity,
        height: _adSize?.height.toDouble() ?? AdSize.banner.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
