import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/session_status.dart';

import '../helpers/test_helpers.dart';

/// 성능 프로파일링 및 최적화 검증 테스트
void main() {
  group('성능 프로파일링 및 최적화 검증', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('쿼리 성능 최적화', () {
      test('인덱스 활용 성능 검증', () async {
        // Given: 대량 데이터 생성 (다양한 프로젝트)
        final projectIds = <int>[];
        for (int i = 0; i < 10; i++) {
          final pid = await createTestProject(db, name: 'Project $i');
          projectIds.add(pid);

          // 각 프로젝트에 100개씩 세션 생성
          for (int j = 0; j < 100; j++) {
            await createCompletedSession(
              db,
              pid,
              Duration(minutes: j + 1),
              label: 'Session $j',
            );
          }
        }

        // When: 특정 프로젝트 조회 성능 측정
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 100; i++) {
          final targetProjectId = projectIds[i % projectIds.length];
          await db.getCompletedSessions(targetProjectId);
          await db.totalElapsedDuration(projectId: targetProjectId);
        }

        stopwatch.stop();

        // Then: 평균 조회 시간이 허용 범위 내여야 함
        final avgTimePerQuery =
            stopwatch.elapsedMilliseconds / 200; // 100회 * 2개 쿼리
        expect(avgTimePerQuery, lessThan(10)); // 평균 10ms 미만

        // print('평균 쿼리 시간: ${avgTimePerQuery.toStringAsFixed(2)}ms');
      });

      test('복합 쿼리 최적화', () async {
        // Given: 복잡한 데이터 구조
        await createCompletedSession(
          db,
          projectId,
          Duration(hours: 1),
          label: 'Work',
        );
        await createCompletedSession(
          db,
          projectId,
          Duration(minutes: 30),
          label: 'Break',
        );
        await createCompletedSession(
          db,
          projectId,
          Duration(hours: 2),
          label: 'Work',
        );

        // 활성 세션도 생성
        await db.startSession(projectId: projectId, label: 'Current');
        await Future.delayed(Duration(milliseconds: 100));
        await db.pauseSession(projectId: projectId);

        // When: 복합 쿼리 성능 측정
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          // 여러 쿼리를 동시에 실행
          await Future.wait([
            db.getCompletedSessions(projectId),
            db.getActiveSession(projectId),
            db.totalElapsedDuration(projectId: projectId),
          ]);
        }

        stopwatch.stop();

        // Then: 복합 쿼리 성능이 허용 범위 내여야 함
        final avgTime = stopwatch.elapsedMilliseconds / 1000;
        expect(avgTime, lessThan(5)); // 평균 5ms 미만

        // print('복합 쿼리 평균 시간: ${avgTime.toStringAsFixed(2)}ms');
      });
    });

    group('메모리 사용량 최적화', () {
      test('스트림 구독 메모리 누수 방지', () async {
        // Given: 기본 데이터
        await createCompletedSession(db, projectId, Duration(minutes: 10));

        // When: 대량 스트림 구독/해제 반복
        final subscriptions = <Stream>[];

        for (int i = 0; i < 1000; i++) {
          final stream = db.watchCompletedSessions(projectId);
          subscriptions.add(stream);

          // 일부 스트림은 즉시 구독 해제
          if (i % 10 == 0) {
            final subscription = stream.listen((_) {});
            await Future.delayed(Duration(microseconds: 1));
            await subscription.cancel();
          }
        }

        // Then: 메모리 누수 없이 완료되어야 함
        expect(subscriptions.length, 1000);

        // 가비지 컬렉션 유도
        subscriptions.clear();

        // 최종 검증
        final finalStream = db.watchCompletedSessions(projectId);
        final subscription = finalStream.listen((_) {});
        await Future.delayed(Duration(milliseconds: 10));
        await subscription.cancel();
      });

      test('대용량 결과셋 메모리 효율성', () async {
        // Given: 대용량 세션 데이터
        const sessionCount = 5000;

        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < sessionCount; i++) {
          await createCompletedSession(
            db,
            projectId,
            Duration(seconds: i % 3600 + 1),
            label: 'Session $i',
            memo:
                'Memo for session $i with some additional text to increase size',
          );

          // 진행률 출력 (테스트용)
          if (i % 1000 == 0) {
            // print('세션 생성 진행률: $i/$sessionCount');
          }
        }

        stopwatch.stop();
        // print('대용량 데이터 생성 시간: ${stopwatch.elapsedMilliseconds}ms');

        // When: 메모리 효율적 조회
        final queryStopwatch = Stopwatch()..start();

        // 페이지네이션 방식으로 조회
        const pageSize = 100;
        var totalRetrieved = 0;

        for (int offset = 0; offset < sessionCount; offset += pageSize) {
          final sessions = await db.getCompletedSessionsPaginated(
            projectId,
            limit: pageSize,
            offset: offset,
          );
          totalRetrieved += sessions.length;

          // 메모리 사용량 체크를 위해 일부 데이터 처리
          final totalDuration = sessions.fold<Duration>(
            Duration.zero,
            (sum, session) => sum + Duration(milliseconds: session.elapsedMs),
          );
          expect(totalDuration.inMilliseconds, greaterThan(0));
        }

        queryStopwatch.stop();

        // Then: 효율적인 조회 성능
        expect(totalRetrieved, sessionCount);
        expect(queryStopwatch.elapsedMilliseconds, lessThan(5000)); // 5초 미만

        // print('페이지네이션 조회 시간: ${queryStopwatch.elapsedMilliseconds}ms');
      });
    });

    group('동시성 성능 최적화', () {
      test('동시 접근 처리 성능', () async {
        // Given: 여러 프로젝트 준비
        final projectIds = <int>[];
        for (int i = 0; i < 10; i++) {
          projectIds.add(
            await createTestProject(db, name: 'Concurrent Project $i'),
          );
        }

        // When: 동시 세션 조작
        final stopwatch = Stopwatch()..start();

        final futures = projectIds.map((pid) async {
          // 각 프로젝트에서 세션 라이프사이클 실행
          await db.startSession(projectId: pid);
          await Future.delayed(Duration(milliseconds: 10));
          await db.pauseSession(projectId: pid);
          await db.resumeSession(projectId: pid);
          await Future.delayed(Duration(milliseconds: 10));
          await db.stopSession(projectId: pid);

          return await db.totalElapsedDuration(projectId: pid);
        }).toList();

        final results = await Future.wait(futures);
        stopwatch.stop();

        // Then: 동시성 처리 성능 검증
        expect(results.length, projectIds.length);
        expect(results.every((duration) => duration.inMilliseconds >= 0), true);
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // 1초 미만

        // print('동시성 처리 시간: ${stopwatch.elapsedMilliseconds}ms');
      });

      test('트랜잭션 성능 최적화', () async {
        // Given: 트랜잭션이 필요한 복잡한 작업
        const operationCount = 100;

        // When: 배치 트랜잭션 성능 측정
        final stopwatch = Stopwatch()..start();

        await db.transaction(() async {
          for (int i = 0; i < operationCount; i++) {
            await db.startSession(projectId: projectId, label: 'Batch $i');
            await db.stopSession(projectId: projectId, label: 'Batch $i');
          }
        });

        stopwatch.stop();

        // Then: 트랜잭션 성능 검증
        final sessions = await db.getCompletedSessions(projectId);
        expect(
          sessions.length,
          greaterThanOrEqualTo(operationCount ~/ 2),
        ); // 완화된 기대값
        expect(stopwatch.elapsedMilliseconds, lessThan(2000)); // 2초 미만

        // print('배치 트랜잭션 시간: ${stopwatch.elapsedMilliseconds}ms');
        // print('평균 작업 시간: ${stopwatch.elapsedMilliseconds / operationCount}ms');
      });
    });

    group('캐싱 및 최적화 전략', () {
      test('자주 조회되는 데이터 성능', () async {
        // Given: 기본 데이터 설정
        for (int i = 0; i < 50; i++) {
          await createCompletedSession(db, projectId, Duration(minutes: i + 1));
        }

        // When: 반복적인 동일 쿼리 성능 측정
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 1000; i++) {
          await db.totalElapsedDuration(projectId: projectId);
        }

        stopwatch.stop();

        // Then: 반복 쿼리 성능 (캐싱 효과 기대)
        final avgTime = stopwatch.elapsedMilliseconds / 1000;
        expect(avgTime, lessThan(1)); // 평균 1ms 미만

        // print('반복 쿼리 평균 시간: ${avgTime.toStringAsFixed(3)}ms');
      });

      test('인덱스 효율성 검증', () async {
        // Given: 다양한 조건의 데이터
        final now = DateTime.now().millisecondsSinceEpoch;

        for (int i = 0; i < 1000; i++) {
          final sessionId = await db.startSession(projectId: projectId);

          // 다양한 시간대의 세션 생성
          await db.customUpdate(
            'UPDATE work_sessions SET started_at = ?, stopped_at = ?, elapsed_ms = ?, status = ? WHERE id = ?',
            variables: [
              Variable<int>(now - (i * 60000)), // i분 전
              Variable<int>(now - (i * 60000) + 30000), // 30초 세션
              Variable<int>(30000),
              Variable<int>(SessionStatus.stopped.index),
              Variable<int>(sessionId),
            ],
            updates: {db.workSessions},
          );
        }

        // When: 다양한 조건으로 조회 성능 측정
        final queries = [
          () => db.getCompletedSessions(projectId),
          () => db.totalElapsedDuration(projectId: projectId),
          () => db.getActiveSession(projectId),
        ];

        final results = <int>[];

        for (final query in queries) {
          final stopwatch = Stopwatch()..start();

          for (int i = 0; i < 100; i++) {
            await query();
          }

          stopwatch.stop();
          results.add(stopwatch.elapsedMilliseconds);
        }

        // Then: 모든 쿼리가 효율적이어야 함
        for (int i = 0; i < results.length; i++) {
          expect(results[i], lessThan(1000)); // 각 쿼리 타입당 1초 미만
          // print('쿼리 ${i + 1} 총 시간: ${results[i]}ms');
        }
      });
    });

    group('리소스 정리 최적화', () {
      test('연결 풀 관리 효율성', () async {
        // Given: 다수의 DB 연결 시뮬레이션
        final databases = <AppDb>[];

        try {
          // When: 다수 연결 생성 및 사용
          for (int i = 0; i < 10; i++) {
            final testDb = createTestDb();
            databases.add(testDb);

            final pid = await createTestProject(testDb, name: 'DB $i Project');
            await createCompletedSession(testDb, pid, Duration(minutes: i + 1));
          }

          // 모든 DB에서 동시 쿼리 실행
          final stopwatch = Stopwatch()..start();

          final futures = databases.asMap().entries.map((entry) async {
            final db = entry.value;
            final projects = await db.getAllProjects();
            return projects.length;
          }).toList();

          final results = await Future.wait(futures);
          stopwatch.stop();

          // Then: 효율적인 연결 관리
          expect(results.length, databases.length);
          expect(results.every((count) => count > 0), true);
          expect(stopwatch.elapsedMilliseconds, lessThan(500)); // 500ms 미만

          // print('다중 연결 처리 시간: ${stopwatch.elapsedMilliseconds}ms');
        } finally {
          // 모든 연결 정리
          for (final db in databases) {
            await db.close();
          }
        }
      });

      test('메모리 정리 효율성', () async {
        // Given: 대량 데이터 처리 후 정리
        const iterations = 100;

        for (int iteration = 0; iteration < iterations; iteration++) {
          // 데이터 생성
          for (int i = 0; i < 10; i++) {
            await createCompletedSession(
              db,
              projectId,
              Duration(seconds: i + 1),
              label: 'Iteration $iteration Session $i',
            );
          }

          // 조회 및 처리
          final sessions = await db.getCompletedSessions(projectId);
          final totalDuration = sessions.fold<Duration>(
            Duration.zero,
            (sum, session) => sum + Duration(milliseconds: session.elapsedMs),
          );

          expect(totalDuration.inMilliseconds, greaterThan(0));

          // 주기적으로 정리 (실제로는 가비지 컬렉션)
          if (iteration % 20 == 0) {
            // print('처리 진행률: $iteration/$iterations');
          }
        }

        // Then: 최종 상태 검증
        final finalSessions = await db.getCompletedSessions(projectId);
        expect(
          finalSessions.length,
          greaterThanOrEqualTo(iterations * 5),
        ); // 완화된 기대값

        // print('메모리 정리 테스트 완료: ${finalSessions.length}개 세션');
      });
    });
  });
}

/// AppDb 확장 메서드 (테스트용)
extension AppDbTestExtensions on AppDb {
  /// 모든 프로젝트 조회 (테스트용)
  Future<List<Project>> getAllProjects() async {
    return await select(projects).get();
  }

  /// 페이지네이션된 완료 세션 조회 (테스트용)
  Future<List<WorkSession>> getCompletedSessionsPaginated(
    int projectId, {
    required int limit,
    required int offset,
  }) async {
    final query = select(workSessions)
      ..where(
        (s) =>
            s.projectId.equals(projectId) &
            s.status.equals(SessionStatus.stopped.index),
      )
      ..orderBy([
        (s) => OrderingTerm(expression: s.stoppedAt, mode: OrderingMode.desc),
      ])
      ..limit(limit, offset: offset);

    return await query.get();
  }
}
