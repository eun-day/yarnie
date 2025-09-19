import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';

import 'test_helpers.dart';

void main() {
  group('대용량 데이터 처리 성능 테스트', () {
    late AppDb db;
    late int projectId;

    setUp(() async {
      db = createTestDb();
      projectId = await createTestProject(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('다수의 완료된 세션 존재 시 성능 테스트', () {
      test('100개 완료된 세션 생성 및 조회 성능', () async {
        // Given
        const sessionCount = 100;
        final stopwatch = Stopwatch()..start();

        // When - 세션 생성
        for (int i = 0; i < sessionCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: Random().nextInt(60) + 1),
            label: '세션 $i',
            memo: '테스트 메모 $i',
          );
        }

        final creationTime = stopwatch.elapsedMilliseconds;
        print('세션 생성 시간: ${creationTime}ms');

        // 조회 성능 테스트
        stopwatch.reset();
        final sessions = await db.getCompletedSessions(projectId, limit: 50);
        final queryTime = stopwatch.elapsedMilliseconds;

        stopwatch.stop();

        // Then
        expect(sessions.length, 50);
        expect(creationTime, lessThan(10000)); // 10초 이내
        expect(queryTime, lessThan(1000)); // 1초 이내

        print('조회 시간: ${queryTime}ms');
      });

      test('페이지네이션 성능 테스트', () async {
        // Given - 200개 세션 생성
        const sessionCount = 200;
        for (int i = 0; i < sessionCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: i + 1),
            label: '페이지 테스트 $i',
          );
        }

        // When - 페이지별 조회 성능 측정
        const pageSize = 20;
        final pageTimes = <int>[];

        for (int page = 0; page < 5; page++) {
          final stopwatch = Stopwatch()..start();

          final sessions = await db.getCompletedSessions(
            projectId,
            limit: pageSize,
            offset: page * pageSize,
          );

          stopwatch.stop();
          pageTimes.add(stopwatch.elapsedMilliseconds);

          expect(sessions.length, pageSize);
        }

        // Then - 모든 페이지 조회가 일정한 성능을 보여야 함
        final avgTime = pageTimes.reduce((a, b) => a + b) / pageTimes.length;
        final maxTime = pageTimes.reduce(max);

        expect(avgTime, lessThan(500)); // 평균 0.5초 이내
        expect(maxTime, lessThan(1000)); // 최대 1초 이내

        print('페이지 조회 평균 시간: ${avgTime.toStringAsFixed(2)}ms');
        print('페이지 조회 최대 시간: ${maxTime}ms');
      });

      test('대량 데이터에서 누적 시간 계산 성능', () async {
        // Given - 다양한 길이의 세션들 생성
        const sessionCount = 100;
        var totalExpectedSeconds = 0;

        for (int i = 0; i < sessionCount; i++) {
          final minutes = Random().nextInt(60) + 1; // 1-60분
          totalExpectedSeconds += minutes * 60;

          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: minutes),
          );
        }

        // When - 누적 시간 계산 성능 측정
        final stopwatch = Stopwatch()..start();
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );
        stopwatch.stop();

        // Then
        expect(totalDuration.inSeconds, closeTo(totalExpectedSeconds, 10));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // 1초 이내

        print('누적 시간 계산: ${stopwatch.elapsedMilliseconds}ms');
        print(
          '총 누적 시간: ${totalDuration.inHours}시간 ${totalDuration.inMinutes % 60}분',
        );
      });
    });

    group('스트림 기반 실시간 데이터 업데이트 테스트', () {
      test('스트림 업데이트 성능', () async {
        // Given - 초기 세션들 생성
        const initialCount = 20;
        for (int i = 0; i < initialCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: i + 1),
          );
        }

        // When - 스트림 구독 및 추가 데이터 생성
        final streamUpdates = <List<WorkSession>>[];
        final subscription = db.watchCompletedSessions(projectId).listen((
          sessions,
        ) {
          streamUpdates.add(sessions);
        });

        // 초기 데이터 로드 대기
        await Future.delayed(Duration(milliseconds: 100));

        // 추가 세션 생성
        const additionalCount = 10;
        for (int i = 0; i < additionalCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: initialCount + i + 1),
          );

          // 스트림 업데이트 대기
          await Future.delayed(Duration(milliseconds: 50));
        }

        await Future.delayed(Duration(milliseconds: 200));

        // Then
        expect(streamUpdates.length, greaterThan(1));
        expect(streamUpdates.last.length, initialCount + additionalCount);

        await subscription.cancel();
      });

      test('활성 세션과 완료된 세션 혼합 시 성능', () async {
        // Given - 완료된 세션들 생성
        const completedCount = 50;
        for (int i = 0; i < completedCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: i + 1),
          );
        }

        // 활성 세션 시작
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 100));
        await db.pauseSession(projectId: projectId);

        // When - 누적 시간 계산 성능 측정
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 5; i++) {
          final duration = await db.totalElapsedDuration(projectId: projectId);
          expect(
            duration.inMinutes,
            greaterThanOrEqualTo(completedCount * (completedCount + 1) ~/ 2),
          );
        }

        stopwatch.stop();

        // Then
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // 1초 이내

        print('혼합 누적 시간 계산 (5회): ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('ListView 렌더링 성능 테스트', () {
      test('ListView용 데이터 준비 성능', () async {
        // Given - 세션 생성
        const sessionCount = 100;
        for (int i = 0; i < sessionCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: Random().nextInt(180) + 1),
            label: '렌더링 테스트 $i',
            memo: '상세 메모 내용 $i - 긴 텍스트를 포함한 메모',
          );
        }

        // When - 페이지별 데이터 로드 성능 측정
        const pageSize = 20; // 일반적인 ListView 페이지 크기
        final loadTimes = <int>[];

        for (int page = 0; page < 5; page++) {
          final stopwatch = Stopwatch()..start();

          final sessions = await db.getCompletedSessions(
            projectId,
            limit: pageSize,
            offset: page * pageSize,
          );

          // 렌더링에 필요한 데이터 변환 시뮬레이션
          final displayData = sessions
              .map(
                (session) => {
                  'id': session.id,
                  'label': session.label ?? '미분류',
                  'memo': session.memo ?? '',
                  'duration': Duration(milliseconds: session.elapsedMs),
                  'startedAt': DateTime.fromMillisecondsSinceEpoch(
                    session.startedAt,
                  ),
                },
              )
              .toList();

          stopwatch.stop();
          loadTimes.add(stopwatch.elapsedMilliseconds);

          expect(displayData.length, pageSize);
        }

        // Then
        final avgLoadTime =
            loadTimes.reduce((a, b) => a + b) / loadTimes.length;
        expect(avgLoadTime, lessThan(200)); // 평균 200ms 이내

        print('ListView 데이터 준비 평균 시간: ${avgLoadTime.toStringAsFixed(2)}ms');
      });

      test('검색 및 필터링 성능', () async {
        // Given - 다양한 라벨의 세션들 생성
        const labels = ['작업', '휴식', '회의', '학습', '개발'];
        const sessionCount = 100;

        for (int i = 0; i < sessionCount; i++) {
          final label = labels[i % labels.length];
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: Random().nextInt(120) + 1),
            label: '$label $i',
            memo: '메모 내용 $i',
          );
        }

        // When - 라벨별 필터링 성능 측정
        final stopwatch = Stopwatch()..start();

        final allSessions = await db.getCompletedSessions(
          projectId,
          limit: 1000,
        );

        // 클라이언트 사이드 필터링 시뮬레이션
        for (final targetLabel in labels) {
          final filtered = allSessions
              .where((session) => session.label?.contains(targetLabel) == true)
              .toList();

          expect(filtered.length, greaterThan(0));
        }

        stopwatch.stop();

        // Then
        expect(stopwatch.elapsedMilliseconds, lessThan(500)); // 0.5초 이내

        print('검색 및 필터링 시간: ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    group('종합 성능 벤치마크', () {
      test('전체 시스템 성능', () async {
        // Given
        const sessionCount = 200;
        final benchmarkResults = <String, int>{};

        // 1. 대량 데이터 생성 성능
        var stopwatch = Stopwatch()..start();
        for (int i = 0; i < sessionCount; i++) {
          await _createCompletedSession(
            db,
            projectId,
            Duration(minutes: Random().nextInt(240) + 1),
            label: '벤치마크 $i',
            memo: i % 10 == 0 ? '상세 메모 $i' : null,
          );

          if ((i + 1) % 50 == 0) {
            print('벤치마크 데이터 생성: ${i + 1}/$sessionCount');
          }
        }
        benchmarkResults['데이터 생성'] = stopwatch.elapsedMilliseconds;

        // 2. 조회 성능
        stopwatch.reset();
        final sessions = await db.getCompletedSessions(projectId, limit: 50);
        benchmarkResults['조회 (50개)'] = stopwatch.elapsedMilliseconds;

        // 3. 누적 시간 계산 성능
        stopwatch.reset();
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );
        benchmarkResults['누적 시간 계산'] = stopwatch.elapsedMilliseconds;

        // 4. 페이지네이션 성능
        stopwatch.reset();
        for (int page = 0; page < 5; page++) {
          await db.getCompletedSessions(
            projectId,
            limit: 20,
            offset: page * 20,
          );
        }
        benchmarkResults['페이지네이션 (5페이지)'] = stopwatch.elapsedMilliseconds;

        // 5. 스트림 구독 성능
        stopwatch.reset();
        final subscription = db
            .watchCompletedSessions(projectId)
            .listen((_) {});
        await Future.delayed(Duration(milliseconds: 100));
        await subscription.cancel();
        benchmarkResults['스트림 구독'] = stopwatch.elapsedMilliseconds;

        stopwatch.stop();

        // Then - 결과 출력 및 검증
        print('\n=== 성능 벤치마크 결과 ===');
        benchmarkResults.forEach((operation, time) {
          print('$operation: ${time}ms');
        });

        expect(sessions.length, 50);
        expect(totalDuration.inMinutes, greaterThan(0));
        expect(benchmarkResults['조회 (50개)']!, lessThan(1000));
        expect(benchmarkResults['누적 시간 계산']!, lessThan(1000));
        expect(benchmarkResults['페이지네이션 (5페이지)']!, lessThan(2000));
      });
    });
  });
}

// 헬퍼 함수들
Future<void> _createCompletedSession(
  AppDb db,
  int projectId,
  Duration duration, {
  String? label,
  String? memo,
}) async {
  final sessionId = await db.startSession(
    projectId: projectId,
    label: label,
    memo: memo,
  );

  // 시간 경과 시뮬레이션
  await Future.delayed(Duration(milliseconds: 1));

  // 세션 완료
  await db.stopSession(projectId: projectId, label: label, memo: memo);

  // 실제 경과 시간 설정 (테스트용)
  await db.customUpdate(
    'UPDATE work_sessions SET elapsed_ms = ? WHERE id = ?',
    variables: [
      Variable.withInt(duration.inMilliseconds),
      Variable.withInt(sessionId),
    ],
    updates: {db.workSessions},
  );
}
