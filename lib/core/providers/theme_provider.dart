import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnie/core/providers/locale_provider.dart';

enum AppThemeMode { light, dark, system }

const _themePrefsKey = 'app_theme_preference';

class ThemeNotifier extends Notifier<ThemeMode> {
  late final SharedPreferences _prefs;

  @override
  ThemeMode build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadPreference();
  }

  ThemeMode _loadPreference() {
    final savedTheme = _prefs.getString(_themePrefsKey);
    if (savedTheme == 'light') {
      return ThemeMode.light;
    } else if (savedTheme == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    switch (mode) {
      case ThemeMode.light:
        await _prefs.setString(_themePrefsKey, 'light');
        break;
      case ThemeMode.dark:
        await _prefs.setString(_themePrefsKey, 'dark');
        break;
      case ThemeMode.system:
        await _prefs.remove(_themePrefsKey);
        break;
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
