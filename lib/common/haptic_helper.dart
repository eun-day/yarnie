import 'package:flutter/services.dart';
import 'package:yarnie/core/providers/settings_provider.dart';

class HapticHelper {
  /// 설정된 피드백 타입에 따라 진동 또는 소리를 발생시킵니다.
  static Future<void> validateAndFeedback(TouchFeedbackType type) async {
    switch (type) {
      case TouchFeedbackType.vibration:
        await HapticFeedback.lightImpact();
        break;
      case TouchFeedbackType.sound:
        await SystemSound.play(SystemSoundType.click);
        break;
      case TouchFeedbackType.both:
        // 소리와 진동을 거의 동시에 발생
        await Future.wait([
          HapticFeedback.lightImpact(),
          SystemSound.play(SystemSoundType.click),
        ]);
        break;
      case TouchFeedbackType.none:
        break;
    }
  }
}
