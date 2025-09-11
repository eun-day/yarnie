import 'package:drift/drift.dart';

/// 세션 상태를 나타내는 Enum
enum SessionStatus {
  paused,   // 0: 활성 세션, 시간 멈춤
  running,  // 1: 활성 세션, 시간 흐름
  stopped,  // 2: 세션 완결
}

/// Drift TypeConverter: DB(int) ↔ Dart(SessionStatus)
class SessionStatusConverter extends TypeConverter<SessionStatus, int> {
  const SessionStatusConverter();

  @override
  SessionStatus fromSql(int fromDb) {
    return SessionStatus.values[fromDb];
  }

  @override
  int toSql(SessionStatus value) => value.index;
}

