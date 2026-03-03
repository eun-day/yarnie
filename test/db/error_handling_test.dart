import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:yarnie/db/app_db.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('데이터베이스 에러 처리', () {
    late AppDb db;

    setUp(() async {
      db = createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    group('커스텀 예외 클래스', () {
      test('DatabaseException은 메시지와 원인을 포함한다', () {
        final exception = DatabaseException('테스트 메시지', Exception('원인'));
        expect(exception.message, '테스트 메시지');
        expect(exception.cause, isNotNull);
        expect(exception.toString(), contains('테스트 메시지'));
        expect(exception.toString(), contains('원인'));
      });

      test('ForeignKeyConstraintException은 DatabaseException을 상속한다', () {
        final exception = ForeignKeyConstraintException('외래키 위반');
        expect(exception, isA<DatabaseException>());
        expect(exception.toString(), contains('ForeignKeyConstraintException'));
      });

      test('UniqueConstraintException은 DatabaseException을 상속한다', () {
        final exception = UniqueConstraintException('고유성 위반');
        expect(exception, isA<DatabaseException>());
        expect(exception.toString(), contains('UniqueConstraintException'));
      });

      test('DataIntegrityException은 DatabaseException을 상속한다', () {
        final exception = DataIntegrityException('데이터 무결성 위반');
        expect(exception, isA<DatabaseException>());
        expect(exception.toString(), contains('DataIntegrityException'));
      });

      test('RecordNotFoundException은 DatabaseException을 상속한다', () {
        final exception = RecordNotFoundException('레코드 없음');
        expect(exception, isA<DatabaseException>());
        expect(exception.toString(), contains('RecordNotFoundException'));
      });
    });

    group('Part 관련 에러 처리', () {
      test('존재하지 않는 프로젝트에 Part 생성 시 RecordNotFoundException 발생', () async {
        expect(
          () => db.createPart(projectId: 99999, name: 'Test Part'),
          throwsA(isA<RecordNotFoundException>()),
        );
      });

      test('존재하지 않는 Part 조회 시 null 반환', () async {
        final part = await db.getPart(99999);
        expect(part, isNull);
      });

      test('존재하지 않는 Part 삭제 시 RecordNotFoundException 발생', () async {
        expect(
          () => db.deletePart(99999),
          throwsA(isA<RecordNotFoundException>()),
        );
      });
    });

    group('Session 관련 에러 처리', () {
      test('존재하지 않는 Part에 세션 시작 시 RecordNotFoundException 발생', () async {
        expect(
          () => db.createSession(partId: 99999, currentMainValue: 0),
          throwsA(isA<RecordNotFoundException>()),
        );
      });

      test('이미 세션이 있는 Part에 세션 시작 시 DataIntegrityException 발생', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        await db.createSession(partId: partId, currentMainValue: 0);

        // When & Then
        expect(
          () => db.createSession(partId: partId, currentMainValue: 0),
          throwsA(isA<DataIntegrityException>()),
        );
      });

      test('존재하지 않는 세션 일시정지 시 RecordNotFoundException 발생', () async {
        expect(
          () => db.pausePartSession(
            sessionId: 99999,
            currentSegmentId: 1,
            currentMainValue: 0,
            segmentStartedAt: DateTime.now(),
          ),
          throwsA(isA<RecordNotFoundException>()),
        );
      });

      test('실행 중이 아닌 세션 일시정지 시 DataIntegrityException 발생', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final sessionId = await db.createSession(
          partId: partId,
          currentMainValue: 0,
        );
        final segment = await db.getCurrentSegment(sessionId);

        // 세션 일시정지
        await db.pausePartSession(
          sessionId: sessionId,
          currentSegmentId: segment!.id,
          currentMainValue: 0,
          segmentStartedAt: segment.startedAt,
        );

        // When & Then: 이미 일시정지된 세션을 다시 일시정지
        expect(
          () => db.pausePartSession(
            sessionId: sessionId,
            currentSegmentId: segment.id,
            currentMainValue: 0,
            segmentStartedAt: segment.startedAt,
          ),
          throwsA(isA<DataIntegrityException>()),
        );
      });

      test('일시정지 상태가 아닌 세션 재시작 시 DataIntegrityException 발생', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );
        final sessionId = await db.createSession(
          partId: partId,
          currentMainValue: 0,
        );

        // When & Then: 실행 중인 세션을 재시작
        expect(
          () => db.resumePartSession(
            sessionId: sessionId,
            partId: partId,
            currentMainValue: 0,
          ),
          throwsA(isA<DataIntegrityException>()),
        );
      });
    });

    group('Counter 관련 에러 처리', () {
      test(
        '존재하지 않는 Part에 StitchCounter 생성 시 RecordNotFoundException 발생',
        () async {
          expect(
            () => db.createStitchCounter(
              partId: 99999,
              name: 'Test Counter',
              newOrderJson: '[]',
            ),
            throwsA(isA<RecordNotFoundException>()),
          );
        },
      );

      test(
        '존재하지 않는 Part에 SectionCounter 생성 시 RecordNotFoundException 발생',
        () async {
          expect(
            () => db.createSectionCounter(
              partId: 99999,
              name: 'Test Counter',
              specJson: '{"type":"range","startRow":0,"rowsTotal":10}',
              newOrderJson: '[]',
            ),
            throwsA(isA<RecordNotFoundException>()),
          );
        },
      );

      test(
        '존재하지 않는 Part의 MainCounter 업데이트 시 RecordNotFoundException 발생',
        () async {
          expect(
            () => db.updateMainCounter(partId: 99999, newValue: 10),
            throwsA(isA<RecordNotFoundException>()),
          );
        },
      );
    });

    group('Tag 관련 에러 처리', () {
      test('중복된 태그 이름 생성 시 UniqueConstraintException 발생', () async {
        // Given
        await db.createTag(name: 'Test Tag', color: 0xFF000000);

        // When & Then
        expect(
          () => db.createTag(name: 'Test Tag', color: 0xFF111111),
          throwsA(isA<UniqueConstraintException>()),
        );
      });

      test('존재하지 않는 태그 삭제 시 RecordNotFoundException 발생', () async {
        expect(
          () => db.deleteTag(99999),
          throwsA(isA<RecordNotFoundException>()),
        );
      });
    });

    group('PartNote 관련 에러 처리', () {
      test('존재하지 않는 Part에 메모 생성 시 RecordNotFoundException 발생', () async {
        expect(
          () => db.createPartNote(partId: 99999, content: 'Test Note'),
          throwsA(isA<RecordNotFoundException>()),
        );
      });
    });

    group('애플리케이션 레벨 검증', () {
      test('Part당 MainCounter는 1개만 존재해야 한다', () async {
        // Given
        final projectId = await createTestProject(db);
        final partId = await db.createPart(
          projectId: projectId,
          name: 'Test Part',
        );

        // MainCounter는 자동으로 1개 생성됨
        final mainCounter = await db.getMainCounter(partId);
        expect(mainCounter, isNotNull);

        // 직접 MainCounter를 추가로 생성 (테스트용)
        await db
            .into(db.mainCounters)
            .insert(
              MainCountersCompanion.insert(
                partId: partId,
                currentValue: const Value(0),
              ),
            );

        // When & Then: MainCounter 업데이트 시 검증 실패
        expect(
          () => db.updateMainCounter(partId: partId, newValue: 10),
          throwsA(isA<DataIntegrityException>()),
        );
      });
    });
  });
}
