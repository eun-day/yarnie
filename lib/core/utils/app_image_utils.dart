import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// 앱 내 로컬 이미지 경로 관리 유틸리티
///
/// DB에는 상대 경로(예: 'project_images/123456.jpg' 또는 'stash_images/123456.jpg')만 저장하고,
/// 런타임에 Documents 디렉토리 경로를 조합하여 절대 경로를 생성합니다.
/// 이렇게 하면 앱 재설치 시 샌드박스 UUID가 변경되어도 이미지를 정상적으로 찾을 수 있습니다.
class AppImageUtils {
  static const _defaultSubDir = 'project_images';

  /// 앱 Documents 디렉토리 경로 (캐시)
  static String? _cachedDocPath;

  /// Documents 디렉토리 경로를 가져옵니다 (캐시 사용)
  static Future<String> _getDocPath() async {
    if (_cachedDocPath != null) return _cachedDocPath!;
    final appDir = await getApplicationDocumentsDirectory();
    _cachedDocPath = appDir.path;
    return _cachedDocPath!;
  }

  /// 상대 경로 → 절대 경로 변환
  /// DB에 저장된 상대 경로를 실제 파일 시스템 절대 경로로 변환합니다.
  /// null이면 null 반환.
  static Future<String?> toAbsolutePath(String? relativePath) async {
    if (relativePath == null) return null;
    // 이미 절대 경로인 경우 (하위 호환)
    if (relativePath.startsWith('/')) return relativePath;
    final docPath = await _getDocPath();
    return p.join(docPath, relativePath);
  }

  /// 이미지를 앱 내 영구 저장소로 복사하고 **상대 경로**를 반환
  ///
  /// [sourcePath]: image_picker가 반환한 임시 파일 경로
  /// [subDir]: 저장할 하위 디렉토리 명 (기본값: 'project_images')
  /// 반환: DB에 저장할 상대 경로 (예: 'project_images/1234567890.jpg')
  static Future<String> persistImage(String sourcePath, {String subDir = _defaultSubDir}) async {
    final docPath = await _getDocPath();
    final imageDir = Directory(p.join(docPath, subDir));

    // 이미 영구 저장소에 있는 파일이면 상대 경로로 변환하여 반환
    if (sourcePath.startsWith(imageDir.path)) {
      return p.relative(sourcePath, from: docPath);
    }

    // 디렉토리 생성
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // 고유 파일명 생성 (타임스탬프 + 확장자)
    final ext = p.extension(sourcePath).isNotEmpty
        ? p.extension(sourcePath)
        : '.jpg';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$ext';
    final destPath = p.join(imageDir.path, fileName);

    // 복사
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      // 복사할 파일이 디바이스 내에 존재하지 않는 경우(예: 옛날에 잘못 저장된 임시 경로 등),
      // 복사를 스킵하고 원래 경로를 반환하여 크래시를 방지합니다.
      return sourcePath;
    }
    await sourceFile.copy(destPath);

    // 상대 경로 반환
    return p.join(subDir, fileName);
  }

  /// 기존 이미지 파일 삭제 (상대 경로 또는 절대 경로 모두 처리)
  static Future<void> deleteImage(String? imagePath) async {
    if (imagePath == null) return;
    try {
      String absPath;
      if (imagePath.startsWith('/')) {
        absPath = imagePath;
      } else {
        final docPath = await _getDocPath();
        absPath = p.join(docPath, imagePath);
      }
      final file = File(absPath);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}
