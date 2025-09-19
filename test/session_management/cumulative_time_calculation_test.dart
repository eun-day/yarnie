import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'test_helpers.dart';

void main() {
  group('4. 누적 시간 계산 정확성 테스트', () {
    group('4.1 totalElapsedDuration 메서드 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('should calculate sum of stopped sessions correctly', () async {
        // Given - 여러 개의 완료된 세션 생성
        await createCompletedSession(
          db,
          projectId,
          Duration(minutes: 5),
          label: 'Session 1',
        );
        await createCompletedSession(
          db,
          projectId,
          Duration(minutes: 3),
          label: 'Session 2',
        );
        await createCompletedSession(
          db,
          projectId,
          Duration(minutes: 2),
          label: 'Session 3',
        );

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 총 10분이어야 함
        expect(totalDuration.inMinutes, 10);
        expect(totalDuration.inSeconds, 600);
      });

      test('should return zero when no sessions exist', () async {
        // Given - 세션이 없는 상태

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then
        expect(totalDuration, Duration.zero);
      });

      test('should include active session in total calculation', () async {
        // Given - 완료된 세션 1개 + 활성 세션 1개
        await createCompletedSession(db, projectId, Duration(minutes: 5));

        // 활성 세션 생성 (paused 상태)
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 200));
        await db.pauseSession(projectId: projectId);

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션(5분) + 활성 세션(약간의 시간)
        expect(totalDuration.inMinutes, greaterThanOrEqualTo(5));
        expect(totalDuration.inSeconds, greaterThanOrEqualTo(300)); // 5분 이상
      });

      test('should calculate running session real-time correctly', () async {
        // Given - 완료된 세션 + running 상태 활성 세션
        await createCompletedSession(db, projectId, Duration(minutes: 3));

        // running 상태 세션 생성
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 500));

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션(3분) + 실행 중인 세션(약 0.5초)
        expect(totalDuration.inMinutes, greaterThanOrEqualTo(3));
        expect(totalDuration.inSeconds, greaterThanOrEqualTo(180)); // 3분 이상
      });

      test('should calculate paused session time accurately', () async {
        // Given - 완료된 세션 + paused 상태 활성 세션
        await createCompletedSession(db, projectId, Duration(minutes: 2));

        // paused 상태 세션 생성 (정확한 시간으로)
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 3));
        await db.pauseSession(projectId: projectId);

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션(2분) + 일시정지된 세션(3초)
        expect(totalDuration.inSeconds, closeTo(123, 1)); // 2분 3초 ±1초
      });

      test(
        'should handle multiple active sessions for different projects',
        () async {
          // Given - 두 번째 프로젝트 생성
          final secondProjectId = await createTestProject(
            db,
            name: 'Second Project',
          );

          // 첫 번째 프로젝트: 완료된 세션 + 활성 세션
          await createCompletedSession(db, projectId, Duration(minutes: 5));
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 200));
          await db.pauseSession(projectId: projectId);

          // 두 번째 프로젝트: 완료된 세션만
          await createCompletedSession(
            db,
            secondProjectId,
            Duration(minutes: 3),
          );

          // When
          final firstProjectTotal = await db.totalElapsedDuration(
            projectId: projectId,
          );
          final secondProjectTotal = await db.totalElapsedDuration(
            projectId: secondProjectId,
          );

          // Then
          expect(firstProjectTotal.inMinutes, greaterThanOrEqualTo(5));
          expect(secondProjectTotal.inMinutes, 3);
          expect(secondProjectTotal.inSeconds, 180);
        },
      );

      test(
        'should not include stopped sessions in active calculation',
        () async {
          // Given - 여러 상태의 세션들
          await createCompletedSession(db, projectId, Duration(minutes: 5));
          await createCompletedSession(db, projectId, Duration(minutes: 3));

          // 활성 세션 생성 후 중지
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 200));
          await db.stopSession(projectId: projectId);

          // When
          final totalDuration = await db.totalElapsedDuration(
            projectId: projectId,
          );

          // Then - 모든 stopped 세션의 합계 (8분 + 약간)
          expect(totalDuration.inMinutes, greaterThanOrEqualTo(8));
          expect(totalDuration.inSeconds, greaterThanOrEqualTo(480)); // 8분 이상
        },
      );

      test('should handle complex session lifecycle accurately', () async {
        // Given - 복잡한 세션 라이프사이클
        // 1. 완료된 세션 2개
        await createCompletedSession(db, projectId, Duration(minutes: 2));
        await createCompletedSession(db, projectId, Duration(minutes: 3));

        // 2. 활성 세션: 시작 → 일시정지 → 재개 → 일시정지
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));
        await db.pauseSession(projectId: projectId);

        await db.resumeSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 2));
        await db.pauseSession(projectId: projectId);

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션(5분) + 활성 세션(약 3초)
        expect(totalDuration.inSeconds, closeTo(303, 2)); // 5분 3초 ±2초
      });

      test('should maintain accuracy with very short durations', () async {
        // Given - 매우 짧은 시간의 세션들
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 50));
        await db.stopSession(projectId: projectId);

        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(milliseconds: 100));
        await db.pauseSession(projectId: projectId);

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 매우 짧은 시간도 정확히 계산되어야 함
        expect(totalDuration.inMilliseconds, greaterThanOrEqualTo(0));
        expect(totalDuration.inMilliseconds, lessThan(1000)); // 1초 미만
      });

      test('should handle edge case with zero elapsed time', () async {
        // Given - 즉시 중지된 세션
        await db.startSession(projectId: projectId);
        await db.stopSession(projectId: projectId); // 즉시 중지

        // When
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 0 이상의 값이어야 함 (음수가 되면 안됨)
        expect(totalDuration.inMilliseconds, greaterThanOrEqualTo(0));
      });
    });

    group('4.2 화면 진입 시 초기 누적 시간 표시 테스트', () {
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
        'should display correct initial cumulative time on screen entry',
        () async {
          // Given - 기존 완료된 세션들이 있는 상태
          await createCompletedSession(
            db,
            projectId,
            Duration(minutes: 3),
            label: 'Session 1',
          );
          await createCompletedSession(
            db,
            projectId,
            Duration(minutes: 2),
            label: 'Session 2',
          );

          // When - 화면 진입 시 누적 시간 조회 (DB 기준)
          final totalDuration = await db.totalElapsedDuration(
            projectId: projectId,
          );

          // Then - 완료된 세션들의 시간이 정확히 반영되어야 함
          expect(totalDuration.inMinutes, 5); // 3분 + 2분
          expect(totalDuration.inSeconds, 300);
        },
      );

      test('should include active paused session in initial display', () async {
        // Given - 완료된 세션 + 일시정지된 활성 세션
        await createCompletedSession(db, projectId, Duration(minutes: 4));

        // 활성 세션 생성 후 일시정지
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 2));
        await db.pauseSession(projectId: projectId);

        // When - 화면 진입 시 총 누적 시간
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션(4분) + 활성 세션(2초)
        expect(totalDuration.inSeconds, closeTo(242, 1)); // 4분 2초 ±1초
      });

      test(
        'should include active running session in initial display',
        () async {
          // Given - 완료된 세션 + 실행 중인 활성 세션
          await createCompletedSession(db, projectId, Duration(minutes: 2));

          // 실행 중인 활성 세션 생성
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(seconds: 1));

          // When - 화면 진입 시 총 누적 시간
          final totalDuration = await db.totalElapsedDuration(
            projectId: projectId,
          );

          // Then - 완료된 세션(2분) + 실행 중인 세션(1초)
          expect(
            totalDuration.inSeconds,
            greaterThanOrEqualTo(121),
          ); // 2분 1초 이상
        },
      );

      test('should handle screen entry with no existing sessions', () async {
        // Given - 세션이 전혀 없는 상태

        // When - 화면 진입 시 누적 시간
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 0이어야 함
        expect(totalDuration, Duration.zero);
      });

      test('should restore correct time after session discard', () async {
        // Given - 완료된 세션 + 진행 중인 세션
        await createCompletedSession(db, projectId, Duration(minutes: 3));

        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 2));
        await db.pauseSession(projectId: projectId);

        // 진행 중인 세션이 있는 상태에서 총 시간 확인
        final beforeDiscard = await db.totalElapsedDuration(
          projectId: projectId,
        );
        expect(beforeDiscard.inSeconds, greaterThan(180)); // 3분 이상

        // When - 활성 세션 삭제 후 DB에서 시간 복원
        await db.discardActiveSession(projectId: projectId);
        final afterDiscard = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션의 시간만 남아야 함
        expect(afterDiscard.inMinutes, 3);
        expect(afterDiscard.inSeconds, 180);
      });

      test('should handle multiple projects independently', () async {
        // Given - 두 개의 프로젝트에 각각 다른 세션들
        final secondProjectId = await createTestProject(
          db,
          name: 'Second Project',
        );

        // 첫 번째 프로젝트: 완료된 세션 2개
        await createCompletedSession(db, projectId, Duration(minutes: 5));
        await createCompletedSession(db, projectId, Duration(minutes: 3));

        // 두 번째 프로젝트: 완료된 세션 1개 + 활성 세션
        await createCompletedSession(db, secondProjectId, Duration(minutes: 2));
        await db.startSession(projectId: secondProjectId);
        await Future.delayed(Duration(seconds: 1));
        await db.pauseSession(projectId: secondProjectId);

        // When - 각 프로젝트의 누적 시간 조회
        final firstProjectTotal = await db.totalElapsedDuration(
          projectId: projectId,
        );
        final secondProjectTotal = await db.totalElapsedDuration(
          projectId: secondProjectId,
        );

        // Then - 각각 독립적으로 계산되어야 함
        expect(firstProjectTotal.inMinutes, 8); // 5분 + 3분
        expect(
          secondProjectTotal.inSeconds,
          greaterThanOrEqualTo(121),
        ); // 2분 1초 이상
      });

      test('should maintain accuracy across complex session states', () async {
        // Given - 복잡한 세션 상태들
        // 1. 완료된 세션 2개
        await createCompletedSession(db, projectId, Duration(minutes: 2));
        await createCompletedSession(db, projectId, Duration(minutes: 1));

        // 2. 활성 세션: 시작 → 일시정지 → 재개 → 일시정지
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));
        await db.pauseSession(projectId: projectId);

        await db.resumeSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));
        await db.pauseSession(projectId: projectId);

        // When - 화면 진입 시 총 누적 시간
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 완료된 세션(3분) + 활성 세션(약 2초)
        expect(totalDuration.inSeconds, closeTo(182, 2)); // 3분 2초 ±2초
      });

      test('should handle very large accumulated time correctly', () async {
        // Given - 많은 완료된 세션들 (큰 누적 시간)
        for (int i = 0; i < 10; i++) {
          await createCompletedSession(
            db,
            projectId,
            Duration(minutes: 30), // 각각 30분
            label: 'Session $i',
          );
        }

        // When - 화면 진입 시 누적 시간
        final totalDuration = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 총 300분 (5시간)
        expect(totalDuration.inMinutes, 300);
        expect(totalDuration.inHours, 5);
      });

      test(
        'should handle edge case with immediately stopped session',
        () async {
          // Given - 즉시 중지된 세션
          await db.startSession(projectId: projectId);
          await db.stopSession(projectId: projectId); // 즉시 중지

          // When - 화면 진입 시 누적 시간
          final totalDuration = await db.totalElapsedDuration(
            projectId: projectId,
          );

          // Then - 0 이상의 값 (음수가 되면 안됨)
          expect(totalDuration.inMilliseconds, greaterThanOrEqualTo(0));
        },
      );
    });

    group('4.3 세션 라이프사이클 전체에서 누적 시간 정확성 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('should maintain continuity when starting new session', () async {
        // Given - 기존 완료된 세션들
        await createCompletedSession(
          db,
          projectId,
          Duration(minutes: 5),
          label: 'Previous Session 1',
        );
        await createCompletedSession(
          db,
          projectId,
          Duration(minutes: 3),
          label: 'Previous Session 2',
        );

        final existingTotal = await db.totalElapsedDuration(
          projectId: projectId,
        );
        expect(existingTotal.inMinutes, 8); // 기존 8분

        // When - 새 세션 시작
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 2));

        final totalWithNewSession = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 기존 누적 시간 + 새 세션 시간
        expect(
          totalWithNewSession.inSeconds,
          greaterThanOrEqualTo(482),
        ); // 8분 2초 이상
      });

      test('should maintain accuracy through pause/resume cycles', () async {
        // Given - 기존 완료된 세션
        await createCompletedSession(db, projectId, Duration(minutes: 2));

        // When - 새 세션으로 일시정지/재개 사이클 수행
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));

        // 첫 번째 일시정지
        await db.pauseSession(projectId: projectId);
        final afterFirstPause = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // 재개 후 다시 실행
        await db.resumeSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));

        // 두 번째 일시정지
        await db.pauseSession(projectId: projectId);
        final afterSecondPause = await db.totalElapsedDuration(
          projectId: projectId,
        );

        // Then - 각 단계에서 시간이 누적되어야 함
        expect(afterFirstPause.inSeconds, closeTo(121, 1)); // 2분 1초 ±1초
        expect(afterSecondPause.inSeconds, closeTo(122, 2)); // 2분 2초 ±2초
        expect(
          afterSecondPause.inSeconds,
          greaterThan(afterFirstPause.inSeconds),
        );
      });

      test(
        'should calculate final total correctly after session completion',
        () async {
          // Given - 기존 완료된 세션
          await createCompletedSession(db, projectId, Duration(minutes: 3));

          // When - 새 세션 전체 라이프사이클 수행
          await db.startSession(projectId: projectId);
          await Future.delayed(Duration(seconds: 2));

          await db.pauseSession(projectId: projectId);
          await Future.delayed(Duration(milliseconds: 100)); // 일시정지 중 대기

          await db.resumeSession(projectId: projectId);
          await Future.delayed(Duration(seconds: 1));

          // 세션 완료
          await db.stopSession(
            projectId: projectId,
            label: 'Completed Session',
          );

          // Then - 최종 누적 시간 확인
          final finalTotal = await db.totalElapsedDuration(
            projectId: projectId,
          );

          expect(finalTotal.inSeconds, closeTo(183, 2)); // 3분 3초 ±2초
        },
      );

      test('should restore correct time after session reset', () async {
        // Given - 완료된 세션 + 진행 중인 세션
        await createCompletedSession(db, projectId, Duration(minutes: 4));

        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 3));
        await db.pauseSession(projectId: projectId);

        // 진행 중인 세션이 포함된 총 시간 확인
        final beforeReset = await db.totalElapsedDuration(projectId: projectId);
        expect(beforeReset.inSeconds, greaterThan(240)); // 4분 이상

        // When - 세션 초기화 (활성 세션 삭제)
        await db.discardActiveSession(projectId: projectId);

        // Then - 완료된 세션의 시간으로 복원
        final afterReset = await db.totalElapsedDuration(projectId: projectId);
        expect(afterReset.inMinutes, 4);
        expect(afterReset.inSeconds, 240);
      });

      test('should handle multiple complete session lifecycles', () async {
        // Given - 초기 상태 (세션 없음)
        var currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal, Duration.zero);

        // When - 첫 번째 세션 라이프사이클
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 2));
        await db.stopSession(projectId: projectId, label: 'Session 1');

        currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal.inSeconds, closeTo(2, 1));

        // 두 번째 세션 라이프사이클 (일시정지 포함)
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));
        await db.pauseSession(projectId: projectId);
        await db.resumeSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));
        await db.stopSession(projectId: projectId, label: 'Session 2');

        currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal.inSeconds, closeTo(4, 2)); // 약 4초 ±2초

        // 세 번째 세션 라이프사이클
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 3));
        await db.stopSession(projectId: projectId, label: 'Session 3');

        // Then - 모든 세션의 누적 시간
        final finalTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(finalTotal.inSeconds, closeTo(7, 3)); // 약 7초 ±3초
      });

      test('should maintain accuracy with interrupted session flows', () async {
        // Given - 기존 완료된 세션
        await createCompletedSession(db, projectId, Duration(minutes: 1));

        // When - 중단된 세션 플로우들
        // 1. 시작 후 즉시 초기화
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 1));
        await db.discardActiveSession(projectId: projectId);

        var currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal.inMinutes, 1); // 기존 세션만 남음

        // 2. 시작 → 일시정지 → 초기화
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 2));
        await db.pauseSession(projectId: projectId);
        await db.discardActiveSession(projectId: projectId);

        currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal.inMinutes, 1); // 여전히 기존 세션만

        // 3. 정상적인 세션 완료
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 3));
        await db.stopSession(projectId: projectId);

        // Then - 최종적으로 기존 세션 + 마지막 완료된 세션
        final finalTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(finalTotal.inSeconds, closeTo(63, 2)); // 1분 3초 ±2초
      });

      test('should handle concurrent operations correctly', () async {
        // Given - 기존 완료된 세션
        await createCompletedSession(db, projectId, Duration(minutes: 2));

        // When - 빠른 연속 작업들
        await db.startSession(projectId: projectId);

        // 매우 짧은 간격으로 여러 작업 수행
        await Future.delayed(Duration(milliseconds: 100));
        await db.pauseSession(projectId: projectId);

        await Future.delayed(Duration(milliseconds: 50));
        await db.resumeSession(projectId: projectId);

        await Future.delayed(Duration(milliseconds: 100));
        await db.pauseSession(projectId: projectId);

        await Future.delayed(Duration(milliseconds: 50));
        await db.resumeSession(projectId: projectId);

        await Future.delayed(Duration(milliseconds: 100));
        await db.stopSession(projectId: projectId);

        // Then - 모든 작업이 정확히 반영되어야 함
        final finalTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(finalTotal.inSeconds, greaterThanOrEqualTo(120)); // 최소 2분
        expect(finalTotal.inSeconds, lessThan(125)); // 최대 2분 5초
      });

      test('should maintain precision across very long sessions', () async {
        // Given - 긴 시간의 완료된 세션
        await createCompletedSession(
          db,
          projectId,
          Duration(hours: 2, minutes: 30), // 2시간 30분
        );

        // When - 추가 세션 수행
        await db.startSession(projectId: projectId);
        await Future.delayed(Duration(seconds: 5));
        await db.stopSession(projectId: projectId);

        // Then - 큰 시간에서도 정확성 유지
        final finalTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(finalTotal.inHours, 2);
        expect(finalTotal.inMinutes, greaterThanOrEqualTo(150)); // 2시간 30분 이상
        expect(finalTotal.inSeconds, closeTo(9005, 3)); // 2시간 30분 5초 ±3초
      });

      test('should handle edge cases in session lifecycle', () async {
        // Given - 다양한 엣지 케이스들

        // 1. 즉시 시작/중지
        await db.startSession(projectId: projectId);
        await db.stopSession(projectId: projectId);

        var currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal.inMilliseconds, greaterThanOrEqualTo(0));

        // 2. 시작 → 즉시 일시정지 → 즉시 재개 → 즉시 중지
        await db.startSession(projectId: projectId);
        await db.pauseSession(projectId: projectId);
        await db.resumeSession(projectId: projectId);
        await db.stopSession(projectId: projectId);

        currentTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(currentTotal.inMilliseconds, greaterThanOrEqualTo(0));

        // 3. 여러 번의 즉시 세션들
        for (int i = 0; i < 5; i++) {
          await db.startSession(projectId: projectId);
          await db.stopSession(projectId: projectId);
        }

        // Then - 모든 엣지 케이스가 정상 처리되어야 함
        final finalTotal = await db.totalElapsedDuration(projectId: projectId);
        expect(finalTotal.inMilliseconds, greaterThanOrEqualTo(0));
        expect(finalTotal.inSeconds, lessThan(5)); // 합리적인 범위 내
      });
    });
  });
}
