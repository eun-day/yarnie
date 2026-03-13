import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { auto, en, ko }

const _languagePrefsKey = 'app_language_preference';

class LocaleNotifier extends Notifier<AppLanguage> {
  late final SharedPreferences _prefs;

  @override
  AppLanguage build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadPreference();
  }

  AppLanguage _loadPreference() {
    final savedCode = _prefs.getString(_languagePrefsKey);
    if (savedCode == 'ko') {
      return AppLanguage.ko;
    } else if (savedCode == 'en') {
      return AppLanguage.en;
    } else {
      return AppLanguage.auto;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    switch (language) {
      case AppLanguage.ko:
        await _prefs.setString(_languagePrefsKey, 'ko');
        break;
      case AppLanguage.en:
        await _prefs.setString(_languagePrefsKey, 'en');
        break;
      case AppLanguage.auto:
        await _prefs.remove(_languagePrefsKey);
        break;
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
