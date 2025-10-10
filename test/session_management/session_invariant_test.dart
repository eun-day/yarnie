import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('세션 상태 불변 조건 및 데이터 무결성 테스트', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('프로젝트별 단일 활성 세션 규칙 테스트', () {
      test('활성 세션이 없을 때 null 반환', () async {
        // Given - 세션이 없는 상태

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNull);
      });

      test('실행 중인 세션을 활성 세션으로 반환', () async {
        // Given - 실행 중인 세션 생성
        final sessionId = await db.startSession(projectId: projectId);

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNotNull);
        expect(activeSession!.id, sessionId);
        expect(activeSession.status, SessionStatus.running);
        expect(activeSession.projectId, projectId);
      });

      test('일시정지된 세션을 활성 세션으로 반환', () async {
        // Given - 세션 생성 후 일시정지
        await db.startSession(projectId: projectId);
        await db.pauseSession(projectId: projectId);

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNotNull);
        expect(activeSession!.status, SessionStatus.paused);
        expect(activeSession.projectId, projectId);
      });

      test('중지된 세션만 있을 때 null 반환', () async {
        // Given - 세션 생성 후 중지
        await db.startSession(projectId: projectId);
        await db.stopSession(projectId: projectId);

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNull);
      });

      test('활성 세션 존재 시 새 세션 시작 방지', () async {
        // Given - 실행 중인 세션 생성
        await db.startSession(projectId: projectId);
        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession!.status, SessionStatus.running);

        // When & Then
        expect(
          () => db.startSession(projectId: projectId),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('활성 세션이 이미 존재합니다'),
            ),
          ),
        );
      });

      test('일시정지된 세션 존재 시 새 세션 시작 방지', () async {
        // Given - 세션 생성 후 일시정지
        await db.startSession(projectId: projectId);
        await db.pauseSession(projectId: projectId);
        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession!.status, SessionStatus.paused);

        // When & Then
        expect(
          () => db.startSession(projectId: projectId),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('활성 세션이 이미 존재합니다'),
            ),
          ),
        );
      });

      test('세션 중지 후 새 세션 시작 허용', () async {
        // Given - 세션 생성 후 중지
        await db.startSession(projectId: projectId);
        await db.stopSession(projectId: projectId);
        expect(await db.getActiveSession(projectId), isNull);

        // When
        final newSessionId = await db.startSession(projectId: projectId);

        // Then
        expect(newSessionId, greaterThan(0));
        final newSession = await db.getActiveSession(projectId);
        expect(newSession, isNotNull);
        expect(newSession!.id, newSessionId);
        expect(newSession.status, SessionStatus.running);
      });

      test('다른 프로젝트에서 동시 세션 시작 허용', () async {
        // Given - 두 번째 프로젝트 생성
        final secondProjectId = await createTestProject(
          db,
          name: 'Second Project',
        );

        // When - 두 프로젝트에서 세션 시작
        final firstSessionId = await db.startSession(projectId: projectId);
        final secondSessionId = await db.startSession(
          projectId: secondProjectId,
        );

        // Then
        expect(firstSessionId, greaterThan(0));
        expect(secondSessionId, greaterThan(0));
        expect(firstSessionId, isNot(secondSessionId));

        final firstSession = await db.getActiveSession(projectId);
        final secondSession = await db.getActiveSession(secondProjectId);

        expect(firstSession, isNotNull);
        expect(secondSession, isNotNull);
        expect(firstSession!.projectId, projectId);
        expect(secondSession!.projectId, secondProjectId);
        expect(firstSession.status, SessionStatus.running);
        expect(secondSession.status, SessionStatus.running);
      });
    });

    group('세션 상태별 필드 검증 테스트', () {
      test('실행 중 상태에서 lastStartedAt 필수', () async {
        // Given & When - 실행 중인 세션 생성
        await db.startSession(projectId: projectId);

        // Then
        final session = await db.getActiveSession(projectId);
        expect(session, isNotNull);
        expect(session!.status, SessionStatus.running);
        expect(session.lastStartedAt, isNotNull);
        expect(session.lastStartedAt!, greaterThan(0));
      });

      test('재개 시 lastStartedAt 설정', () async {
        // Given - 세션 생성 후 일시정지
        await db.startSession(projectId: projectId);
        await db.pauseSession(projectId: projectId);

        var session = await db.getActiveSession(projectId);
        expect(session!.status, SessionStatus.paused);
        expect(session.lastStartedAt, isNull);

        // When - 재개
        await db.resumeSession(projectId: projectId);

        // Then
        session = await db.getActiveSession(projectId);
        expect(session!.status, SessionStatus.running);
        expect(session.lastStartedAt, isNotNull);
        expect(session.lastStartedAt!, greaterThan(0));
      });

      test('일시정지 상태에서 lastStartedAt null', () async {
        // Given - 세션 생성 후 일시정지
        await db.startSession(projectId: projectId);
        var session = await db.getActiveSession(projectId);
        expect(session!.lastStartedAt, isNotNull); // 초기에는 설정됨

        // When - 일시정지
        await db.pauseSession(projectId: projectId);

        // Then
        session = await db.getActiveSession(projectId);
        expect(session!.status, SessionStatus.paused);
        expect(session.lastStartedAt, isNull);
      });

      test('중지 상태에서 lastStartedAt null', () async {
        // Given - 실행 중인 세션 생성
        await db.startSession(projectId: projectId);
        var session = await db.getActiveSession(projectId);
        expect(session!.lastStartedAt, isNotNull); // 초기에는 설정됨

        // When - 중지
        await db.stopSession(projectId: projectId);

        // Then - 중지된 세션 조회
        final stoppedSessions =
            await (db.select(db.workSessions)..where(
                  (tbl) =>
                      tbl.projectId.equals(projectId) &
                      tbl.status.equals(SessionStatus.stopped.index),
                ))
                .get();

        expect(stoppedSessions, hasLength(1));
        final stoppedSession = stoppedSessions.first;
        expect(stoppedSession.status, SessionStatus.stopped);
        expect(stoppedSession.lastStartedAt, isNull);
      });

      test('상태 전환 시 필드 일관성 유지', () async {
        // Given - 세션 생성
        await db.startSession(projectId: projectId);
        final runningSession = await db.getActiveSession(projectId);
        final originalId = runningSession!.id;
        final originalStartedAt = runningSession.startedAt;
        final originalCreatedAt = runningSession.createdAt;

        // When - 일시정지
        await db.pauseSession(projectId: projectId);

        // Then - 필드 일관성 확인
        final pausedSession = await db.getActiveSession(projectId);
        expect(pausedSession!.id, originalId); // ID 불변
        expect(pausedSession.projectId, projectId); // 프로젝트 ID 불변
        expect(pausedSession.startedAt, originalStartedAt); // 시작 시간 불변
        expect(pausedSession.createdAt, originalCreatedAt); // 생성 시간 불변
        expect(pausedSession.status, SessionStatus.paused); // 상태 변경
        expect(pausedSession.lastStartedAt, isNull); // lastStartedAt 초기화
        expect(pausedSession.elapsedMs, greaterThanOrEqualTo(0)); // 경과 시간 누적
        expect(pausedSession.updatedAt, isNotNull); // 업데이트 시간 설정
        expect(pausedSession.stoppedAt, isNull); // 아직 중지되지 않음
      });
    });

    group('동시성 테스트', () {
      test('동시 세션 생성 시도 시 하나만 성공', () async {
        // Given - 활성 세션 없음
        expect(await db.getActiveSession(projectId), isNull);

        // When - 동시에 세션 생성 시도
        final futures = List.generate(
          3,
          (index) => db.startSession(projectId: projectId),
        );

        var successCount = 0;
        var errorCount = 0;
        final results = await Future.wait(
          futures.map((future) async {
            try {
              final sessionId = await future;
              successCount++;
              return sessionId;
            } catch (e) {
              errorCount++;
              return null;
            }
          }),
        );

        // Then - 하나만 성공
        expect(successCount, 1);
        expect(errorCount, 2);

        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession, isNotNull);
        expect(results.where((id) => id != null), hasLength(1));
      });

      test('동시 일시정지 시도 시 하나만 성공', () async {
        // Given - 실행 중인 세션 생성
        await db.startSession(projectId: projectId);

        // When - 동시에 일시정지 시도
        final futures = List.generate(
          3,
          (index) => db.pauseSession(projectId: projectId),
        );

        var successCount = 0;
        var errorCount = 0;
        await Future.wait(
          futures.map((future) async {
            try {
              await future;
              successCount++;
            } catch (e) {
              errorCount++;
            }
          }),
        );

        // Then - 하나만 성공
        expect(successCount, 1);
        expect(errorCount, 2);

        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession!.status, SessionStatus.paused);
      });
    });
  });
}
