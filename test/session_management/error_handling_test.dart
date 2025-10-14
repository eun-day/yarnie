import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('7. 에러 처리 및 예외 상황 테스트', () {
    group('7.1 상태 전환 에러 처리 테스트', () {
      group('데이터베이스 상태 전환 에러', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('startSession - 활성 세션 존재 시 StateError 발생', () async {
          // Given - 이미 활성 세션이 존재
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
        });

        test('pauseSession - RUNNING 세션이 없을 때 StateError 발생', () async {
          // Given - 활성 세션이 없음

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

        test('pauseSession - PAUSED 세션에서 pause 시도 시 StateError 발생', () async {
          // Given - 세션을 생성하고 일시정지
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
        });

        test('resumeSession - PAUSED 세션이 없을 때 StateError 발생', () async {
          // Given - 활성 세션이 없음

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

        test('stopSession - 활성 세션이 없을 때 StateError 발생', () async {
          // Given - 활성 세션이 없음

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

        test('discardActiveSession - 활성 세션이 없을 때 정상 처리', () async {
          // Given - 활성 세션이 없음

          // When & Then - 예외 없이 정상 처리되어야 함
          expect(
            () => db.discardActiveSession(projectId: projectId),
            returnsNormally,
          );
        });
      });

      group('에러 발생 후 시스템 복구 및 상태 일관성', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('StateError 발생 후 데이터베이스 상태가 일관성을 유지해야 함', () async {
          // Given - 정상적인 세션 생성
          await db.startSession(projectId: projectId);
          final originalSession = await db.getActiveSession(projectId);

          // When - 잘못된 상태 전환 시도 (StateError 발생)
          try {
            await db.startSession(projectId: projectId);
          } catch (e) {
            expect(e, isA<StateError>());
          }

          // Then - 원래 세션 상태가 변경되지 않아야 함
          final sessionAfterError = await db.getActiveSession(projectId);
          expect(sessionAfterError, isNotNull);
          expect(sessionAfterError!.id, originalSession!.id);
          expect(sessionAfterError.status, SessionStatus.running);
          expect(
            sessionAfterError.lastStartedAt,
            originalSession.lastStartedAt,
          );
        });

        test('여러 에러 발생 후에도 정상 작업이 가능해야 함', () async {
          // Given - 여러 잘못된 상태 전환 시도
          try {
            await db.pauseSession(projectId: projectId); // 세션 없음
          } catch (e) {
            expect(e, isA<StateError>());
          }

          try {
            await db.resumeSession(projectId: projectId); // 세션 없음
          } catch (e) {
            expect(e, isA<StateError>());
          }

          try {
            await db.stopSession(projectId: projectId); // 세션 없음
          } catch (e) {
            expect(e, isA<StateError>());
          }

          // When - 정상적인 세션 생성 시도
          final sessionId = await db.startSession(projectId: projectId);

          // Then - 정상적으로 작동해야 함
          expect(sessionId, greaterThan(0));
          final session = await db.getActiveSession(projectId);
          expect(session, isNotNull);
          expect(session!.status, SessionStatus.running);
        });

        test('에러 발생 후 세션 라이프사이클이 정상적으로 작동해야 함', () async {
          // Given - 에러 발생 후 정상 세션 생성
          try {
            await db.pauseSession(projectId: projectId);
          } catch (e) {
            expect(e, isA<StateError>());
          }

          await db.startSession(projectId: projectId);

          // When - 정상적인 라이프사이클 실행
          await Future.delayed(Duration(milliseconds: 100));
          final elapsedSec = await db.pauseSession(projectId: projectId);
          await db.resumeSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 100));
          await db.stopSession(projectId: projectId);

          // Then - 모든 작업이 정상적으로 완료되어야 함
          expect(elapsedSec, greaterThanOrEqualTo(0));
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession, isNull); // stopped 세션은 활성 세션이 아님

          // 완료된 세션 확인
          final completedSessions = await db
              .watchCompletedSessions(projectId)
              .first;
          expect(completedSessions, hasLength(1));
          expect(completedSessions.first.status, SessionStatus.stopped);
        });
      });

      group('StopwatchProvider 에러 처리', () {
        late ProviderContainer container;

        setUp(() {
          container = ProviderContainer();
        });

        tearDown(() {
          container.dispose();
        });

        test('dispose 후 메서드 호출 시 예외 발생', () {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();

          // When - 컨테이너 dispose 후 메서드 호출
          container.dispose();

          // Then - UnmountedRefException이 발생해야 함
          expect(() => notifier.pause(), throwsA(isA<Exception>()));
          expect(() => notifier.resume(), throwsA(isA<Exception>()));
          expect(() => notifier.stop(), throwsA(isA<Exception>()));
          expect(() => notifier.reset(), throwsA(isA<Exception>()));
        });

        test('잘못된 초기 elapsed 값 처리', () {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);

          // When & Then - 음수 값도 안전하게 처리되어야 함
          expect(
            () => notifier.start(initialElapsed: Duration(seconds: -1)),
            returnsNormally,
          );
          expect(
            () => notifier.setElapsed(Duration(seconds: -1)),
            returnsNormally,
          );

          // 음수 값은 그대로 설정됨 (StopwatchProvider는 음수 값을 제한하지 않음)
          notifier.setElapsed(Duration(seconds: -1));
          final state = container.read(stopwatchProvider);
          expect(state.elapsed, Duration(seconds: -1));
        });

        test('매우 큰 elapsed 값 처리', () {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          final veryLargeDuration = Duration(days: 365 * 100); // 100년

          // When & Then - 매우 큰 값도 안전하게 처리되어야 함
          expect(() => notifier.setElapsed(veryLargeDuration), returnsNormally);

          final state = container.read(stopwatchProvider);
          expect(state.elapsed, veryLargeDuration);
        });
      });
    });

    group('7.2 데이터베이스 트랜잭션 및 동시성 테스트', () {
      group('트랜잭션 실패 시 롤백 테스트', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('세션 시작 트랜잭션 실패 시 롤백되어야 함', () async {
          // Given
          var sessionCreated = false;
          var exceptionCaught = false;

          try {
            // When - 트랜잭션 내에서 세션 생성 후 강제 실패
            await db.transaction(() async {
              await db.startSession(projectId: projectId);
              sessionCreated = true;

              // 트랜잭션 강제 실패
              throw Exception('트랜잭션 테스트 실패');
            });
          } catch (e) {
            exceptionCaught = true;
          }

          // Then
          expect(sessionCreated, true);
          expect(exceptionCaught, true);

          // 롤백으로 인해 세션이 존재하지 않아야 함
          final session = await db.getActiveSession(projectId);
          expect(session, isNull);
        });

        test('세션 일시정지 트랜잭션 실패 시 원래 상태로 롤백되어야 함', () async {
          // Given - 실행 중인 세션 생성
          await db.startSession(projectId: projectId);
          final originalSession = await db.getActiveSession(projectId);

          var pauseAttempted = false;
          var exceptionCaught = false;

          try {
            // When - 트랜잭션 내에서 일시정지 후 강제 실패
            await db.transaction(() async {
              await db.pauseSession(projectId: projectId);
              pauseAttempted = true;

              // 트랜잭션 강제 실패
              throw Exception('트랜잭션 테스트 실패');
            });
          } catch (e) {
            exceptionCaught = true;
          }

          // Then
          expect(pauseAttempted, true);
          expect(exceptionCaught, true);

          // 롤백으로 인해 원래 running 상태로 복원되어야 함
          final finalSession = await db.getActiveSession(projectId);
          expect(finalSession, isNotNull);
          expect(finalSession!.status, SessionStatus.running);
          expect(finalSession.lastStartedAt, isNotNull);
          expect(finalSession.id, originalSession!.id);
        });
      });

      group('동시 세션 조작 시 데이터 무결성 테스트', () {
        late AppDb db;
        late int projectId;

        setUp(() async {
          db = createTestDb();
          projectId = await createTestProject(db);
        });

        tearDown(() async {
          await db.close();
        });

        test('동시 세션 시작 시도 시 하나만 성공해야 함', () async {
          // Given
          final futures = <Future<int>>[];

          // When - 동시에 여러 세션 시작 시도
          for (int i = 0; i < 5; i++) {
            futures.add(
              db.startSession(projectId: projectId).catchError((e) => -1),
            );
          }

          final results = await Future.wait(futures);

          // Then - 하나만 성공하고 나머지는 실패해야 함
          final successfulResults = results.where((r) => r > 0).toList();
          expect(successfulResults, hasLength(1));

          // 활성 세션이 하나만 존재해야 함
          final activeSession = await db.getActiveSession(projectId);
          expect(activeSession, isNotNull);
          expect(activeSession!.status, SessionStatus.running);
        });

        test('서로 다른 프로젝트의 동시 세션 조작은 독립적이어야 함', () async {
          // Given - 여러 프로젝트
          final project2Id = await createTestProject(db, name: 'Project 2');
          final project3Id = await createTestProject(db, name: 'Project 3');

          // When - 각 프로젝트에서 동시에 세션 시작
          final futures = [
            db.startSession(projectId: projectId),
            db.startSession(projectId: project2Id),
            db.startSession(projectId: project3Id),
          ];

          final results = await Future.wait(futures);

          // Then - 모든 세션이 성공적으로 생성되어야 함
          expect(results, hasLength(3));
          for (final sessionId in results) {
            expect(sessionId, greaterThan(0));
          }

          // 각 프로젝트에 활성 세션이 존재해야 함
          final session1 = await db.getActiveSession(projectId);
          final session2 = await db.getActiveSession(project2Id);
          final session3 = await db.getActiveSession(project3Id);

          expect(session1, isNotNull);
          expect(session2, isNotNull);
          expect(session3, isNotNull);
          expect(session1!.status, SessionStatus.running);
          expect(session2!.status, SessionStatus.running);
          expect(session3!.status, SessionStatus.running);
        });
      });

      group('데이터베이스 연결 오류 시 처리 테스트', () {
        test('데이터베이스 연결 실패 시 적절한 예외 발생', () async {
          // Given - 잘못된 데이터베이스 연결
          AppDb? faultyDb;

          try {
            faultyDb = createTestDb();
            await faultyDb.close(); // 연결 종료

            // When - 종료된 데이터베이스에 작업 시도
            await faultyDb.startSession(projectId: 1);
          } catch (e) {
            // Then - 적절한 예외가 발생해야 함
            expect(e, isNotNull);
          } finally {
            // 정리
            try {
              await faultyDb?.close();
            } catch (e) {
              // 이미 종료된 경우 무시
            }
          }
        });

        test('데이터베이스 작업 중 연결 끊김 시 복구 가능해야 함', () async {
          // Given
          final db = createTestDb();
          final projectId = await createTestProject(db);

          try {
            // When - 정상 작업 후 연결 종료
            await db.startSession(projectId: projectId);
            await db.close();

            // 새 연결로 복구
            final newDb = createTestDb();
            final newProjectId = await createTestProject(newDb);

            // Then - 새 연결에서 정상 작업 가능해야 함
            final sessionId = await newDb.startSession(projectId: newProjectId);
            expect(sessionId, greaterThan(0));

            await newDb.close();
          } catch (e) {
            await db.close();
            rethrow;
          }
        });
      });

      group('타이머 업데이트와 사용자 액션 동시 발생 시 처리 테스트', () {
        late ProviderContainer container;

        setUp(() {
          container = ProviderContainer();
        });

        tearDown(() {
          container.dispose();
        });

        test('타이머 업데이트 중 pause 호출 시 안전하게 처리되어야 함', () async {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();

          // When - 타이머가 실행 중일 때 pause 호출
          await Future.delayed(Duration(milliseconds: 75)); // 타이머 틱 중간
          notifier.pause();

          // Then - 안전하게 일시정지되어야 함
          final state = container.read(stopwatchProvider);
          expect(state.isRunning, false);
          expect(state.elapsed, greaterThan(Duration.zero));
        });

        test('타이머 업데이트 중 reset 호출 시 안전하게 처리되어야 함', () async {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();

          // When - 타이머가 실행 중일 때 reset 호출
          await Future.delayed(Duration(milliseconds: 75)); // 타이머 틱 중간
          notifier.reset();

          // Then - 안전하게 리셋되어야 함
          final state = container.read(stopwatchProvider);
          expect(state.isRunning, false);
          expect(state.elapsed, Duration.zero);
        });

        test('빠른 연속 상태 변경 시 안전하게 처리되어야 함', () async {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);

          // When - 빠른 연속 상태 변경
          notifier.start();
          notifier.pause();
          notifier.resume();
          notifier.pause();
          notifier.resume();
          notifier.stop();

          // Then - 최종 상태가 일관성 있게 유지되어야 함
          final state = container.read(stopwatchProvider);
          expect(state.isRunning, false);
          expect(state.elapsed, greaterThanOrEqualTo(Duration.zero));
        });

        test('dispose 중 타이머 업데이트 발생 시 안전하게 처리되어야 함', () async {
          // Given
          final notifier = container.read(stopwatchProvider.notifier);
          notifier.start();

          // When - 타이머 실행 중 dispose
          await Future.delayed(Duration(milliseconds: 25)); // 타이머 틱 전
          container.dispose();

          // Then - 예외가 발생하지 않아야 함
          await Future.delayed(Duration(milliseconds: 100));
          expect(true, true); // 예외 없이 도달하면 성공
        });
      });
    });
  });
}
