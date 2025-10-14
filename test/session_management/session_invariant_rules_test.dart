import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('3.1 프로젝트별 단일 활성 세션 규칙 테스트', () {
    group('getActiveSession 메서드 정확성 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('should return null when no active session exists', () async {
        // Given - No sessions created

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNull);
      });

      test('should return running session as active', () async {
        // Given - Create running session
        final sessionId = await db.startSession(projectId: projectId);

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNotNull);
        expect(activeSession!.id, sessionId);
        expect(activeSession.status, SessionStatus.running);
        expect(activeSession.projectId, projectId);
      });

      test('should return paused session as active', () async {
        // Given - Create and pause session
        await db.startSession(projectId: projectId);
        await db.pauseSession(projectId: projectId);

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNotNull);
        expect(activeSession!.status, SessionStatus.paused);
        expect(activeSession.projectId, projectId);
      });

      test('should return null when only stopped sessions exist', () async {
        // Given - Create and stop session
        await db.startSession(projectId: projectId);
        await db.stopSession(projectId: projectId);

        // When
        final activeSession = await db.getActiveSession(projectId);

        // Then
        expect(activeSession, isNull);
      });

      test(
        'should return correct session among multiple stopped sessions',
        () async {
          // Given - Create multiple stopped sessions and one active
          await db.startSession(projectId: projectId);
          await db.stopSession(projectId: projectId);

          await db.startSession(projectId: projectId);
          await db.stopSession(projectId: projectId);

          final activeSessionId = await db.startSession(projectId: projectId);

          // When
          final activeSession = await db.getActiveSession(projectId);

          // Then
          expect(activeSession, isNotNull);
          expect(activeSession!.id, activeSessionId);
          expect(activeSession.status, SessionStatus.running);
        },
      );
    });

    group('활성 세션 존재 시 새 세션 시작 방지 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test(
        'should prevent starting new session when running session exists',
        () async {
          // Given - Create running session
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

          // Verify original session is unchanged
          final unchangedSession = await db.getActiveSession(projectId);
          expect(unchangedSession!.id, activeSession.id);
          expect(unchangedSession.status, SessionStatus.running);
        },
      );

      test(
        'should prevent starting new session when paused session exists',
        () async {
          // Given - Create and pause session
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

          // Verify original session is unchanged
          final unchangedSession = await db.getActiveSession(projectId);
          expect(unchangedSession!.id, activeSession.id);
          expect(unchangedSession.status, SessionStatus.paused);
        },
      );

      test(
        'should allow starting new session after stopping previous session',
        () async {
          // Given - Create and stop session
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
        },
      );

      test(
        'should allow starting sessions for different projects simultaneously',
        () async {
          // Given - Create second project
          final secondProjectId = await createTestProject(
            db,
            name: 'Second Project',
          );

          // When - Start sessions for both projects
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
        },
      );

      test(
        'should enforce single active session rule per project independently',
        () async {
          // Given - Create second project and start sessions for both
          final secondProjectId = await createTestProject(
            db,
            name: 'Second Project',
          );
          await db.startSession(projectId: projectId);
          await db.startSession(projectId: secondProjectId);

          // When & Then - Should prevent second session for first project
          expect(
            () => db.startSession(projectId: projectId),
            throwsA(isA<StateError>()),
          );

          // When & Then - Should prevent second session for second project
          expect(
            () => db.startSession(projectId: secondProjectId),
            throwsA(isA<StateError>()),
          );

          // Verify both original sessions still exist
          final firstSession = await db.getActiveSession(projectId);
          final secondSession = await db.getActiveSession(secondProjectId);
          expect(firstSession, isNotNull);
          expect(secondSession, isNotNull);
        },
      );
    });

    group('상태 전환 시 불변 조건 유지 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test(
        'should maintain single active session during pause operation',
        () async {
          // Given - Create running session
          final sessionId = await db.startSession(projectId: projectId);

          // When - Pause session
          await db.pauseSession(projectId: projectId);

          // Then - Should still have exactly one active session
          final activeSession = await db.getActiveSession(projectId);
          expect(activeSession, isNotNull);
          expect(activeSession!.id, sessionId);
          expect(activeSession.status, SessionStatus.paused);

          // Should still prevent new session creation
          expect(
            () => db.startSession(projectId: projectId),
            throwsA(isA<StateError>()),
          );
        },
      );

      test(
        'should maintain single active session during resume operation',
        () async {
          // Given - Create and pause session
          final sessionId = await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);

          // When - Resume session
          await db.resumeSession(projectId: projectId);

          // Then - Should still have exactly one active session
          final activeSession = await db.getActiveSession(projectId);
          expect(activeSession, isNotNull);
          expect(activeSession!.id, sessionId);
          expect(activeSession.status, SessionStatus.running);

          // Should still prevent new session creation
          expect(
            () => db.startSession(projectId: projectId),
            throwsA(isA<StateError>()),
          );
        },
      );

      test('should remove active session during stop operation', () async {
        // Given - Create running session
        await db.startSession(projectId: projectId);
        expect(await db.getActiveSession(projectId), isNotNull);

        // When - Stop session
        await db.stopSession(projectId: projectId);

        // Then - Should have no active session
        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession, isNull);

        // Should allow new session creation
        final newSessionId = await db.startSession(projectId: projectId);
        expect(newSessionId, greaterThan(0));
      });

      test(
        'should maintain invariant during multiple state transitions',
        () async {
          // Given - Create session
          final sessionId = await db.startSession(projectId: projectId);

          // When - Multiple transitions: running -> paused -> running -> paused -> stopped
          await db.pauseSession(projectId: projectId);
          var activeSession = await db.getActiveSession(projectId);
          expect(activeSession!.id, sessionId);
          expect(activeSession.status, SessionStatus.paused);

          await db.resumeSession(projectId: projectId);
          activeSession = await db.getActiveSession(projectId);
          expect(activeSession!.id, sessionId);
          expect(activeSession.status, SessionStatus.running);

          await db.pauseSession(projectId: projectId);
          activeSession = await db.getActiveSession(projectId);
          expect(activeSession!.id, sessionId);
          expect(activeSession.status, SessionStatus.paused);

          await db.stopSession(projectId: projectId);
          activeSession = await db.getActiveSession(projectId);
          expect(activeSession, isNull);

          // Then - Should allow new session after complete lifecycle
          final newSessionId = await db.startSession(projectId: projectId);
          expect(newSessionId, greaterThan(sessionId));
        },
      );
    });

    group('동시성 상황에서 중복 활성 세션 방지 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('should handle concurrent session creation attempts', () async {
        // Given - No active session
        expect(await db.getActiveSession(projectId), isNull);

        // When - Attempt to create sessions concurrently
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

        // Then - Only one should succeed
        expect(successCount, 1);
        expect(errorCount, 2);

        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession, isNotNull);
        expect(results.where((id) => id != null), hasLength(1));
      });

      test('should handle concurrent pause attempts on same session', () async {
        // Given - Create running session
        await db.startSession(projectId: projectId);

        // When - Attempt to pause concurrently
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

        // Then - Only one should succeed
        expect(successCount, 1);
        expect(errorCount, 2);

        final activeSession = await db.getActiveSession(projectId);
        expect(activeSession!.status, SessionStatus.paused);
      });

      test(
        'should handle concurrent operations on different projects',
        () async {
          // Given - Create multiple projects
          final projectIds = await Future.wait([
            createTestProject(db, name: 'Project 1'),
            createTestProject(db, name: 'Project 2'),
            createTestProject(db, name: 'Project 3'),
          ]);

          // When - Start sessions concurrently for different projects
          final futures = projectIds.map(
            (id) => db.startSession(projectId: id),
          );
          final sessionIds = await Future.wait(futures);

          // Then - All should succeed
          expect(sessionIds, hasLength(3));
          expect(sessionIds.every((id) => id > 0), true);

          // Verify each project has its own active session
          for (int i = 0; i < projectIds.length; i++) {
            final activeSession = await db.getActiveSession(projectIds[i]);
            expect(activeSession, isNotNull);
            expect(activeSession!.id, sessionIds[i]);
            expect(activeSession.projectId, projectIds[i]);
          }
        },
      );

      test(
        'should maintain consistency during mixed concurrent operations',
        () async {
          // Given - Create session
          await db.startSession(projectId: projectId);

          // When - Mix of concurrent operations
          final futures = [
            db.pauseSession(projectId: projectId),
            () async {
              try {
                await db.startSession(projectId: projectId);
              } catch (e) {
                // Expected to fail
              }
            }(),
            () async {
              try {
                await db.resumeSession(projectId: projectId);
              } catch (e) {
                // May fail depending on timing
              }
            }(),
          ];

          await Future.wait(futures);

          // Then - Should have exactly one active session in valid state
          final activeSession = await db.getActiveSession(projectId);
          expect(activeSession, isNotNull);
          expect([
            SessionStatus.running,
            SessionStatus.paused,
          ], contains(activeSession!.status));
        },
      );
    });
  });
}
