import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';

import '../helpers/test_helpers.dart';

/// 전체 세션 라이프사이클 통합 테스트
void main() {
  group('전체 세션 라이프사이클 통합 테스트', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('화면 진입 → 세션 시작 → 일시정지 → 재개 → 완료 전체 플로우', () async {
      // Given: 기존 완료된 세션이 있는 상태 (2분)
      await createCompletedSession(db, projectId, Duration(minutes: 2));

      // 초기 누적 시간 확인
      final initialCumulative = await db.totalElapsedDuration(
        projectId: projectId,
      );
      expect(initialCumulative.inMinutes, 2);

      // 1. 세션 시작
      final sessionId = await db.startSession(projectId: projectId);

      // 세션이 시작되었는지 확인
      final activeSession1 = await db.getActiveSession(projectId);
      expect(activeSession1, isNotNull);
      expect(activeSession1!.status, SessionStatus.running);
      expect(activeSession1.lastStartedAt, isNotNull);

      // 시간 경과 시뮬레이션
      await Future.delayed(Duration(milliseconds: 100));

      // 2. 세션 일시정지
      final elapsedSec1 = await db.pauseSession(projectId: projectId);
      expect(elapsedSec1, greaterThanOrEqualTo(0));

      // 일시정지 상태 확인
      final pausedSession = await db.getActiveSession(projectId);
      expect(pausedSession, isNotNull);
      expect(pausedSession!.status, SessionStatus.paused);
      expect(pausedSession.lastStartedAt, isNull);
      expect(pausedSession.elapsedMs, greaterThanOrEqualTo(0));

      // 3. 세션 재개
      await db.resumeSession(projectId: projectId);

      // 재개 상태 확인
      final resumedSession = await db.getActiveSession(projectId);
      expect(resumedSession, isNotNull);
      expect(resumedSession!.status, SessionStatus.running);
      expect(resumedSession.lastStartedAt, isNotNull);

      // 추가 시간 경과
      await Future.delayed(Duration(milliseconds: 100));

      // 4. 세션 완료
      await db.stopSession(
        projectId: projectId,
        label: '테스트',
        memo: '통합 테스트 완료',
      );

      // 완료 후 상태 확인
      final activeSessionAfterComplete = await db.getActiveSession(projectId);
      expect(activeSessionAfterComplete, isNull);

      // 완료된 세션 확인
      final completedSession = await getSessionById(db, sessionId);
      expect(completedSession, isNotNull);
      expect(completedSession!.status, SessionStatus.stopped);
      expect(completedSession.label, '테스트');
      expect(completedSession.memo, '통합 테스트 완료');

      // 총 누적 시간 확인 (기존 2분 + 새 세션)
      final finalCumulative = await db.totalElapsedDuration(
        projectId: projectId,
      );
      expect(finalCumulative.inSeconds, greaterThanOrEqualTo(120)); // 2분 이상
    });

    test('여러 세션 생성 및 완료 후 누적 시간 정확성 테스트', () async {
      // Given: 여러 개의 완료된 세션 생성
      await createCompletedSession(
        db,
        projectId,
        Duration(minutes: 3),
        label: '세션1',
      );
      await createCompletedSession(
        db,
        projectId,
        Duration(minutes: 2),
        label: '세션2',
      );
      await createCompletedSession(
        db,
        projectId,
        Duration(seconds: 90),
        label: '세션3',
      );

      // 초기 누적 시간 확인 (3분 + 2분 + 1.5분 = 6.5분)
      final initialCumulative = await db.totalElapsedDuration(
        projectId: projectId,
      );
      expectDurationCloseTo(
        initialCumulative,
        Duration(minutes: 6, seconds: 30),
        Duration(seconds: 1),
      );

      // 새 세션 시작 및 완료
      await db.startSession(projectId: projectId, label: '새세션');
      await Future.delayed(Duration(milliseconds: 100));
      await db.stopSession(projectId: projectId, label: '새세션');

      // 최종 누적 시간 확인
      final finalCumulative = await db.totalElapsedDuration(
        projectId: projectId,
      );
      expect(finalCumulative.inSeconds, greaterThanOrEqualTo(390)); // 6.5분 이상

      // 완료된 세션 개수 확인
      final completedSessions = await db.getCompletedSessions(projectId);
      expect(completedSessions.length, 4); // 기존 3개 + 새로 생성한 1개
    });

    test('세션 초기화 및 복원 시나리오 테스트', () async {
      // Given: 기존 완료된 세션 (5분)
      await createCompletedSession(db, projectId, Duration(minutes: 5));

      // 초기 누적 시간 확인
      final initialCumulative = await db.totalElapsedDuration(
        projectId: projectId,
      );
      expect(initialCumulative.inMinutes, 5);

      // 새 세션 시작 및 일시정지
      await db.startSession(projectId: projectId);
      await Future.delayed(Duration(milliseconds: 100));
      await db.pauseSession(projectId: projectId);

      // 현재 활성 세션이 있는지 확인
      final activeSessionBeforeReset = await db.getActiveSession(projectId);
      expect(activeSessionBeforeReset, isNotNull);
      expect(activeSessionBeforeReset!.status, SessionStatus.paused);

      // 초기화 (활성 세션 삭제)
      await db.discardActiveSession(projectId: projectId);

      // 초기화 후 상태 확인
      final activeSessionAfterReset = await db.getActiveSession(projectId);
      expect(activeSessionAfterReset, isNull);

      // 총 누적 시간이 기존 완료된 세션의 시간으로 복원되었는지 확인
      final restoredCumulative = await db.totalElapsedDuration(
        projectId: projectId,
      );
      expect(restoredCumulative.inMinutes, 5);
    });

    test('라벨 변경 및 메모 추가를 포함한 완전한 워크플로우 테스트', () async {
      final labels = ['작업1', '작업2', '미분류'];
      final memos = ['첫 번째 작업 완료', '두 번째 작업 완료', null];

      // 각 라벨로 세션 생성 및 완료
      for (int i = 0; i < labels.length; i++) {
        await db.startSession(projectId: projectId, label: labels[i]);
        await Future.delayed(Duration(milliseconds: 50));
        await db.stopSession(
          projectId: projectId,
          label: labels[i],
          memo: memos[i],
        );
      }

      // 완료된 세션들 검증
      final completedSessions = await db.getCompletedSessions(projectId);
      expect(completedSessions.length, 3);

      // 각 세션의 라벨과 메모 확인
      for (int i = 0; i < labels.length; i++) {
        final session = completedSessions.firstWhere(
          (s) => s.label == labels[i],
        );
        expect(session.memo, memos[i]);
        expect(session.status, SessionStatus.stopped);
      }

      // 총 누적 시간 확인
      final totalDuration = await db.totalElapsedDuration(projectId: projectId);
      expect(totalDuration.inMilliseconds, greaterThanOrEqualTo(0)); // 0ms 이상
    });

    test('활성 세션 존재 시 이어하기/새로 시작 다이얼로그 시나리오', () async {
      // Given: 일시정지된 활성 세션 생성
      await db.startSession(projectId: projectId);
      await Future.delayed(Duration(milliseconds: 100));
      await db.pauseSession(projectId: projectId);

      final activeSession = await db.getActiveSession(projectId);
      expect(activeSession, isNotNull);
      expect(activeSession!.status, SessionStatus.paused);

      // When: 새 세션 시작 시도 (이어하기 선택)
      await db.resumeSession(projectId: projectId);

      // Then: 기존 세션이 재개되어야 함
      final resumedSession = await db.getActiveSession(projectId);
      expect(resumedSession, isNotNull);
      expect(resumedSession!.id, activeSession.id); // 같은 세션
      expect(resumedSession.status, SessionStatus.running);
      expect(resumedSession.lastStartedAt, isNotNull);

      // When: 새로 시작 선택 시나리오
      await db.pauseSession(projectId: projectId);

      // 기존 세션 중지하고 새 세션 시작
      await db.stopSession(projectId: projectId);

      // Then: 새로운 세션이 생성되어야 함
      final newSession = await db.getActiveSession(projectId);
      expect(newSession, isNotNull);
      expect(newSession!.id, isNot(activeSession.id)); // 다른 세션
      expect(newSession.status, SessionStatus.running);
    });

    test('복잡한 세션 라이프사이클 시나리오 - 여러 번의 일시정지/재개', () async {
      // Given: 빈 프로젝트
      expect(await db.getActiveSession(projectId), isNull);

      // 1. 세션 시작
      final sessionId = await db.startSession(projectId: projectId);
      await Future.delayed(Duration(milliseconds: 50));

      // 2. 첫 번째 일시정지
      final elapsed1 = await db.pauseSession(projectId: projectId);
      expect(elapsed1, greaterThanOrEqualTo(0));

      // 3. 재개
      await db.resumeSession(projectId: projectId);
      await Future.delayed(Duration(milliseconds: 50));

      // 4. 두 번째 일시정지
      final elapsed2 = await db.pauseSession(projectId: projectId);
      expect(elapsed2, greaterThanOrEqualTo(elapsed1));

      // 5. 다시 재개
      await db.resumeSession(projectId: projectId);
      await Future.delayed(Duration(milliseconds: 50));

      // 6. 최종 완료
      await db.stopSession(
        projectId: projectId,
        label: '복잡한 세션',
        memo: '여러 번 일시정지/재개',
      );

      // 검증
      final completedSession = await getSessionById(db, sessionId);
      expect(completedSession, isNotNull);
      expect(completedSession!.status, SessionStatus.stopped);
      expect(completedSession.label, '복잡한 세션');
      expect(completedSession.memo, '여러 번 일시정지/재개');
      expect(completedSession.elapsedMs, greaterThanOrEqualTo(0)); // 0ms 이상
      expect(completedSession.stoppedAt, isNotNull);

      // 활성 세션이 없어야 함
      expect(await db.getActiveSession(projectId), isNull);
    });

    test('동시성 및 데이터 무결성 테스트', () async {
      // Given: 여러 프로젝트 생성
      final projectIds = <int>[];
      for (int i = 0; i < 5; i++) {
        final pid = await createTestProject(db, name: 'Project $i');
        projectIds.add(pid);
      }

      // When: 각 프로젝트에서 동시에 세션 시작
      final futures = projectIds.map((pid) async {
        await db.startSession(projectId: pid);
        await Future.delayed(Duration(milliseconds: 10));
        await db.stopSession(projectId: pid, label: 'Concurrent Session');
        return await db.totalElapsedDuration(projectId: pid);
      }).toList();

      final results = await Future.wait(futures);

      // Then: 모든 프로젝트에서 정상적으로 세션이 완료되어야 함
      expect(results.length, projectIds.length);
      expect(results.every((duration) => duration.inMilliseconds >= 0), true);

      // 각 프로젝트의 활성 세션이 없어야 함
      for (final pid in projectIds) {
        expect(await db.getActiveSession(pid), isNull);
      }
    });

    test('에러 복구 및 예외 처리 테스트', () async {
      // Given: 활성 세션이 없는 상태
      expect(await db.getActiveSession(projectId), isNull);

      // When & Then: 잘못된 메서드 호출 시 예외 발생
      expect(
        () => db.pauseSession(projectId: projectId),
        throwsA(isA<StateError>()),
      );
      expect(
        () => db.resumeSession(projectId: projectId),
        throwsA(isA<StateError>()),
      );
      expect(
        () => db.stopSession(projectId: projectId),
        throwsA(isA<StateError>()),
      );

      // 시스템 상태는 여전히 일관성을 유지해야 함
      expect(await db.getActiveSession(projectId), isNull);
      final totalDuration = await db.totalElapsedDuration(projectId: projectId);
      expect(totalDuration, Duration.zero);

      // 정상적인 세션 생성 후 중복 시작 시도
      await db.startSession(projectId: projectId);
      expect(
        () => db.startSession(projectId: projectId),
        throwsA(isA<StateError>()),
      );

      // 정리
      await db.stopSession(projectId: projectId);
    });

    test('성능 및 확장성 테스트', () async {
      // Given: 대량 세션 생성
      const sessionCount = 50;

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < sessionCount; i++) {
        await db.startSession(projectId: projectId, label: 'Session $i');
        await db.stopSession(projectId: projectId, label: 'Session $i');
      }

      stopwatch.stop();

      // When: 성능 측정
      final sessions = await db.getCompletedSessions(projectId);
      final totalDuration = await db.totalElapsedDuration(projectId: projectId);

      // Then: 성능 기준 확인
      expect(sessions.length, sessionCount);
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5초 미만
      expect(totalDuration.inMilliseconds, greaterThanOrEqualTo(0));

      print('대량 세션 처리 시간: ${stopwatch.elapsedMilliseconds}ms');
      print('평균 세션 처리 시간: ${stopwatch.elapsedMilliseconds / sessionCount}ms');
    });
  });
}
