import '../db/app_db.dart';

/// Session 상태를 UI에서 표시하기 위한 ViewModel
///
/// Session과 SessionSegment 데이터를 통합하여 UI에서 사용하기 쉽게 제공
class SessionViewModel {
  /// Session 데이터 (null이면 아직 작업 시작 안 함)
  final Session? session;

  /// SessionSegment 목록
  final List<SessionSegment> segments;

  /// 현재 진행 중인 시간 (실시간 업데이트용)
  final Duration currentDuration;

  const SessionViewModel({
    this.session,
    required this.segments,
    required this.currentDuration,
  });

  /// 아직 세션이 시작되지 않았는지 확인
  bool get notStarted => session == null;

  /// 세션이 진행 중인지 확인
  bool get isRunning => session?.status == SessionStatus2.running;

  /// 세션이 일시정지 상태인지 확인
  bool get isPaused => session?.status == SessionStatus2.paused;

  /// 총 작업 시간 (초 단위)
  int get totalDurationSeconds => session?.totalDurationSeconds ?? 0;

  /// 총 작업 시간 (Duration 객체)
  Duration get totalDuration => Duration(seconds: totalDurationSeconds);

  /// 세션 시작 시간
  DateTime? get startedAt => session?.startedAt;

  /// 현재 활성 Segment (진행 중일 때만)
  SessionSegment? get currentSegment {
    if (!isRunning || segments.isEmpty) return null;
    // endedAt이 null인 Segment가 현재 활성 Segment
    return segments.lastWhere(
      (s) => s.endedAt == null,
      orElse: () => segments.last,
    );
  }

  /// 완료된 Segment 목록
  List<SessionSegment> get completedSegments {
    return segments.where((s) => s.endedAt != null).toList();
  }

  /// 새로운 값으로 복사본 생성
  SessionViewModel copyWith({
    Session? session,
    List<SessionSegment>? segments,
    Duration? currentDuration,
  }) {
    return SessionViewModel(
      session: session ?? this.session,
      segments: segments ?? this.segments,
      currentDuration: currentDuration ?? this.currentDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SessionViewModel &&
        other.session == session &&
        other.currentDuration == currentDuration;
  }

  @override
  int get hashCode {
    return session.hashCode ^ currentDuration.hashCode;
  }

  @override
  String toString() {
    return 'SessionViewModel('
        'notStarted: $notStarted, '
        'isRunning: $isRunning, '
        'isPaused: $isPaused, '
        'totalDuration: $totalDuration, '
        'currentDuration: $currentDuration, '
        'segments: ${segments.length}'
        ')';
  }
}
