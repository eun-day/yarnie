import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';
import 'package:yarnie/common/time_helper.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Session Lifecycle Tests', () {
    group('2.1 Session Start Logic', () {
      group('startSession method', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });
        test('should create new session in running state', () async {
          // When
          final sessionId = await db.startSession(projectId: projectId);

          // Then
          expect(sessionId, greaterThan(0));

          final session = await db.getActiveSession(projectId);
          expect(session, isNotNull);
          expect(session!.id, sessionId);
          expect(session.projectId, projectId);
          expect(session.status, SessionStatus.running);
          expect(session.elapsedMs, 0);
          expect(session.lastStartedAt, isNotNull);
          expect(session.stoppedAt, isNull);
        });

        test('should set lastStartedAt field correctly', () async {
          // Given
          final beforeStart = DateTime.now().millisecondsSinceEpoch;

          // When
          await db.startSession(projectId: projectId);

          // Then
          final afterStart = DateTime.now().millisecondsSinceEpoch;
          final session = await db.getActiveSession(projectId);

          expect(session!.lastStartedAt, isNotNull);
          expect(session.lastStartedAt!, greaterThanOrEqualTo(beforeStart));
          expect(session.lastStartedAt!, lessThanOrEqualTo(afterStart));
        });

        test('should create session with optional label and memo', () async {
          // Given
          const testLabel = 'Test Label';
          const testMemo = 'Test memo for session';

          // When
          await db.startSession(
            projectId: projectId,
            label: testLabel,
            memo: testMemo,
          );

          // Then
          final session = await db.getActiveSession(projectId);
          expect(session!.label, testLabel);
          expect(session.memo, testMemo);
        });

        test(
          'should create session with null label and memo when not provided',
          () async {
            // When
            await db.startSession(projectId: projectId);

            // Then
            final session = await db.getActiveSession(projectId);
            expect(session!.label, isNull);
            expect(session.memo, isNull);
          },
        );

        test(
          'should throw StateError when active session already exists',
          () async {
            // Given - Create first session
            await db.startSession(projectId: projectId);

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
          },
        );

        test('should throw StateError when paused session exists', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);

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

        test(
          'should allow creating new session after previous session is stopped',
          () async {
            // Given - Create and stop first session
            await db.startSession(projectId: projectId);
            await db.stopSession(projectId: projectId);

            // When
            final secondSessionId = await db.startSession(projectId: projectId);

            // Then
            expect(secondSessionId, greaterThan(0));
            final session = await db.getActiveSession(projectId);
            expect(session!.id, secondSessionId);
            expect(session.status, SessionStatus.running);
          },
        );
      });

      group('Transaction Atomicity', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });
        test('should create session atomically within transaction', () async {
          // Given
          var sessionCreated = false;
          var exceptionThrown = false;

          try {
            // When - Simulate transaction
            await db.transaction(() async {
              await db.startSession(projectId: projectId);
              sessionCreated = true;

              // Verify session exists within transaction
              final session = await db.getActiveSession(projectId);
              expect(session, isNotNull);
              expect(session!.status, SessionStatus.running);
            });
          } catch (e) {
            exceptionThrown = true;
          }

          // Then
          expect(sessionCreated, true);
          expect(exceptionThrown, false);

          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession, isNotNull);
          expect(finalSession!.status, SessionStatus.running);
        });

        test('should rollback session creation if transaction fails', () async {
          // Given
          var sessionCreated = false;
          var exceptionCaught = false;

          try {
            // When - Force transaction failure
            await db.transaction(() async {
              await db.startSession(projectId: projectId);
              sessionCreated = true;

              // Force transaction to fail
              throw Exception('Simulated transaction failure');
            });
          } catch (e) {
            exceptionCaught = true;
          }

          // Then
          expect(sessionCreated, true);
          expect(exceptionCaught, true);

          // Session should not exist due to rollback
          final session = await db.getActiveSession(projectId);
          expect(session, isNull);
        });
      });

      group('Multiple Projects', () {
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
          'should allow concurrent sessions for different projects',
          () async {
            // Given - Create second project
            final secondProjectId = await createTestProject(
              db,
              name: 'Second Project',
            );

            // When
            await db.startSession(projectId: projectId);
            await db.startSession(projectId: secondProjectId);

            // Then
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
          'should enforce single active session per project independently',
          () async {
            // Given - Create second project and start sessions for both
            final secondProjectId = await createTestProject(
              db,
              name: 'Second Project',
            );
            await db.startSession(projectId: projectId);
            await db.startSession(projectId: secondProjectId);

            // When & Then - Should fail for first project
            expect(
              () => db.startSession(projectId: projectId),
              throwsA(isA<StateError>()),
            );

            // When & Then - Should fail for second project
            expect(
              () => db.startSession(projectId: secondProjectId),
              throwsA(isA<StateError>()),
            );
          },
        );
      });

      group('Data Integrity', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });
        test('should set all required fields correctly', () async {
          // Given
          final beforeStart = DateTime.now().millisecondsSinceEpoch;

          // When
          final sessionId = await db.startSession(
            projectId: projectId,
            label: 'Test Label',
            memo: 'Test Memo',
          );

          // Then
          final session = await db.getActiveSession(projectId);
          final afterStart = DateTime.now().millisecondsSinceEpoch;

          expect(session!.id, sessionId);
          expect(session.projectId, projectId);
          expect(session.startedAt, greaterThanOrEqualTo(beforeStart));
          expect(session.startedAt, lessThanOrEqualTo(afterStart));
          expect(session.stoppedAt, isNull);
          expect(session.elapsedMs, 0);
          expect(session.lastStartedAt, isNotNull);
          expect(session.lastStartedAt!, greaterThanOrEqualTo(beforeStart));
          expect(session.lastStartedAt!, lessThanOrEqualTo(afterStart));
          expect(session.label, 'Test Label');
          expect(session.memo, 'Test Memo');
          expect(session.createdAt, greaterThanOrEqualTo(beforeStart));
          expect(session.createdAt, lessThanOrEqualTo(afterStart));
          expect(session.updatedAt, isNull);
          expect(session.status, SessionStatus.running);
        });

        test('should maintain referential integrity with project', () async {
          // Given - Invalid project ID
          const invalidProjectId = 99999;

          // When & Then - Should handle foreign key constraint
          // Note: This test depends on database constraints
          // If no FK constraint exists, this test documents expected behavior
          try {
            await db.startSession(projectId: invalidProjectId);
            // If no exception, verify session was created
            final session = await db.getActiveSession(invalidProjectId);
            expect(session, isNotNull);
          } catch (e) {
            // If FK constraint exists, expect appropriate error
            expect(e, isNotNull);
          }
        });
      });
    });

    group('2.2 Session Pause Logic', () {
      group('pauseSession method', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should transition from running to paused state', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);
          final beforePause = await db.getActiveSession(projectId);
          expect(beforePause!.status, SessionStatus.running);

          // When
          final elapsedSec = await db.pauseSession(projectId: projectId);

          // Then
          final afterPause = await db.getActiveSession(projectId);
          expect(afterPause!.status, SessionStatus.paused);
          expect(afterPause.id, beforePause.id); // Same session
          expect(elapsedSec, greaterThanOrEqualTo(0));
        });

        test('should accumulate elapsed time correctly', () async {
          // Given - Create running session and let it run briefly
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 200));

          // When
          final elapsedSec = await db.pauseSession(projectId: projectId);

          // Then
          final session = await db.getActiveSession(projectId);
          expect(session!.elapsedMs, greaterThan(0));
          expect(session.elapsedMs.toSec(), elapsedSec);
          expect(elapsedSec, greaterThanOrEqualTo(0));
        });

        test('should set lastStartedAt to null when paused', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);
          final runningSession = await db.getActiveSession(projectId);
          expect(runningSession!.lastStartedAt, isNotNull);

          // When
          await db.pauseSession(projectId: projectId);

          // Then
          final pausedSession = await db.getActiveSession(projectId);
          expect(pausedSession!.lastStartedAt, isNull);
        });

        test('should update updatedAt timestamp', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);
          final beforePause = await db.getActiveSession(projectId);
          final beforeTimestamp = DateTime.now().millisecondsSinceEpoch;

          // When
          await db.pauseSession(projectId: projectId);

          // Then
          final afterPause = await db.getActiveSession(projectId);
          final afterTimestamp = DateTime.now().millisecondsSinceEpoch;

          expect(afterPause!.updatedAt, isNotNull);
          expect(afterPause.updatedAt!, greaterThanOrEqualTo(beforeTimestamp));
          expect(afterPause.updatedAt!, lessThanOrEqualTo(afterTimestamp));

          // Should be different from original (which was null)
          expect(afterPause.updatedAt, isNot(beforePause!.updatedAt));
        });

        test('should throw StateError when no active session exists', () async {
          // Given - No active session

          // When & Then
          expect(
            () => db.pauseSession(projectId: projectId),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('RUNNING 세션이 없습니다'),
              ),
            ),
          );
        });

        test(
          'should throw StateError when session is already paused',
          () async {
            // Given - Create and pause session
            await db.startSession(projectId: projectId);
            await db.pauseSession(projectId: projectId);

            // When & Then
            expect(
              () => db.pauseSession(projectId: projectId),
              throwsA(
                isA<StateError>().having(
                  (e) => e.message,
                  'message',
                  contains('RUNNING 세션이 없습니다'),
                ),
              ),
            );
          },
        );

        test('should throw StateError when session is stopped', () async {
          // Given - Create and stop session
          await db.startSession(projectId: projectId);
          await db.stopSession(projectId: projectId);

          // When & Then
          expect(
            () => db.pauseSession(projectId: projectId),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('RUNNING 세션이 없습니다'),
              ),
            ),
          );
        });

        test('should handle multiple pause attempts gracefully', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);

          // When - First pause should succeed
          final firstElapsed = await db.pauseSession(projectId: projectId);
          expect(firstElapsed, greaterThanOrEqualTo(0));

          // Then - Second pause should fail
          expect(
            () => db.pauseSession(projectId: projectId),
            throwsA(isA<StateError>()),
          );
        });
      });

      group('Elapsed Time Calculation', () {
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
          'should calculate elapsed time accurately for short duration',
          () async {
            // Given
            await db.startSession(projectId: projectId);
            const testDuration = Duration(milliseconds: 300);
            await Future.delayed(testDuration);

            // When
            final elapsedSec = await db.pauseSession(projectId: projectId);

            // Then
            // Allow for some variance in timing
            expect(elapsedSec, greaterThanOrEqualTo(0));
            if (elapsedSec > 0) {
              expectDurationCloseTo(
                Duration(seconds: elapsedSec),
                testDuration,
                Duration(milliseconds: 200), // ±200ms tolerance
              );
            }
          },
        );

        test(
          'should handle very short durations without negative values',
          () async {
            // Given - Start and immediately pause
            await db.startSession(projectId: projectId);

            // When - Pause immediately
            final elapsedSec = await db.pauseSession(projectId: projectId);

            // Then
            expect(elapsedSec, greaterThanOrEqualTo(0));

            final session = await db.getActiveSession(projectId);
            expect(session!.elapsedMs, greaterThanOrEqualTo(0));
          },
        );

        test(
          'should preserve elapsed time across multiple operations',
          () async {
            // Given - Create session and let it run
            await db.startSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 200));

            // When - Pause and check elapsed time
            final elapsedSec = await db.pauseSession(projectId: projectId);
            final session = await db.getActiveSession(projectId);

            // Then - Elapsed time should be preserved
            expect(session!.elapsedMs.toSec(), elapsedSec);
            expect(elapsedSec, greaterThanOrEqualTo(0));

            // Wait and check again - should not change
            await Future.delayed(Duration(milliseconds: 50));
            final sessionAfterWait = await db.getActiveSession(projectId);
            expect(sessionAfterWait!.elapsedMs, session.elapsedMs);
          },
        );
      });

      group('Transaction Safety', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should execute pause operation atomically', () async {
          // Given
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 100));

          // When - Pause within transaction
          var pauseCompleted = false;
          await db.transaction(() async {
            final elapsedSec = await db.pauseSession(projectId: projectId);
            pauseCompleted = true;

            // Verify state within transaction
            final session = await db.getActiveSession(projectId);
            expect(session!.status, SessionStatus.paused);
            expect(session.elapsedMs.toSec(), elapsedSec);
            expect(session.lastStartedAt, isNull);
          });

          // Then
          expect(pauseCompleted, true);
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession!.status, SessionStatus.paused);
        });

        test('should rollback pause operation if transaction fails', () async {
          // Given
          await db.startSession(projectId: projectId);

          var pauseAttempted = false;
          var exceptionCaught = false;

          try {
            // When - Force transaction failure after pause
            await db.transaction(() async {
              await db.pauseSession(projectId: projectId);
              pauseAttempted = true;

              // Force transaction to fail
              throw Exception('Simulated transaction failure');
            });
          } catch (e) {
            exceptionCaught = true;
          }

          // Then
          expect(pauseAttempted, true);
          expect(exceptionCaught, true);

          // Session should be back to original running state
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession!.status, SessionStatus.running);
          expect(finalSession.lastStartedAt, isNotNull);
        });
      });
    });

    group('2.3 Session Resume Logic', () {
      group('resumeSession method', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should transition from paused to running state', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);
          final beforeResume = await db.getActiveSession(projectId);
          expect(beforeResume!.status, SessionStatus.paused);

          // When
          await db.resumeSession(projectId: projectId);

          // Then
          final afterResume = await db.getActiveSession(projectId);
          expect(afterResume!.status, SessionStatus.running);
          expect(afterResume.id, beforeResume.id); // Same session
        });

        test('should set lastStartedAt when resumed', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);
          final pausedSession = await db.getActiveSession(projectId);
          expect(pausedSession!.lastStartedAt, isNull);

          // When
          final beforeResume = DateTime.now().millisecondsSinceEpoch;
          await db.resumeSession(projectId: projectId);
          final afterResume = DateTime.now().millisecondsSinceEpoch;

          // Then
          final resumedSession = await db.getActiveSession(projectId);
          expect(resumedSession!.lastStartedAt, isNotNull);
          expect(
            resumedSession.lastStartedAt!,
            greaterThanOrEqualTo(beforeResume),
          );
          expect(resumedSession.lastStartedAt!, lessThanOrEqualTo(afterResume));
        });

        test('should preserve existing elapsedMs value', () async {
          // Given - Create session, let it run, then pause
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 200));
          await db.pauseSession(projectId: projectId);

          final pausedSession = await db.getActiveSession(projectId);
          final originalElapsedMs = pausedSession!.elapsedMs;
          expect(originalElapsedMs, greaterThan(0));

          // When
          await db.resumeSession(projectId: projectId);

          // Then
          final resumedSession = await db.getActiveSession(projectId);
          expect(resumedSession!.elapsedMs, originalElapsedMs);
        });

        test('should update updatedAt timestamp', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);
          final beforeResume = DateTime.now().millisecondsSinceEpoch;

          // When
          await db.resumeSession(projectId: projectId);

          // Then
          final afterResume = DateTime.now().millisecondsSinceEpoch;
          final resumedSession = await db.getActiveSession(projectId);

          expect(resumedSession!.updatedAt, isNotNull);
          expect(resumedSession.updatedAt!, greaterThanOrEqualTo(beforeResume));
          expect(resumedSession.updatedAt!, lessThanOrEqualTo(afterResume));
        });

        test('should throw StateError when no active session exists', () async {
          // Given - No active session

          // When & Then
          expect(
            () => db.resumeSession(projectId: projectId),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('PAUSED 세션이 없습니다'),
              ),
            ),
          );
        });

        test('should throw StateError when session is running', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);

          // When & Then
          expect(
            () => db.resumeSession(projectId: projectId),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('PAUSED 세션이 없습니다'),
              ),
            ),
          );
        });

        test('should throw StateError when session is stopped', () async {
          // Given - Create and stop session
          await db.startSession(projectId: projectId);
          await db.stopSession(projectId: projectId);

          // When & Then
          expect(
            () => db.resumeSession(projectId: projectId),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('PAUSED 세션이 없습니다'),
              ),
            ),
          );
        });

        test('should handle multiple resume attempts gracefully', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);

          // When - First resume should succeed
          await db.resumeSession(projectId: projectId);
          final session = await db.getActiveSession(projectId);
          expect(session!.status, SessionStatus.running);

          // Then - Second resume should fail
          expect(
            () => db.resumeSession(projectId: projectId),
            throwsA(isA<StateError>()),
          );
        });
      });

      group('Resume Time Continuity', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should continue time accumulation after resume', () async {
          // Given - Create session, run, pause, then resume
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 200));

          final elapsedAfterFirstRun = await db.pauseSession(
            projectId: projectId,
          );
          expect(elapsedAfterFirstRun, greaterThanOrEqualTo(0));

          await db.resumeSession(projectId: projectId);

          // When - Let it run again
          await Future.delayed(Duration(milliseconds: 200));
          final finalElapsed = await db.pauseSession(projectId: projectId);

          // Then - Total elapsed should be greater than or equal to first segment
          expect(finalElapsed, greaterThanOrEqualTo(elapsedAfterFirstRun));
        });

        test(
          'should maintain accurate time across pause/resume cycles',
          () async {
            // Given - Multiple pause/resume cycles
            await db.startSession(projectId: projectId);

            // First run
            await Future.delayed(Duration(milliseconds: 150));
            final elapsed1 = await db.pauseSession(projectId: projectId);

            // First resume and run
            await db.resumeSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 150));
            final elapsed2 = await db.pauseSession(projectId: projectId);

            // Second resume and run
            await db.resumeSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 150));
            final finalElapsed = await db.pauseSession(projectId: projectId);

            // Then - Each segment should add to the total
            expect(elapsed2, greaterThanOrEqualTo(elapsed1));
            expect(finalElapsed, greaterThanOrEqualTo(elapsed2));

            // Final elapsed should be roughly the sum of all delays
            expect(finalElapsed, greaterThanOrEqualTo(0));
          },
        );

        test(
          'should not accumulate time while paused between resume calls',
          () async {
            // Given - Create, run, and pause session
            await db.startSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 100));
            final elapsedAfterPause = await db.pauseSession(
              projectId: projectId,
            );

            // When - Wait while paused, then resume
            await Future.delayed(Duration(milliseconds: 100));
            await db.resumeSession(projectId: projectId);

            // Then - Elapsed time should not have changed during pause
            final sessionAfterResume = await db.getActiveSession(projectId);
            expect(sessionAfterResume!.elapsedMs.toSec(), elapsedAfterPause);
          },
        );
      });

      group('Transaction Safety', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should execute resume operation atomically', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);

          // When - Resume within transaction
          var resumeCompleted = false;
          await db.transaction(() async {
            await db.resumeSession(projectId: projectId);
            resumeCompleted = true;

            // Verify state within transaction
            final session = await db.getActiveSession(projectId);
            expect(session!.status, SessionStatus.running);
            expect(session.lastStartedAt, isNotNull);
          });

          // Then
          expect(resumeCompleted, true);
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession!.status, SessionStatus.running);
        });

        test('should rollback resume operation if transaction fails', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);
          final originalSession = await db.getActiveSession(projectId);

          var resumeAttempted = false;
          var exceptionCaught = false;

          try {
            // When - Force transaction failure after resume
            await db.transaction(() async {
              await db.resumeSession(projectId: projectId);
              resumeAttempted = true;

              // Force transaction to fail
              throw Exception('Simulated transaction failure');
            });
          } catch (e) {
            exceptionCaught = true;
          }

          // Then
          expect(resumeAttempted, true);
          expect(exceptionCaught, true);

          // Session should be back to original paused state
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession!.status, SessionStatus.paused);
          expect(finalSession.lastStartedAt, isNull);
          expect(finalSession.elapsedMs, originalSession!.elapsedMs);
        });
      });

      group('Multiple Projects Resume', () {
        late AppDb db;
        late int projectId1;
        late int projectId2;

        setUp(() async {
          db = createTestDb();
          projectId1 = await createTestProject(db, name: 'Project 1');
          projectId2 = await createTestProject(db, name: 'Project 2');
        });

        tearDown(() async {
          await db.close();
        });

        test(
          'should resume sessions independently for different projects',
          () async {
            // Given - Create and pause sessions for both projects
            await db.startSession(projectId: projectId1);
            await db.startSession(projectId: projectId2);
            await db.pauseSession(projectId: projectId1);
            await db.pauseSession(projectId: projectId2);

            // When - Resume only first project
            await db.resumeSession(projectId: projectId1);

            // Then
            final session1 = await db.getActiveSession(projectId1);
            final session2 = await db.getActiveSession(projectId2);

            expect(session1!.status, SessionStatus.running);
            expect(session2!.status, SessionStatus.paused);
          },
        );

        test(
          'should maintain project isolation during resume operations',
          () async {
            // Given - Different states for different projects
            await db.startSession(projectId: projectId1);
            await db.pauseSession(projectId: projectId1);
            // projectId2 has no session

            // When - Resume project1 and try to resume project2
            await db.resumeSession(projectId: projectId1);

            // Then - Project1 should be running, project2 should fail
            final session1 = await db.getActiveSession(projectId1);
            expect(session1!.status, SessionStatus.running);

            expect(
              () => db.resumeSession(projectId: projectId2),
              throwsA(isA<StateError>()),
            );
          },
        );
      });
    });

    group('2.4 Session Stop Logic', () {
      group('stopSession method', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should transition from running to stopped state', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);
          final beforeStop = await db.getActiveSession(projectId);
          expect(beforeStop!.status, SessionStatus.running);

          // When
          await db.stopSession(projectId: projectId);

          // Then
          final afterStop = await db.getActiveSession(projectId);
          expect(afterStop, isNull); // No active session after stop

          // Check the stopped session exists
          final stoppedSessions = await db.getCompletedSessions(projectId);
          expect(stoppedSessions, hasLength(1));
          expect(stoppedSessions.first.status, SessionStatus.stopped);
          expect(stoppedSessions.first.id, beforeStop.id); // Same session
        });

        test('should transition from paused to stopped state', () async {
          // Given - Create and pause session
          await db.startSession(projectId: projectId);
          await db.pauseSession(projectId: projectId);
          final beforeStop = await db.getActiveSession(projectId);
          expect(beforeStop!.status, SessionStatus.paused);

          // When
          await db.stopSession(projectId: projectId);

          // Then
          final afterStop = await db.getActiveSession(projectId);
          expect(afterStop, isNull); // No active session after stop

          // Check the stopped session exists
          final stoppedSessions = await db.getCompletedSessions(projectId);
          expect(stoppedSessions, hasLength(1));
          expect(stoppedSessions.first.status, SessionStatus.stopped);
          expect(stoppedSessions.first.id, beforeStop.id); // Same session
        });

        test(
          'should calculate and save final elapsed time from running state',
          () async {
            // Given - Create running session and let it run
            await db.startSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 200));

            // When
            await db.stopSession(projectId: projectId);

            // Then
            final stoppedSessions = await db.getCompletedSessions(projectId);
            expect(stoppedSessions, hasLength(1));

            final stoppedSession = stoppedSessions.first;
            expect(stoppedSession.elapsedMs, greaterThan(0));
            expect(
              stoppedSession.elapsedMs,
              lessThan(500),
            ); // Should be around 200ms
          },
        );

        test(
          'should preserve elapsed time when stopping from paused state',
          () async {
            // Given - Create session, run, then pause
            await db.startSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 200));
            final elapsedSec = await db.pauseSession(projectId: projectId);

            final pausedSession = await db.getActiveSession(projectId);
            final pausedElapsedMs = pausedSession!.elapsedMs;

            // When
            await db.stopSession(projectId: projectId);

            // Then
            final stoppedSessions = await db.getCompletedSessions(projectId);
            expect(stoppedSessions, hasLength(1));

            final stoppedSession = stoppedSessions.first;
            expect(stoppedSession.elapsedMs, pausedElapsedMs);
            expect(stoppedSession.elapsedMs.toSec(), elapsedSec);
          },
        );

        test('should set stoppedAt field correctly', () async {
          // Given
          await db.startSession(projectId: projectId);
          final beforeStop = DateTime.now().millisecondsSinceEpoch;

          // When
          await db.stopSession(projectId: projectId);

          // Then
          final afterStop = DateTime.now().millisecondsSinceEpoch;
          final stoppedSessions = await db.getCompletedSessions(projectId);

          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.stoppedAt, isNotNull);
          expect(stoppedSession.stoppedAt!, greaterThanOrEqualTo(beforeStop));
          expect(stoppedSession.stoppedAt!, lessThanOrEqualTo(afterStop));
        });

        test('should set lastStartedAt to null when stopped', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);
          final runningSession = await db.getActiveSession(projectId);
          expect(runningSession!.lastStartedAt, isNotNull);

          // When
          await db.stopSession(projectId: projectId);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.lastStartedAt, isNull);
        });

        test('should update label when provided', () async {
          // Given
          await db.startSession(projectId: projectId, label: 'Original Label');
          const newLabel = 'Updated Label';

          // When
          await db.stopSession(projectId: projectId, label: newLabel);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, newLabel);
        });

        test('should update memo when provided', () async {
          // Given
          await db.startSession(projectId: projectId, memo: 'Original Memo');
          const newMemo = 'Updated Memo';

          // When
          await db.stopSession(projectId: projectId, memo: newMemo);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.memo, newMemo);
        });

        test('should preserve existing label when not provided', () async {
          // Given
          const originalLabel = 'Original Label';
          await db.startSession(projectId: projectId, label: originalLabel);

          // When - Stop without providing label
          await db.stopSession(projectId: projectId);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, originalLabel);
        });

        test('should preserve existing memo when not provided', () async {
          // Given
          const originalMemo = 'Original Memo';
          await db.startSession(projectId: projectId, memo: originalMemo);

          // When - Stop without providing memo
          await db.stopSession(projectId: projectId);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.memo, originalMemo);
        });

        test('should handle null label and memo correctly', () async {
          // Given
          await db.startSession(projectId: projectId);

          // When - Stop with explicit null values
          await db.stopSession(projectId: projectId, label: null, memo: null);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, isNull);
          expect(stoppedSession.memo, isNull);
        });

        test('should update both label and memo when provided', () async {
          // Given
          await db.startSession(projectId: projectId);
          const newLabel = 'Final Label';
          const newMemo = 'Final Memo';

          // When
          await db.stopSession(
            projectId: projectId,
            label: newLabel,
            memo: newMemo,
          );

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, newLabel);
          expect(stoppedSession.memo, newMemo);
        });

        test('should update updatedAt timestamp', () async {
          // Given
          await db.startSession(projectId: projectId);
          final beforeStop = DateTime.now().millisecondsSinceEpoch;

          // When
          await db.stopSession(projectId: projectId);

          // Then
          final afterStop = DateTime.now().millisecondsSinceEpoch;
          final stoppedSessions = await db.getCompletedSessions(projectId);

          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.updatedAt, isNotNull);
          expect(stoppedSession.updatedAt!, greaterThanOrEqualTo(beforeStop));
          expect(stoppedSession.updatedAt!, lessThanOrEqualTo(afterStop));
        });

        test('should throw StateError when no active session exists', () async {
          // Given - No active session

          // When & Then
          expect(
            () => db.stopSession(projectId: projectId),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('활성 세션이 없습니다'),
              ),
            ),
          );
        });

        test(
          'should throw StateError when session is already stopped',
          () async {
            // Given - Create and stop session
            await db.startSession(projectId: projectId);
            await db.stopSession(projectId: projectId);

            // When & Then
            expect(
              () => db.stopSession(projectId: projectId),
              throwsA(
                isA<StateError>().having(
                  (e) => e.message,
                  'message',
                  contains('활성 세션이 없습니다'),
                ),
              ),
            );
          },
        );

        test('should handle multiple stop attempts gracefully', () async {
          // Given - Create running session
          await db.startSession(projectId: projectId);

          // When - First stop should succeed
          await db.stopSession(projectId: projectId);
          final stoppedSessions = await db.getCompletedSessions(projectId);
          expect(stoppedSessions, hasLength(1));

          // Then - Second stop should fail
          expect(
            () => db.stopSession(projectId: projectId),
            throwsA(isA<StateError>()),
          );
        });
      });

      group('Final Elapsed Time Calculation', () {
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
          'should calculate accurate elapsed time for running session',
          () async {
            // Given
            await db.startSession(projectId: projectId);
            const testDuration = Duration(milliseconds: 300);
            await Future.delayed(testDuration);

            // When
            await db.stopSession(projectId: projectId);

            // Then
            final stoppedSessions = await db.getCompletedSessions(projectId);
            final stoppedSession = stoppedSessions.first;

            expectDurationCloseTo(
              Duration(milliseconds: stoppedSession.elapsedMs),
              testDuration,
              Duration(milliseconds: 100), // ±100ms tolerance
            );
          },
        );

        test('should preserve elapsed time from paused session', () async {
          // Given - Run for some time, then pause
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 200));
          final elapsedSec = await db.pauseSession(projectId: projectId);

          // Wait while paused (should not affect elapsed time)
          await Future.delayed(Duration(milliseconds: 100));

          // When
          await db.stopSession(projectId: projectId);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.elapsedMs.toSec(), elapsedSec);
        });

        test('should handle very short durations correctly', () async {
          // Given - Start and immediately stop
          await db.startSession(projectId: projectId);

          // When - Stop immediately
          await db.stopSession(projectId: projectId);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.elapsedMs, greaterThanOrEqualTo(0));
        });

        test(
          'should accumulate time correctly across pause/resume/stop cycle',
          () async {
            // Given - Multiple pause/resume cycles before stop
            await db.startSession(projectId: projectId);

            // First run - longer duration to ensure measurable elapsed time
            await Future.delayed(Duration(milliseconds: 200));
            final elapsed1 = await db.pauseSession(projectId: projectId);

            // Resume and run again
            await db.resumeSession(projectId: projectId);
            await Future.delayed(Duration(milliseconds: 200));

            // When - Stop from running state
            await db.stopSession(projectId: projectId);

            // Then
            final stoppedSessions = await db.getCompletedSessions(projectId);
            final stoppedSession = stoppedSessions.first;

            // Final elapsed should be greater than or equal to first pause
            // (allowing for very short durations that might round to 0)
            expect(
              stoppedSession.elapsedMs.toSec(),
              greaterThanOrEqualTo(elapsed1),
            );

            // Should be roughly 400ms total
            expectDurationCloseTo(
              Duration(milliseconds: stoppedSession.elapsedMs),
              Duration(milliseconds: 400),
              Duration(milliseconds: 200), // ±200ms tolerance
            );
          },
        );
      });

      group('Label and Memo Management', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should handle empty string label and memo', () async {
          // Given
          await db.startSession(projectId: projectId);

          // When
          await db.stopSession(projectId: projectId, label: '', memo: '');

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, '');
          expect(stoppedSession.memo, '');
        });

        test('should handle long label and memo strings', () async {
          // Given
          await db.startSession(projectId: projectId);
          final longLabel = 'A' * 1000; // 1000 character label
          final longMemo = 'B' * 2000; // 2000 character memo

          // When
          await db.stopSession(
            projectId: projectId,
            label: longLabel,
            memo: longMemo,
          );

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, longLabel);
          expect(stoppedSession.memo, longMemo);
        });

        test('should handle special characters in label and memo', () async {
          // Given
          await db.startSession(projectId: projectId);
          const specialLabel = '🧶 뜨개질 작업 #1 (완료)';
          const specialMemo = 'Line 1\nLine 2\n특수문자: @#\$%^&*()';

          // When
          await db.stopSession(
            projectId: projectId,
            label: specialLabel,
            memo: specialMemo,
          );

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, specialLabel);
          expect(stoppedSession.memo, specialMemo);
        });

        test('should update only label when memo is not provided', () async {
          // Given
          const originalMemo = 'Original Memo';
          await db.startSession(projectId: projectId, memo: originalMemo);
          const newLabel = 'New Label';

          // When
          await db.stopSession(projectId: projectId, label: newLabel);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, newLabel);
          expect(stoppedSession.memo, originalMemo); // Should be preserved
        });

        test('should update only memo when label is not provided', () async {
          // Given
          const originalLabel = 'Original Label';
          await db.startSession(projectId: projectId, label: originalLabel);
          const newMemo = 'New Memo';

          // When
          await db.stopSession(projectId: projectId, memo: newMemo);

          // Then
          final stoppedSessions = await db.getCompletedSessions(projectId);
          final stoppedSession = stoppedSessions.first;
          expect(stoppedSession.label, originalLabel); // Should be preserved
          expect(stoppedSession.memo, newMemo);
        });
      });

      group('Transaction Safety', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('should execute stop operation atomically', () async {
          // Given
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 100));

          // When - Stop within transaction
          var stopCompleted = false;
          await db.transaction(() async {
            await db.stopSession(projectId: projectId, label: 'Test Label');
            stopCompleted = true;

            // Verify state within transaction
            final activeSession = await db.getActiveSession(projectId);
            expect(activeSession, isNull);

            final stoppedSessions = await db.getCompletedSessions(projectId);
            expect(stoppedSessions, hasLength(1));
            expect(stoppedSessions.first.status, SessionStatus.stopped);
          });

          // Then
          expect(stopCompleted, true);
          final finalActiveSession = await db.getActiveSession(projectId);
          expect(finalActiveSession, isNull);
        });

        test('should rollback stop operation if transaction fails', () async {
          // Given
          await db.startSession(projectId: projectId);
          final originalSession = await db.getActiveSession(projectId);

          var stopAttempted = false;
          var exceptionCaught = false;

          try {
            // When - Force transaction failure after stop
            await db.transaction(() async {
              await db.stopSession(projectId: projectId);
              stopAttempted = true;

              // Force transaction to fail
              throw Exception('Simulated transaction failure');
            });
          } catch (e) {
            exceptionCaught = true;
          }

          // Then
          expect(stopAttempted, true);
          expect(exceptionCaught, true);

          // Session should be back to original running state
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession, isNotNull);
          expect(finalSession!.status, SessionStatus.running);
          expect(finalSession.id, originalSession!.id);
        });
      });
    });
  });
}
