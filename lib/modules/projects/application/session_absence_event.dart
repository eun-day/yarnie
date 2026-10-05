sealed class SessionAbsenceEvent {
  const SessionAbsenceEvent();
}

/// 앱이 화면에서 사라짐 (백그라운드 전환)
class AppWentToBackground extends SessionAbsenceEvent {
  const AppWentToBackground();
}

/// 앱이 다시 화면에 나타남 (포그라운드 복귀 또는 재실행)
class AppReturnedToForeground extends SessionAbsenceEvent {
  const AppReturnedToForeground();
}

/// 사용자가 앱을 떠나 있던 시간을 세션에 반영할지 정함
class AbsenceResolved extends SessionAbsenceEvent {
  final bool includeAbsence;
  const AbsenceResolved(this.includeAbsence);
}
