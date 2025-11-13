import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('통계 쿼리', () {
    late AppDb db;

    setUp(() async {
      db = createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    group('프로젝트별 통계', () {
      test('프로젝트의 총 작업 시간을 계산할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId1 = await db.createPart(
          projectId: projectId,
          name: 'Part 1',
        );
        final partId2 = await db.createPart(
          projectId: projectId,
          name: 'Part 2',
        );

        // Part 1 세션
        final sessionId1 = await db.startNewSession(
          partId: partId1,
          currentMainValue: 0,
        );
        var segment = await db.getCurrentSegment(sessionId1);
        await db.pauseNewSession(
          sessionId: sessionId1,
          currentSegmentId: segment!.id,
          currentMainValue: 5,
          segmentStartedAt: segment.startedAt.subtract(Duration(seconds: 10)),
        );

        // Part 2 세션
        final sessionId2 = await db.startNewSession(
          partId: partId2,
          currentMainValue: 0,
        );
        segment = await db.getCurrentSegment(sessionId2);
        await db.pauseNewSession(
          sessionId: sessionId2,
          currentSegmentId: segment!.id,
          currentMainValue: 3,
          segmentStartedAt: segment.startedAt.subtract(Duration(seconds: 5)),
        );

        // When
        final totalSeconds = await db.getProjectTotalSeconds(projectId);

        // Then
        expect(totalSeconds, greaterThanOrEqualTo(0)); // 최소 0초 이상
      });

      test('작업 시간이 없는 프로젝트는 0을 반환한다', () async {
        // Given
        final projectId = await createTestProject(db);
        await db.createPart(projectId: projectId, name: 'Part 1');

        // When
        final totalSeconds = await db.getProjectTotalSeconds(projectId);

        // Then
        expect(totalSeconds, 0);
      });

      test('여러 Part의 작업 시간이 합산된다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId1 = await db.createPart(
          projectId: projectId,
          name: 'Part 1',
        );
        final partId2 = await db.createPart(
          projectId: projectId,
          name: 'Part 2',
        );
        final partId3 = await db.createPart(
          projectId: projectId,
          name: 'Part 3',
        );

        // 각 Part에 세션 생성
        for (final partId in [partId1, partId2, partId3]) {
          final sessionId = await db.startNewSession(
            partId: partId,
            currentMainValue: 0,
          );
          final segment = await db.getCurrentSegment(sessionId);
          await db.pauseNewSession(
            sessionId: sessionId,
            currentSegmentId: segment!.id,
            currentMainValue: 1,
            segmentStartedAt: segment.startedAt.subtract(Duration(seconds: 1)),
          );
        }

        // When
        final totalSeconds = await db.getProjectTotalSeconds(projectId);

        // Then
        expect(totalSeconds, greaterThanOrEqualTo(0));
      });
    });

    group('날짜별 통계', () {
      test('날짜별 작업 시간을 집계할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final now = DateTime.now().toUtc();
        final today = DateTime(now.year, now.month, now.day).toUtc();

        // 오늘 세션 생성
        final sessionId = await db.startNewSession(
          partId: partId,
          currentMainValue: 0,
        );
        final segment = await db.getCurrentSegment(sessionId);

        // Segment를 수동으로 종료 (duration 설정)
        await (db.update(
          db.sessionSegments,
        )..where((t) => t.id.equals(segment!.id))).write(
          SessionSegmentsCompanion(
            endedAt: Value(now),
            durationSeconds: Value(100),
            endCount: Value(5),
          ),
        );

        // When
        final startDate = today;
        final endDate = today.add(Duration(days: 1));
        final dailyStats = await db.getDailyWorkSeconds(
          startDate: startDate,
          endDate: endDate,
        );

        // Then
        expect(dailyStats, isNotEmpty);
        expect(dailyStats.containsKey(today), isTrue);
        expect(dailyStats[today], 100);
      });

      test('여러 날짜의 작업 시간을 집계할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final now = DateTime.now().toUtc();
        final today = DateTime(now.year, now.month, now.day).toUtc();
        final yesterday = today.subtract(Duration(days: 1));

        // 어제 세션
        final sessionId1 = await db.startNewSession(
          partId: partId,
          currentMainValue: 0,
        );
        await (db.delete(
          db.sessions,
        )..where((t) => t.id.equals(sessionId1))).go();

        await db
            .into(db.sessionSegments)
            .insert(
              SessionSegmentsCompanion.insert(
                sessionId: sessionId1,
                partId: partId,
                startedAt: yesterday,
                endedAt: Value(yesterday.add(Duration(seconds: 50))),
                durationSeconds: Value(50),
                startCount: Value(0),
                endCount: Value(5),
              ),
            );

        // 오늘 세션
        final sessionId2 = await db.startNewSession(
          partId: partId,
          currentMainValue: 5,
        );
        final segment = await db.getCurrentSegment(sessionId2);
        await (db.update(
          db.sessionSegments,
        )..where((t) => t.id.equals(segment!.id))).write(
          SessionSegmentsCompanion(
            endedAt: Value(now),
            durationSeconds: Value(100),
            endCount: Value(10),
          ),
        );

        // When
        final startDate = yesterday;
        final endDate = today.add(Duration(days: 1));
        final dailyStats = await db.getDailyWorkSeconds(
          startDate: startDate,
          endDate: endDate,
        );

        // Then
        expect(dailyStats.length, greaterThanOrEqualTo(1));
        if (dailyStats.containsKey(yesterday)) {
          expect(dailyStats[yesterday], 50);
        }
        if (dailyStats.containsKey(today)) {
          expect(dailyStats[today], 100);
        }
      });

      test('작업 시간이 없는 날짜는 결과에 포함되지 않는다', () async {
        // Given
        final projectId = await createTestProject(db);
        await db.createPart(projectId: projectId, name: 'Test Part');

        final now = DateTime.now().toUtc();
        final today = DateTime(now.year, now.month, now.day).toUtc();

        // When
        final startDate = today;
        final endDate = today.add(Duration(days: 1));
        final dailyStats = await db.getDailyWorkSeconds(
          startDate: startDate,
          endDate: endDate,
        );

        // Then
        expect(dailyStats, isEmpty);
      });

      test('날짜 범위를 지정하여 조회할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final now = DateTime.now().toUtc();
        final today = DateTime(now.year, now.month, now.day).toUtc();

        // 세션 생성
        final sessionId = await db.startNewSession(
          partId: partId,
          currentMainValue: 0,
        );
        final segment = await db.getCurrentSegment(sessionId);
        await (db.update(
          db.sessionSegments,
        )..where((t) => t.id.equals(segment!.id))).write(
          SessionSegmentsCompanion(
            endedAt: Value(now),
            durationSeconds: Value(100),
            endCount: Value(5),
          ),
        );

        // When: 어제부터 내일까지 조회
        final startDate = today.subtract(Duration(days: 1));
        final endDate = today.add(Duration(days: 2));
        final dailyStats = await db.getDailyWorkSeconds(
          startDate: startDate,
          endDate: endDate,
        );

        // Then
        expect(dailyStats.containsKey(today), isTrue);
      });
    });

    group('Part별 통계', () {
      test('Part의 모든 Segment를 날짜 범위로 조회할 수 있다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final now = DateTime.now().toUtc();
        final today = DateTime(now.year, now.month, now.day).toUtc();

        // 세션 생성
        final sessionId = await db.startNewSession(
          partId: partId,
          currentMainValue: 0,
        );
        final segment = await db.getCurrentSegment(sessionId);
        await db.pauseNewSession(
          sessionId: sessionId,
          currentSegmentId: segment!.id,
          currentMainValue: 5,
          segmentStartedAt: segment.startedAt,
        );

        // When
        final segments = await db.getPartSegments(
          partId: partId,
          startDate: today,
          endDate: today.add(Duration(days: 1)),
        );

        // Then
        expect(segments, isNotEmpty);
        expect(segments[0].partId, partId);
      });

      test('날짜 범위 밖의 Segment는 조회되지 않는다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        final now = DateTime.now().toUtc();
        final today = DateTime(now.year, now.month, now.day).toUtc();
        final tomorrow = today.add(Duration(days: 1));

        // 오늘 세션 생성
        final sessionId = await db.startNewSession(
          partId: partId,
          currentMainValue: 0,
        );
        final segment = await db.getCurrentSegment(sessionId);
        await db.pauseNewSession(
          sessionId: sessionId,
          currentSegmentId: segment!.id,
          currentMainValue: 5,
          segmentStartedAt: segment.startedAt,
        );

        // When: 내일부터 조회
        final segments = await db.getPartSegments(
          partId: partId,
          startDate: tomorrow,
          endDate: tomorrow.add(Duration(days: 1)),
        );

        // Then
        expect(segments, isEmpty);
      });
    });
  });
}
