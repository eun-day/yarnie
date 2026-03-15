import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnie/core/providers/locale_provider.dart';

enum LengthUnit { cm, inch }

const _lengthUnitPrefsKey = 'app_length_unit_preference';

class LengthUnitNotifier extends Notifier<LengthUnit> {
  late final SharedPreferences _prefs;

  @override
  LengthUnit build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadPreference();
  }

  LengthUnit _loadPreference() {
    final savedUnit = _prefs.getString(_lengthUnitPrefsKey);
    if (savedUnit == 'inch') {
      return LengthUnit.inch;
    } else {
      return LengthUnit.cm;
    }
  }

  Future<void> setLengthUnit(LengthUnit unit) async {
    state = unit;
    await _prefs.setString(_lengthUnitPrefsKey, unit.name);
  }
}

final lengthUnitProvider = NotifierProvider<LengthUnitNotifier, LengthUnit>(() {
  return LengthUnitNotifier();
});
