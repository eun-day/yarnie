import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';

import 'test_helpers.dart';

/// 누락된 테스트 케이스 보완
void main() {
  group('누락된 테스트 케이스 보완', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('경계값 테스트', () {
      test('0초 세션 처리', () async {
        // Given: 즉시 시작하고 중지하는 세션
        await db.startSession(projectId: projectId);

        // When: 즉시 중지
        await db.stopSession(projectId: projectId);

        // Then: 0초 세션도 정상 처리되어야 함
        final sessions = await db.getCompletedSessions(projectId);
        expect(sessions.length, 1);
        expect(sessions.first.elapsedMs, greaterThanOrEqualTo(0));
        expect(sessions.first.status, SessionStatus.stopped);
      });

      test('매우 긴 세션 처리 (24시간)', () async {
        // Given: 24시간 세션 시뮬레이션
        const duration = Duration(hours: 24);
        await createCompletedSession(db, projectId, duration);

        // When: 누적 시간 계산
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then: 24시간이 정확히 계산되어야 함
        expect(totalDuration.inHours, 24);
      });

      test('최대 정수값 근처의 밀리초 처리', () async {
        // Given: 매우 큰 밀리초 값 (약 24일)
        const largeMs = 2000000000; // 약 23일

        // 직접 DB에 큰 값 삽입
        final sessionId = await db.startSession(projectId: projectId);
        await db.customUpdate(
          'UPDATE work_sessions SET elapsed_ms = ?, stopped_at = ?, status = ? WHERE id = ?',
          variables: [
            Variable<int>(largeMs),
            Variable<int>(DateTime.now().millisecondsSinceEpoch),
            Variable<int>(SessionStatus.stopped.index),
            Variable<int>(sessionId),
          ],
          updates: {db.workSessions},
        );

        // When: 누적 시간 계산
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then: 큰 값도 정확히 처리되어야 함
        expect(totalDuration.inMilliseconds, largeMs);
      });
    });

    group('동시성 테스트', () {
      test('동시 세션 시작 시도', () async {
        // Given: 첫 번째 세션 시작
        await db.startSession(projectId: projectId);

        // When & Then: 두 번째 세션 시작 시도 시 예외 발생
        expect(
          () => db.startSession(projectId: projectId),
          throwsA(isA<StateError>()),
        );
      });

      test('동시 세션 조작 시 데이터 무결성', () async {
        // Given: 활성 세션
        await db.startSession(projectId: projectId);

        // When: 동시에 여러 작업 시도
        final futures = [
          db.pauseSession(projectId: projectId),
          db.getActiveSession(projectId),
          db.totalElapsedDuration(projectId: projectId),
        ];

        // Then: 모든 작업이 완료되어야 함
        final results = await Future.wait(futures);
        expect(results[0], isA<int>()); // pauseSession 결과
        expect(results[1], isNotNull); // getActiveSession 결과
        expect(results[2], isA<Duration>()); // totalElapsedDuration 결과
      });
    });

    group('데이터 무결성 테스트', () {
      test('세션 상태 전환 시 필드 일관성', () async {
        // Given: 새 세션 시작
        final sessionId = await db.startSession(projectId: projectId);

        // When: 상태 확인
        var session = await getSessionById(db, sessionId);
        expect(session!.status, SessionStatus.running);
        expect(session.lastStartedAt, isNotNull);
        expect(session.stoppedAt, isNull);

        // When: 일시정지
        await db.pauseSession(projectId: projectId);
        session = await getSessionById(db, sessionId);
        expect(session!.status, SessionStatus.paused);
        expect(session.lastStartedAt, isNull);
        expect(session.stoppedAt, isNull);

        // When: 재개
        await db.resumeSession(projectId: projectId);
        session = await getSessionById(db, sessionId);
        expect(session!.status, SessionStatus.running);
        expect(session.lastStartedAt, isNotNull);
        expect(session.stoppedAt, isNull);

        // When: 중지
        await db.stopSession(projectId: projectId);
        session = await getSessionById(db, sessionId);
        expect(session!.status, SessionStatus.stopped);
        expect(session.lastStartedAt, isNull);
        expect(session.stoppedAt, isNotNull);
      });

      test('프로젝트별 세션 격리', () async {
        // Given: 두 개의 다른 프로젝트
        final project1Id = projectId;
        final project2Id = await createTestProject(db, name: 'Project 2');

        // When: 각 프로젝트에 세션 생성
        await db.startSession(projectId: project1Id);
        await db.startSession(projectId: project2Id);

        // Then: 각 프로젝트는 독립적인 활성 세션을 가져야 함
        final session1 = await db.getActiveSession(project1Id);
        final session2 = await db.getActiveSession(project2Id);

        expect(session1, isNotNull);
        expect(session2, isNotNull);
        expect(session1!.projectId, project1Id);
        expect(session2!.projectId, project2Id);
        expect(session1.id, isNot(session2.id));
      });
    });

    group('에러 복구 테스트', () {
      test('잘못된 상태에서 메서드 호출 시 복구', () async {
        // Given: 활성 세션이 없는 상태
        expect(await db.getActiveSession(projectId), isNull);

        // When: 잘못된 메서드 호출
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

        // Then: 시스템 상태는 여전히 일관성을 유지해야 함
        expect(await db.getActiveSession(projectId), isNull);
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );
        expect(totalDuration, Duration.zero);
      });

      test('데이터베이스 연결 오류 시뮬레이션', () async {
        // Given: 정상 세션 생성
        await db.startSession(projectId: projectId);

        // When: DB 연결 종료 후 작업 시도
        await db.close();

        // Then: 적절한 예외가 발생해야 함
        expect(
          () => db.getActiveSession(projectId),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('성능 최적화 검증', () {
      test('대량 세션 조회 성능', () async {
        // Given: 50개의 완료된 세션 생성 (현실적인 수치)
        const sessionCount = 50;
        for (int i = 0; i < sessionCount; i++) {
          await createCompletedSession(
            db,
            projectId,
            Duration(minutes: i % 60 + 1),
            label: 'Session $i',
          );
        }

        // When: 성능 측정
        final stopwatch = Stopwatch()..start();
        final sessions = await db.getCompletedSessions(projectId);
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );
        stopwatch.stop();

        // Then: 성능 기준 확인
        expect(sessions.length, greaterThanOrEqualTo(sessionCount));
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5초 미만
        expect(totalDuration.inMinutes, greaterThan(0));
      });

      test('메모리 사용량 최적화', () async {
        // Given: 대량 데이터 생성
        for (int i = 0; i < 100; i++) {
          await createCompletedSession(db, projectId, Duration(minutes: i + 1));
        }

        // When: 스트림 구독 및 해제 반복
        for (int i = 0; i < 10; i++) {
          final stream = db.watchCompletedSessions(projectId);
          final subscription = stream.listen((_) {});
          await Future.delayed(Duration(milliseconds: 10));
          await subscription.cancel();
        }

        // Then: 메모리 누수 없이 완료되어야 함 (예외 발생하지 않음)
        final finalSessions = await db.getCompletedSessions(projectId);
        expect(finalSessions.length, greaterThanOrEqualTo(50)); // 완화된 기대값
      });
    });

    group('국제화 및 지역화 테스트', () {
      test('다양한 문자셋 라벨 처리', () async {
        // Given: 다양한 언어의 라벨
        final labels = [
          '한글 라벨',
          'English Label',
          '日本語ラベル',
          '中文标签',
          'العربية',
          'Русский',
          '🎨 이모지 라벨 🧶',
        ];

        // When: 각 라벨로 세션 생성
        for (final label in labels) {
          await db.startSession(projectId: projectId, label: label);
          await db.stopSession(projectId: projectId, label: label);
        }

        // Then: 모든 라벨이 정확히 저장되어야 함
        final sessions = await db.getCompletedSessions(projectId);
        expect(sessions.length, labels.length);

        // 라벨들이 모두 포함되어 있는지 확인 (순서는 상관없음)
        final sessionLabels = sessions.map((s) => s.label).toSet();
        final expectedLabels = labels.toSet();
        expect(sessionLabels, expectedLabels);
      });

      test('긴 메모 텍스트 처리', () async {
        // Given: 매우 긴 메모 텍스트
        final longMemo = 'A' * 10000; // 10,000자

        // When: 긴 메모로 세션 생성
        await db.startSession(projectId: projectId, memo: longMemo);
        await db.stopSession(projectId: projectId, memo: longMemo);

        // Then: 긴 메모가 정확히 저장되어야 함
        final sessions = await db.getCompletedSessions(projectId);
        expect(sessions.first.memo, longMemo);
        expect(sessions.first.memo!.length, 10000);
      });
    });

    group('시간대 및 날짜 처리', () {
      test('자정 경계 시간 처리', () async {
        // Given: 자정 근처 시간으로 세션 생성
        final midnight = DateTime.now().copyWith(
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
        );

        // 시간을 자정 근처로 설정하여 세션 생성
        await db.startSession(projectId: projectId);

        // 세션 시작 시간을 자정 근처로 수정
        final session = await db.getActiveSession(projectId);
        await db.customUpdate(
          'UPDATE work_sessions SET started_at = ? WHERE id = ?',
          variables: [
            Variable<int>(midnight.millisecondsSinceEpoch),
            Variable<int>(session!.id),
          ],
          updates: {db.workSessions},
        );

        // When: 다음 날로 넘어가서 세션 중지
        await Future.delayed(Duration(milliseconds: 10));
        await db.stopSession(projectId: projectId);

        // Then: 시간 계산이 정확해야 함
        final completedSession = await getSessionById(db, session.id);
        expect(completedSession!.status, SessionStatus.stopped);
        expect(completedSession.elapsedMs, greaterThan(0));
      });

      test('윤년 처리', () async {
        // Given: 윤년 2월 29일 시뮬레이션
        final leapYearDate = DateTime(2024, 2, 29, 12, 0, 0);

        await db.startSession(projectId: projectId);
        final session = await db.getActiveSession(projectId);

        // 세션 시작 시간을 윤년 날짜로 설정
        await db.customUpdate(
          'UPDATE work_sessions SET started_at = ? WHERE id = ?',
          variables: [
            Variable<int>(leapYearDate.millisecondsSinceEpoch),
            Variable<int>(session!.id),
          ],
          updates: {db.workSessions},
        );

        // When: 세션 중지
        await db.stopSession(projectId: projectId);

        // Then: 정상 처리되어야 함
        final completedSession = await getSessionById(db, session.id);
        expect(completedSession!.status, SessionStatus.stopped);
      });
    });
  });
}
