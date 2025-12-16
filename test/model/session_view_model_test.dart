import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_view_model.dart';

void main() {
  group('SessionViewModel', () {
    test('notStarted - 세션이 없을 때', () {
      // Given
      final viewModel = SessionViewModel(
        session: null,
        segments: [],
        currentDuration: Duration.zero,
      );

      // Then
      expect(viewModel.notStarted, true);
      expect(viewModel.isRunning, false);
      expect(viewModel.isPaused, false);
    });

    test('isRunning - 세션이 진행 중일 때', () {
      // Given
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: DateTime.now(),
        totalDurationSeconds: 100,
        status: SessionStatus2.running,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final viewModel = SessionViewModel(
        session: session,
        segments: [],
        currentDuration: const Duration(seconds: 100),
      );

      // Then
      expect(viewModel.notStarted, false);
      expect(viewModel.isRunning, true);
      expect(viewModel.isPaused, false);
    });

    test('isPaused - 세션이 일시정지 상태일 때', () {
      // Given
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: DateTime.now(),
        totalDurationSeconds: 100,
        status: SessionStatus2.paused,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final viewModel = SessionViewModel(
        session: session,
        segments: [],
        currentDuration: const Duration(seconds: 100),
      );

      // Then
      expect(viewModel.notStarted, false);
      expect(viewModel.isRunning, false);
      expect(viewModel.isPaused, true);
    });

    test('totalDuration - 총 작업 시간', () {
      // Given
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: DateTime.now(),
        totalDurationSeconds: 3600, // 1시간
        status: SessionStatus2.paused,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final viewModel = SessionViewModel(
        session: session,
        segments: [],
        currentDuration: Duration.zero,
      );

      // Then
      expect(viewModel.totalDurationSeconds, 3600);
      expect(viewModel.totalDuration, const Duration(hours: 1));
    });

    test('currentSegment - 현재 활성 Segment', () {
      // Given
      final now = DateTime.now();
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: now,
        totalDurationSeconds: 100,
        status: SessionStatus2.running,
        createdAt: now,
        updatedAt: null,
      );
      final segments = [
        SessionSegment(
          id: 1,
          sessionId: 1,
          partId: 10,
          startedAt: now.subtract(const Duration(minutes: 10)),
          endedAt: now.subtract(const Duration(minutes: 5)),
          durationSeconds: 300,
          startCount: 0,
          endCount: 5,
          reason: SegmentReason.pause,
          createdAt: now,
        ),
        SessionSegment(
          id: 2,
          sessionId: 1,
          partId: 10,
          startedAt: now.subtract(const Duration(minutes: 5)),
          endedAt: null, // 현재 진행 중
          durationSeconds: null,
          startCount: 5,
          endCount: null,
          reason: SegmentReason.resume,
          createdAt: now,
        ),
      ];
      final viewModel = SessionViewModel(
        session: session,
        segments: segments,
        currentDuration: const Duration(minutes: 5),
      );

      // Then
      expect(viewModel.currentSegment, isNotNull);
      expect(viewModel.currentSegment?.id, 2);
      expect(viewModel.currentSegment?.endedAt, isNull);
    });

    test('currentSegment - 일시정지 상태일 때는 null', () {
      // Given
      final now = DateTime.now();
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: now,
        totalDurationSeconds: 100,
        status: SessionStatus2.paused,
        createdAt: now,
        updatedAt: null,
      );
      final segments = [
        SessionSegment(
          id: 1,
          sessionId: 1,
          partId: 10,
          startedAt: now.subtract(const Duration(minutes: 10)),
          endedAt: now.subtract(const Duration(minutes: 5)),
          durationSeconds: 300,
          startCount: 0,
          endCount: 5,
          reason: SegmentReason.pause,
          createdAt: now,
        ),
      ];
      final viewModel = SessionViewModel(
        session: session,
        segments: segments,
        currentDuration: const Duration(minutes: 5),
      );

      // Then
      expect(viewModel.currentSegment, isNull);
    });

    test('completedSegments - 완료된 Segment 목록', () {
      // Given
      final now = DateTime.now();
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: now,
        totalDurationSeconds: 600,
        status: SessionStatus2.running,
        createdAt: now,
        updatedAt: null,
      );
      final segments = [
        SessionSegment(
          id: 1,
          sessionId: 1,
          partId: 10,
          startedAt: now.subtract(const Duration(minutes: 20)),
          endedAt: now.subtract(const Duration(minutes: 15)),
          durationSeconds: 300,
          startCount: 0,
          endCount: 5,
          reason: SegmentReason.pause,
          createdAt: now,
        ),
        SessionSegment(
          id: 2,
          sessionId: 1,
          partId: 10,
          startedAt: now.subtract(const Duration(minutes: 15)),
          endedAt: now.subtract(const Duration(minutes: 10)),
          durationSeconds: 300,
          startCount: 5,
          endCount: 10,
          reason: SegmentReason.pause,
          createdAt: now,
        ),
        SessionSegment(
          id: 3,
          sessionId: 1,
          partId: 10,
          startedAt: now.subtract(const Duration(minutes: 10)),
          endedAt: null, // 현재 진행 중
          durationSeconds: null,
          startCount: 10,
          endCount: null,
          reason: SegmentReason.resume,
          createdAt: now,
        ),
      ];
      final viewModel = SessionViewModel(
        session: session,
        segments: segments,
        currentDuration: const Duration(minutes: 10),
      );

      // Then
      expect(viewModel.completedSegments.length, 2);
      expect(viewModel.completedSegments[0].id, 1);
      expect(viewModel.completedSegments[1].id, 2);
    });

    test('copyWith로 값 변경', () {
      // Given
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: DateTime.now(),
        totalDurationSeconds: 100,
        status: SessionStatus2.running,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final viewModel = SessionViewModel(
        session: session,
        segments: [],
        currentDuration: const Duration(seconds: 100),
      );

      // When
      final updated = viewModel.copyWith(
        currentDuration: const Duration(seconds: 200),
      );

      // Then
      expect(updated.session, session);
      expect(updated.currentDuration, const Duration(seconds: 200));
    });

    test('startedAt - 세션 시작 시간', () {
      // Given
      final startTime = DateTime(2024, 1, 1, 10, 0);
      final session = Session(
        id: 1,
        partId: 10,
        startedAt: startTime,
        totalDurationSeconds: 100,
        status: SessionStatus2.running,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final viewModel = SessionViewModel(
        session: session,
        segments: [],
        currentDuration: Duration.zero,
      );

      // Then
      expect(viewModel.startedAt, startTime);
    });

    test('startedAt - 세션이 없을 때는 null', () {
      // Given
      final viewModel = SessionViewModel(
        session: null,
        segments: [],
        currentDuration: Duration.zero,
      );

      // Then
      expect(viewModel.startedAt, isNull);
    });
  });
}
