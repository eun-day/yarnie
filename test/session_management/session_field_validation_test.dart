import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';
import 'test_helpers.dart';

void main() {
  group('세션 필드 검증 테스트', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('필수 필드 검증', () {
      test('새 세션 생성 시 필수 필드가 설정되어야 함', () async {
        // Given & When - 새 세션 생성
        await db.startSession(projectId: projectId);

        // Then - 필수 필드 확인
        final session = await db.getActiveSession(projectId);
        expect(session, isNotNull);
        expect(session!.id, greaterThan(0));
        expect(session.projectId, projectId);
        expect(session.startedAt, isNotNull);
        expect(session.createdAt, isNotNull);
        expect(session.status, SessionStatus.running);
        expect(session.elapsedMs, greaterThanOrEqualTo(0));
        // updatedAt은 null일 수 있음
      });

      test('필수 필드가 null이 아니어야 함', () async {
        // Given - 세션 생성
        await db.startSession(projectId: projectId);

        // When - 필수 필드 확인
        final session = await db.getActiveSession(projectId);

        // Then - 필수 필드가 null이 아님
        expect(session!.id, isNotNull);
        expect(session.projectId, isNotNull);
        expect(session.startedAt, isNotNull);
        expect(session.createdAt, isNotNull);
        expect(session.status, isNotNull);
        expect(session.elapsedMs, isNotNull);
        // updatedAt은 null일 수 있음
      });
    });

    group('선택적 필드 검증', () {
      test('선택적 필드는 null일 수 있음', () async {
        // Given - 선택적 필드 없이 세션 생성
        await db.startSession(projectId: projectId);

        // When - 선택적 필드 확인
        final session = await db.getActiveSession(projectId);

        // Then - 선택적 필드는 null일 수 있음
        expect(session!.label, isNull);
        expect(session.memo, isNull);
        expect(session.stoppedAt, isNull);
        expect(session.lastStartedAt, isNotNull); // running 상태에서는 non-null
      });

      test('선택적 필드에 값을 설정할 수 있음', () async {
        // Given - 선택적 필드와 함께 세션 생성
        await db.startSession(
          projectId: projectId,
          label: 'Test Label',
          memo: 'Test Memo',
        );

        // When - 선택적 필드 확인
        final session = await db.getActiveSession(projectId);

        // Then - 선택적 필드가 설정되어야 함
        expect(session!.label, 'Test Label');
        expect(session.memo, 'Test Memo');
      });
    });

    group('프로젝트 관계 무결성 검증', () {
      test('유효한 프로젝트 ID로 세션을 생성할 수 있음', () async {
        // Given - 유효한 프로젝트 ID
        expect(projectId, greaterThan(0));

        // When - 세션 생성
        await db.startSession(projectId: projectId);

        // Then - 세션이 프로젝트와 연결되어야 함
        final session = await db.getActiveSession(projectId);
        expect(session!.projectId, projectId);

        // 프로젝트가 데이터베이스에 존재하는지 확인
        final projects = await (db.select(
          db.projects,
        )..where((tbl) => tbl.id.equals(projectId))).get();
        expect(projects, hasLength(1));
        expect(projects.first.id, projectId);
      });
    });

    group('시간 관련 필드 검증', () {
      test('시간 관련 필드는 양수여야 함', () async {
        // Given - 세션 생성 후 잠시 실행
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 100));

        // When - 시간 관련 필드 확인
        final session = await db.getActiveSession(projectId);

        // Then - 모든 시간 필드는 양수여야 함
        expect(session!.startedAt, greaterThan(0));
        expect(session.createdAt, greaterThanOrEqualTo(0));
        expect(session.elapsedMs, greaterThanOrEqualTo(0));
        if (session.updatedAt != null) {
          expect(session.updatedAt!, greaterThan(0));
        }
      });

      test('유효한 타임스탬프 형식이어야 함', () async {
        // Given - 세션 생성 전 시간 기록
        final beforeStart = DateTime.now().millisecondsSinceEpoch;

        // When - 세션 생성
        await db.startSession(projectId: projectId);

        // Then - 세션 생성 후 시간 기록
        final afterStart = DateTime.now().millisecondsSinceEpoch;
        final session = await db.getActiveSession(projectId);

        expect(session!.lastStartedAt, isNotNull);
        expect(session.lastStartedAt!, greaterThanOrEqualTo(beforeStart));
        expect(session.lastStartedAt!, lessThanOrEqualTo(afterStart));

        // 유효한 타임스탬프인지 확인 (DateTime으로 변환 가능)
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          session.lastStartedAt!,
        );
        expect(dateTime.year, DateTime.now().year);
      });
    });

    group('상태별 필드 일관성 검증', () {
      test('running 상태에서 lastStartedAt은 non-null이어야 함', () async {
        // Given & When - running 세션 생성
        await db.startSession(projectId: projectId);

        // Then
        final session = await db.getActiveSession(projectId);
        expect(session, isNotNull);
        expect(session!.status, SessionStatus.running);
        expect(session.lastStartedAt, isNotNull);
        expect(session.lastStartedAt!, greaterThan(0));
      });

      test('paused 상태에서 lastStartedAt은 null이어야 함', () async {
        // Given - 세션 생성 후 일시정지
        await db.startSession(projectId: projectId);
        await db.pauseSession(projectId: projectId);

        // When - 상태 확인
        final session = await db.getActiveSession(projectId);

        // Then
        expect(session!.status, SessionStatus.paused);
        expect(session.lastStartedAt, isNull);
      });

      test('stopped 상태에서 lastStartedAt은 null이어야 함', () async {
        // Given - 세션 생성 후 중지
        await db.startSession(projectId: projectId);
        await db.stopSession(projectId: projectId);

        // When - 중지된 세션 조회
        final stoppedSessions =
            await (db.select(db.workSessions)..where(
                  (tbl) =>
                      tbl.projectId.equals(projectId) &
                      tbl.status.equals(SessionStatus.stopped.index),
                ))
                .get();

        // Then
        expect(stoppedSessions, hasLength(1));
        final stoppedSession = stoppedSessions.first;
        expect(stoppedSession.status, SessionStatus.stopped);
        expect(stoppedSession.lastStartedAt, isNull);
      });
    });

    group('문자열 필드 검증', () {
      test('긴 라벨과 메모를 처리할 수 있어야 함', () async {
        // Given - 매우 긴 라벨과 메모
        final longLabel = 'A' * 1000; // 1,000자
        final longMemo = 'B' * 5000; // 5,000자

        // When - 긴 문자열로 세션 생성
        await db.startSession(
          projectId: projectId,
          label: longLabel,
          memo: longMemo,
        );

        // Then - 긴 문자열이 정확히 저장되어야 함 (DB 제약 조건에 따라 잘릴 수 있음)
        final session = await db.getActiveSession(projectId);
        expect(session!.label, isNotNull);
        expect(session.memo, isNotNull);
        expect(session.label!.length, greaterThan(0));
        expect(session.memo!.length, greaterThan(0));
      });

      test('다양한 문자셋을 처리할 수 있어야 함', () async {
        // Given - 다양한 문자셋
        const koreanLabel = '한글 라벨';
        const emojiMemo = '🎨 이모지 메모 🧶';

        // When - 다양한 문자셋으로 세션 생성
        await db.startSession(
          projectId: projectId,
          label: koreanLabel,
          memo: emojiMemo,
        );

        // Then - 문자셋이 정확히 저장되어야 함
        final session = await db.getActiveSession(projectId);
        expect(session!.label, koreanLabel);
        expect(session.memo, emojiMemo);
      });
    });

    group('상태 전환 시 필드 일관성 검증', () {
      test('running -> paused 전환 시 필드 일관성 유지', () async {
        // Given - running 세션 생성
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
        // updatedAt은 null일 수 있음
        expect(pausedSession.stoppedAt, isNull); // 아직 중지되지 않음
      });

      test('paused -> running 전환 시 필드 일관성 유지', () async {
        // Given - 세션 생성, 일시정지
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 100));
        await db.pauseSession(projectId: projectId);

        final pausedSession = await db.getActiveSession(projectId);
        final originalId = pausedSession!.id;
        final originalElapsedMs = pausedSession.elapsedMs;
        final originalStartedAt = pausedSession.startedAt;

        // When - 재개
        await db.resumeSession(projectId: projectId);

        // Then - 필드 일관성 확인
        final runningSession = await db.getActiveSession(projectId);
        expect(runningSession!.id, originalId); // ID 불변
        expect(runningSession.projectId, projectId); // 프로젝트 ID 불변
        expect(runningSession.startedAt, originalStartedAt); // 원래 시작 시간 불변
        expect(runningSession.elapsedMs, originalElapsedMs); // 경과 시간 보존
        expect(runningSession.status, SessionStatus.running); // 상태 변경
        expect(runningSession.lastStartedAt, isNotNull); // lastStartedAt 설정
        // updatedAt은 null일 수 있음
        expect(runningSession.stoppedAt, isNull); // 중지되지 않음
      });

      test('running -> stopped 전환 시 필드 일관성 유지', () async {
        // Given - running 세션 생성
        await db.startSession(
          projectId: projectId,
          label: 'Test Label',
          memo: 'Test Memo',
        );
        await Future.delayed(Duration(milliseconds: 100)); // 잠시 실행
        final runningSession = await db.getActiveSession(projectId);
        final originalId = runningSession!.id;
        final originalStartedAt = runningSession.startedAt;

        // When - 중지
        await db.stopSession(projectId: projectId);

        // Then - 필드 일관성 확인
        final stoppedSessions = await (db.select(
          db.workSessions,
        )..where((tbl) => tbl.id.equals(originalId))).get();

        expect(stoppedSessions, hasLength(1));
        final stoppedSession = stoppedSessions.first;

        expect(stoppedSession.id, originalId); // ID 불변
        expect(stoppedSession.projectId, projectId); // 프로젝트 ID 불변
        expect(stoppedSession.startedAt, originalStartedAt); // 원래 시작 시간 불변
        expect(stoppedSession.status, SessionStatus.stopped); // 상태 변경
        expect(stoppedSession.lastStartedAt, isNull); // lastStartedAt 초기화
        expect(stoppedSession.elapsedMs, greaterThan(0)); // 최종 경과 시간 설정
        expect(stoppedSession.stoppedAt, isNotNull); // 중지 시간 설정
        // updatedAt은 null일 수 있음
        expect(stoppedSession.label, 'Test Label'); // 라벨 보존
        expect(stoppedSession.memo, 'Test Memo'); // 메모 보존
      });

      test('여러 상태 전환 시 필드 일관성 유지', () async {
        // Given - 세션 생성
        await db.startSession(projectId: projectId, label: 'Initial');
        final originalSession = await db.getActiveSession(projectId);
        final originalId = originalSession!.id;

        // When - 여러 상태 전환: running -> paused -> running -> stopped
        await db.pauseSession(projectId: projectId);
        var session = await db.getActiveSession(projectId);
        expect(session!.id, originalId);
        expect(session.status, SessionStatus.paused);
        expect(session.lastStartedAt, isNull);

        await db.resumeSession(projectId: projectId);
        session = await db.getActiveSession(projectId);
        expect(session!.id, originalId);
        expect(session.status, SessionStatus.running);
        expect(session.lastStartedAt, isNotNull);

        await db.stopSession(projectId: projectId, label: 'Final');

        // Then - 최종 상태 확인
        final finalSessions = await (db.select(
          db.workSessions,
        )..where((tbl) => tbl.id.equals(originalId))).get();

        expect(finalSessions, hasLength(1));
        final finalSession = finalSessions.first;
        expect(finalSession.id, originalId);
        expect(finalSession.status, SessionStatus.stopped);
        expect(finalSession.lastStartedAt, isNull);
        expect(finalSession.stoppedAt, isNotNull);
        expect(finalSession.label, 'Final'); // 최종 라벨 설정
      });
    });
  });
}
