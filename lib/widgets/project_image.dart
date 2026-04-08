import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/utils/project_image_utils.dart';

/// 프로젝트 이미지를 표시하는 위젯
///
/// DB에 저장된 상대 경로를 절대 경로로 변환하여 이미지를 로드합니다.
/// 이미지가 없거나 로드 실패 시 [placeholder]를 표시합니다.
class ProjectImage extends StatelessWidget {
  final String? imagePath;
  final BoxFit fit;
  final Widget? placeholder;

  const ProjectImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) {
      return placeholder ?? Container(color: const Color(0xFFD9D9D9));
    }

    return FutureBuilder<String?>(
      future: ProjectImageUtils.toAbsolutePath(imagePath),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return placeholder ?? Container(color: const Color(0xFFD9D9D9));
        }
        final absPath = snapshot.data!;
        return Image.file(
          File(absPath),
          fit: fit,
          errorBuilder: (_, __, ___) =>
              placeholder ?? Container(color: const Color(0xFFD9D9D9)),
        );
      },
    );
  }
}
