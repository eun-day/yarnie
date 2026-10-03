import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../db/app_db.dart';
import '../../../db/di.dart';
import 'session_absence_event.dart';
import 'session_absence_state.dart';

const _leftAtKey = 'session_left_app_at';

/// 앱 복귀 시 세션 시간 정산 (기획: Session 백그라운드 동작)
///
/// 앱을 떠나도 세션은 계속 기록된다. 3분 이하로 떠났다면 그대로 반영하고,
/// 그보다 오래 떠났다가 돌아오면(앱이 종료된 뒤 다시 켠 경우 포함) 그 시간을 반영할지 묻는다.
class SessionAbsenceNotifier extends Notifier<SessionAbsenceState> {
  static const askThreshold = Duration(minutes: 3);

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);
  AppDb get _db => ref.read(appDbProvider);

  @override
  SessionAbsenceState build() => const SessionAbsenceState();

  Future<void> onEvent(SessionAbsenceEvent event) async {
    switch (event) {
      case AppWentToBackground():
        await _prefs.setInt(_leftAtKey, DateTime.now().millisecondsSinceEpoch);
      case AppReturnedToForeground():
        await _checkAbsence();
      case AbsenceResolved(:final includeAbsence):
        await _resolve(includeAbsence);
    }
  }

  Future<void> _checkAbsence() async {
    if (state.pendingAbsence != null) return; // 이미 묻는 중
    final leftAt = _leftAt;
    if (leftAt == null) return;

    final absence = DateTime.now().difference(leftAt);
    if (absence <= askThreshold || (await _db.getRunningSessions()).isEmpty) {
      await _prefs.remove(_leftAtKey);
      return;
    }
    state = SessionAbsenceState(pendingAbsence: absence);
  }

  Future<void> _resolve(bool includeAbsence) async {
    final leftAt = _leftAt;
    if (!includeAbsence && leftAt != null) {
      // 반영하지 않음: 앱을 떠난 시점에 일시정지한 것으로 기록
      for (final session in await _db.getRunningSessions()) {
        await _db.pauseRunningSession(session.partId, at: leftAt);
      }
    }
    await _prefs.remove(_leftAtKey);
    state = const SessionAbsenceState();
  }

  DateTime? get _leftAt {
    final millis = _prefs.getInt(_leftAtKey);
    return millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
  }
}

final sessionAbsenceProvider =
    NotifierProvider<SessionAbsenceNotifier, SessionAbsenceState>(
      SessionAbsenceNotifier.new,
    );
