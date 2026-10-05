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
  // 실패 직후 의존성이 바뀔 때마다(탭 전환·회전) 다시 요청하지 않도록 제한
  static const _retryInterval = Duration(minutes: 1);

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isLoading = false; // 배너 크기 계산(비동기) 중 중복 요청 방지
  DateTime? _lastFailedAt;
  AdSize? _adSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // IndexedStack의 보이지 않는 탭에서는 요청하지 않는다 (탭이 보이면 다시 호출됨)
    if (!Visibility.of(context)) return;
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    if (_bannerAd != null || _isLoading) return;
    final lastFailedAt = _lastFailedAt;
    if (lastFailedAt != null &&
        DateTime.now().difference(lastFailedAt) < _retryInterval) {
      return;
    }

    // sizeOf/orientationOf: 키보드 등 다른 MediaQuery 변화에는 반응하지 않음
    final orientation = MediaQuery.orientationOf(context);
    final width = MediaQuery.sizeOf(context).width.truncate();

    _isLoading = true;
    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
      orientation,
      width,
    );
    _isLoading = false;

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
          _lastFailedAt = DateTime.now();
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
