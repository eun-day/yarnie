import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/providers/counter_provider.dart';
import 'package:yarnie/model/counter_data.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import '../helpers/test_helpers.dart';

/// 테스트용 카운터 프로바이더 (저장 횟수 추적 가능)
class TestCounterNotifier extends CounterNotifier {
  int saveCallCount = 0;

  @override
  Future<void> saveToDatabase() async {
    saveCallCount++;
    return super.saveToDatabase();
  }
}

/// 테스트용 프로바이더
final testCounterProvider = NotifierProvider<TestCounterNotifier, CounterState>(
  () {
    return TestCounterNotifier();
  },
);

void main() {
  group('CounterProvider 디바운싱 테스트', () {
    group('디바운싱 로직 검증', () {
      late AppDb db;
      late int projectId;
      late ProviderContainer container;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
        container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
      });

      tearDown(() async {
        await db.close();
        container.dispose();
      });

      test('연속 카운터 변경 시 DB 저장 횟수 최소화', () async {
        // Given
        final testContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = testContainer.read(testCounterProvider.notifier);

        // 프로젝트 초기화
        await notifier.initializeForProject(projectId);

        // When - 연속으로 카운터 증가 (5번)
        for (int i = 0; i < 5; i++) {
          notifier.incrementMain();
        }

        // Then - 즉시 확인: 아직 저장되지 않았어야 함
        expect(notifier.saveCallCount, 0);

        // 메모리 상태는 즉시 업데이트되어야 함
        final state = testContainer.read(testCounterProvider);
        expect(state.mainCounter, 5);

        // 200ms 대기 후 저장되었는지 확인
        await Future.delayed(const Duration(milliseconds: 250));

        // 디바운싱으로 인해 1번만 저장되어야 함
        expect(notifier.saveCallCount, 1);

        testContainer.dispose();
      });

      test('200ms 지연 후 저장되는지 확인', () async {
        // Given
        final testContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = testContainer.read(testCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When
        notifier.incrementMain();

        // Then - 100ms 후: 아직 저장되지 않았어야 함
        await Future.delayed(const Duration(milliseconds: 100));
        expect(notifier.saveCallCount, 0);

        // 추가로 150ms 대기 (총 250ms): 이제 저장되었어야 함
        await Future.delayed(const Duration(milliseconds: 150));
        expect(notifier.saveCallCount, 1);

        testContainer.dispose();
      });

      test('Provider dispose 시 강제 저장', () async {
        // Given
        final testContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = testContainer.read(testCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When
        notifier.incrementMain();

        // Then - 즉시 확인: 아직 저장되지 않았어야 함
        expect(notifier.saveCallCount, 0);

        // forceSave 호출
        await notifier.forceSave();

        // 즉시 저장되었어야 함
        expect(notifier.saveCallCount, 1);

        testContainer.dispose();
      });

      test('메모리 상태와 DB 상태 동기화', () async {
        // Given
        final testContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = testContainer.read(testCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 다양한 카운터 조작
        notifier.incrementMain();
        notifier.incrementMain();
        notifier.addSubCounter();
        notifier.incrementSub();
        notifier.setMainCountBy(3);
        notifier.setSubCountBy(2);

        // Then - 메모리 상태 확인
        final memoryState = testContainer.read(testCounterProvider);
        expect(memoryState.mainCounter, 2);
        expect(memoryState.hasSubCounter, true);
        expect(memoryState.subCounter, 1);
        expect(memoryState.mainCountBy, 3);
        expect(memoryState.subCountBy, 2);

        // 강제 저장
        await notifier.forceSave();

        // 새로운 컨테이너로 다시 로드하여 DB 상태 확인
        final newContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );

        final newNotifier = newContainer.read(counterProvider.notifier);
        await newNotifier.initializeForProject(projectId);

        final dbState = newContainer.read(counterProvider);

        // DB에서 로드한 상태가 메모리 상태와 일치해야 함
        expect(dbState.mainCounter, memoryState.mainCounter);
        expect(dbState.hasSubCounter, memoryState.hasSubCounter);
        expect(dbState.subCounter, memoryState.subCounter);
        expect(dbState.mainCountBy, memoryState.mainCountBy);
        expect(dbState.subCountBy, memoryState.subCountBy);

        testContainer.dispose();
        newContainer.dispose();
      });

      test('연속 변경 후 일정 시간 대기 시 한 번만 저장', () async {
        // Given
        final testContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = testContainer.read(testCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 빠른 연속 변경 (100ms 간격으로 5번)
        for (int i = 0; i < 5; i++) {
          notifier.incrementMain();
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Then - 아직 저장되지 않았어야 함 (마지막 변경 후 200ms가 지나지 않음)
        expect(notifier.saveCallCount, 0);

        // 200ms 추가 대기
        await Future.delayed(const Duration(milliseconds: 200));

        // 이제 한 번만 저장되었어야 함
        expect(notifier.saveCallCount, 1);

        // 메모리 상태는 모든 변경사항이 반영되어야 함
        final state = testContainer.read(testCounterProvider);
        expect(state.mainCounter, 5);

        testContainer.dispose();
      });
    });

    group('타이머 관리 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('타이머 정리 및 메모리 누수 방지', () async {
        // Given
        final testContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = testContainer.read(testCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 여러 번 카운터 변경하여 타이머 생성
        for (int i = 0; i < 10; i++) {
          notifier.incrementMain();
          await Future.delayed(
            const Duration(milliseconds: 50),
          ); // 타이머가 완료되기 전에 다시 호출
        }

        // forceSave 호출하여 타이머 정리
        await notifier.forceSave();
        final saveCountAfterForce = notifier.saveCallCount;

        // Then - 추가 대기 후에도 더 이상 저장이 발생하지 않아야 함
        await Future.delayed(const Duration(milliseconds: 300));
        expect(
          notifier.saveCallCount,
          saveCountAfterForce,
        ); // 타이머가 정리되었으므로 추가 저장 없음

        testContainer.dispose();
      });
    });

    group('실제 DB 저장 검증', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('디바운싱 후 실제 DB에 데이터가 저장되는지 확인', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(counterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When
        notifier.incrementMain();
        notifier.incrementMain();
        notifier.setMainCountBy(5);

        // 강제 저장
        await notifier.forceSave();

        // Then - DB에서 직접 조회하여 확인
        final savedData = await db.getProjectCounter(projectId);
        expect(savedData, isNotNull);
        expect(savedData!.mainCounter, 2);
        expect(savedData.mainCountBy, 5);
        expect(savedData.hasSubCounter, false);
        expect(savedData.subCounter, isNull);

        container.dispose();
      });

      test('서브 카운터 포함 데이터 저장 검증', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(counterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When
        notifier.addSubCounter();
        notifier.incrementSub();
        notifier.incrementSub();
        notifier.setSubCountBy(3);

        // 강제 저장
        await notifier.forceSave();

        // Then - DB에서 직접 조회하여 확인
        final savedData = await db.getProjectCounter(projectId);
        expect(savedData, isNotNull);
        expect(savedData!.hasSubCounter, true);
        expect(savedData.subCounter, 2);
        expect(savedData.subCountBy, 3);

        container.dispose();
      });
    });
  });
}
