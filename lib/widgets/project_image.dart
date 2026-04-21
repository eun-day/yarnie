import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yarnie/theme/app_theme.dart';
import '../../core/utils/project_image_utils.dart';

/// 프로젝트 이미지를 표시하는 위젯
///
/// DB에 저장된 상대 경로를 절대 경로로 변환하여 이미지를 로드합니다.
/// 이미지가 없거나 로드 실패 시 [placeholder]를 표시합니다.
class ProjectImage extends StatelessWidget {
  final String? imagePath;
  final BoxFit fit;
  final Widget? placeholder;
  final double fallbackPadding;

  const ProjectImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.fallbackPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultImage = placeholder ??
        Container(
          color: AppColors.secondary,
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(fallbackPadding),
            child: Image.asset(
              'assets/splash_icon.png',
              fit: BoxFit.contain,
            ),
          ),
        );

    if (imagePath == null) {
      return defaultImage;
    }

    return FutureBuilder<String?>(
      future: ProjectImageUtils.toAbsolutePath(imagePath),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return defaultImage;
        }
        final absPath = snapshot.data!;
        return Image.file(
          File(absPath),
          fit: fit,
          errorBuilder: (_, __, ___) => defaultImage,
        );
      },
    );
  }
}
