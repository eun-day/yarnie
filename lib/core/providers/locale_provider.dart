import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  auto,
  en,
  ko;

  Locale? get locale {
    switch (this) {
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.ko:
        return const Locale('ko');
      case AppLanguage.auto:
        return null;
    }
  }
}

const _languagePrefsKey = 'app_language_preference';

class LocaleNotifier extends Notifier<AppLanguage> {
  late final SharedPreferences _prefs;

  @override
  AppLanguage build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadPreference();
  }

  AppLanguage _loadPreference() {
    final savedName = _prefs.getString(_languagePrefsKey);
    try {
      return AppLanguage.values.firstWhere((e) => e.name == savedName);
    } catch (_) {
      return AppLanguage.auto;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (state == language) return;
    state = language;
    if (language == AppLanguage.auto) {
      await _prefs.remove(_languagePrefsKey);
    } else {
      await _prefs.setString(_languagePrefsKey, language.name);
    }
  }
}

// Provider for SharedPreferences instance. Must be overridden in ProviderScope if needed,
// but usually we can just initialize it in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final localeProvider = NotifierProvider<LocaleNotifier, AppLanguage>(() {
  return LocaleNotifier();
});
