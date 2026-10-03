class SessionAbsenceState {
  /// 반영 여부를 물어봐야 하는 이탈 시간 (null이면 물어볼 것 없음)
  final Duration? pendingAbsence;

  const SessionAbsenceState({this.pendingAbsence});
}
