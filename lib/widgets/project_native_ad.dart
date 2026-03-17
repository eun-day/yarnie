import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// 프로젝트 목록용 네이티브 광고 위젯
class ProjectNativeAd extends StatelessWidget {
  final NativeAd ad;
  final TemplateType type;

  const ProjectNativeAd({
    super.key,
    required this.ad,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    double height;
    switch (type) {
      case TemplateType.medium:
        height = 320;
        break;
      case TemplateType.small:
        height = 90;
        break;
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: AdWidget(ad: ad),
    );
  }
}
