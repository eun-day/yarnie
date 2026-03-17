import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnie/core/providers/locale_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum TouchFeedbackType { vibration, sound, both, none }

class AppSettings {
  final bool screenAwake;
  final TouchFeedbackType touchFeedback;

  AppSettings({
    required this.screenAwake,
    required this.touchFeedback,
  });

  AppSettings copyWith({
    bool? screenAwake,
    TouchFeedbackType? touchFeedback,
  }) {
    return AppSettings(
      screenAwake: screenAwake ?? this.screenAwake,
      touchFeedback: touchFeedback ?? this.touchFeedback,
    );
  }
}

const _screenAwakeKey = 'app_screen_awake';
const _touchFeedbackKey = 'app_touch_feedback';

class SettingsNotifier extends Notifier<AppSettings> {
  late final SharedPreferences _prefs;

  @override
  AppSettings build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    final screenAwake = _prefs.getBool(_screenAwakeKey) ?? true;
    final touchFeedbackIndex = _prefs.getInt(_touchFeedbackKey) ?? TouchFeedbackType.vibration.index;
    
    // Ensure index is within range
    final safeTouchFeedbackIndex = touchFeedbackIndex < TouchFeedbackType.values.length 
        ? touchFeedbackIndex 
        : TouchFeedbackType.vibration.index;

    final settings = AppSettings(
      screenAwake: screenAwake,
      touchFeedback: TouchFeedbackType.values[safeTouchFeedbackIndex],
    );

    // Apply initial wakelock state
    _updateWakelock(screenAwake);

    return settings;
  }

  Future<void> setScreenAwake(bool value) async {
    state = state.copyWith(screenAwake: value);
    await _prefs.setBool(_screenAwakeKey, value);
    _updateWakelock(value);
  }

  void _updateWakelock(bool enable) {
    WakelockPlus.toggle(enable: enable);
  }

  Future<void> setTouchFeedback(TouchFeedbackType type) async {
    state = state.copyWith(touchFeedback: type);
    await _prefs.setInt(_touchFeedbackKey, type.index);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});
