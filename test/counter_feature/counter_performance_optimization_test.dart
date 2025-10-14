import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/providers/counter_provider.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import '../helpers/test_helpers.dart';

/// 성능 측정을 위한 테스트용 카운터 프로바이더
class PerformanceCounterNotifier extends CounterNotifier {
  int saveCallCount = 0;
  int rebuildCount = 0;
  List<DateTime> saveTimestamps = [];

  @override
  Future<void> saveToDatabase() async {
    saveCallCount++;
    saveTimestamps.add(DateTime.now());
    return super.saveToDatabase();
  }

  @override
  CounterState build() {
    rebuildCount++;
    return super.build();
  }
}

/// 성능 테스트용 프로바이더
final performanceCounterProvider =
    NotifierProvider<PerformanceCounterNotifier, CounterState>(() {
      return PerformanceCounterNotifier();
    });

void main() {
  group('CounterProvider 성능 최적화 검증', () {
    group('UI 반응성 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('연속 탭 시 UI 반응성 확인', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(performanceCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 매우 빠른 연속 탭 시뮬레이션 (50번, 10ms 간격)
        final startTime = DateTime.now();

        for (int i = 0; i < 50; i++) {
          notifier.incrementMain();
          // 실제 UI에서는 이보다 빠를 수 있음
          await Future.delayed(const Duration(milliseconds: 10));
        }

        final endTime = DateTime.now();
        final totalTime = endTime.difference(startTime);

        // Then - UI 반응성 검증
        final state = container.read(performanceCounterProvider);

        // 모든 탭이 즉시 반영되어야 함
        expect(state.mainCounter, 50);

        // 전체 처리 시간이 합리적이어야 함 (1초 이내)
        expect(totalTime.inMilliseconds, lessThan(1000));

        // DB 저장은 아직 발생하지 않았어야 함 (디바운싱)
        expect(notifier.saveCallCount, 0);

        // 200ms 대기 후 저장 확인
        await Future.delayed(const Duration(milliseconds: 250));

        // 디바운싱으로 인해 1번만 저장되어야 함
        expect(notifier.saveCallCount, 1);

        container.dispose();
      });

      test('DB 접근 횟수 모니터링 및 최적화 검증', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(performanceCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 다양한 카운터 조작 (100번)
        for (int i = 0; i < 25; i++) {
          notifier.incrementMain();
          notifier.decrementMain();
          notifier.incrementMain();
          notifier.incrementMain(); // 총 50번 증가
        }

        // 서브 카운터 조작
        notifier.addSubCounter();
        for (int i = 0; i < 25; i++) {
          notifier.incrementSub();
        }

        // count by 변경
        notifier.setMainCountBy(3);
        notifier.setSubCountBy(2);

        // Then - 즉시 확인: DB 저장이 아직 발생하지 않았어야 함
        expect(notifier.saveCallCount, 0);

        // 메모리 상태는 모든 변경사항이 반영되어야 함
        final state = container.read(performanceCounterProvider);
        expect(state.mainCounter, 50);
        expect(state.hasSubCounter, true);
        expect(state.subCounter, 25);
        expect(state.mainCountBy, 3);
        expect(state.subCountBy, 2);

        // 디바운싱 대기
        await Future.delayed(const Duration(milliseconds: 250));

        // 모든 변경사항에 대해 1번만 저장되어야 함
        expect(notifier.saveCallCount, 1);

        container.dispose();
      });

      test('메모리 사용량 및 타이머 정리 확인', () async {
        // Given
        final containers = <ProviderContainer>[];

        // When - 여러 컨테이너 생성 및 사용
        for (int i = 0; i < 10; i++) {
          final container = ProviderContainer(
            overrides: [appDbProvider.overrideWithValue(db)],
          );
          containers.add(container);

          final notifier = container.read(performanceCounterProvider.notifier);
          await notifier.initializeForProject(projectId);

          // 각 컨테이너에서 카운터 조작
          for (int j = 0; j < 10; j++) {
            notifier.incrementMain();
          }
        }

        // Then - 모든 컨테이너 정리
        for (final container in containers) {
          final notifier = container.read(performanceCounterProvider.notifier);

          // 강제 저장으로 타이머 정리
          await notifier.forceSave();

          container.dispose();
        }

        // 메모리 누수가 없어야 함 (가비지 컬렉션 후에도 정상 동작)
        final finalContainer = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );

        final finalNotifier = finalContainer.read(
          performanceCounterProvider.notifier,
        );
        await finalNotifier.initializeForProject(projectId);

        // 정상 동작 확인
        finalNotifier.incrementMain();
        final finalState = finalContainer.read(performanceCounterProvider);
        expect(finalState.mainCounter, greaterThan(0));

        finalContainer.dispose();
      });
    });

    group('실제 사용 시나리오 성능 테스트', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('뜨개질 패턴 카운팅 시나리오', () async {
        // Given - 실제 뜨개질 패턴 시뮬레이션
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(performanceCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // 패턴 설정: 메인 카운터는 4씩, 서브 카운터는 2씩
        notifier.setMainCountBy(4);
        notifier.addSubCounter();
        notifier.setSubCountBy(2);

        final startTime = DateTime.now();

        // When - 실제 뜨개질 패턴 (10분간 작업 시뮬레이션)
        // 메인 패턴: 4바늘씩 20회 (총 80바늘)
        for (int i = 0; i < 20; i++) {
          notifier.incrementMain();

          // 서브 패턴: 2바늘씩 (색상 변경 등)
          if (i % 3 == 0) {
            notifier.incrementSub();
          }

          // 실제 뜨개질 속도 시뮬레이션 (30초마다 패턴 완성)
          await Future.delayed(const Duration(milliseconds: 50));
        }

        final endTime = DateTime.now();
        final totalTime = endTime.difference(startTime);

        // Then - 성능 검증
        final state = container.read(performanceCounterProvider);

        // 정확한 카운팅 결과
        expect(state.mainCounter, 80); // 4 * 20
        expect(state.subCounter, 14); // 2 * 7 (20/3 = 6.67, 반올림하면 7)

        // 처리 시간이 합리적이어야 함
        expect(totalTime.inSeconds, lessThan(5));

        // 강제 저장 후 DB 확인
        await notifier.forceSave();

        final savedData = await db.getProjectCounter(projectId);
        expect(savedData!.mainCounter, 80);
        expect(savedData.subCounter, 14);
        expect(savedData.mainCountBy, 4);
        expect(savedData.subCountBy, 2);

        container.dispose();
      });

      test('실수 수정 시나리오 (빠른 증감 반복)', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(performanceCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 실수로 잘못 카운팅 후 빠른 수정
        // 10번 증가
        for (int i = 0; i < 10; i++) {
          notifier.incrementMain();
        }

        // 실수 발견 후 빠른 감소 (5번)
        for (int i = 0; i < 5; i++) {
          notifier.decrementMain();
          await Future.delayed(const Duration(milliseconds: 20));
        }

        // 다시 정확한 값으로 증가 (3번)
        for (int i = 0; i < 3; i++) {
          notifier.incrementMain();
          await Future.delayed(const Duration(milliseconds: 20));
        }

        // Then - 최종 상태 확인
        final state = container.read(performanceCounterProvider);
        expect(state.mainCounter, 8); // 10 - 5 + 3

        // DB 저장 최적화 확인
        expect(notifier.saveCallCount, 0); // 아직 저장되지 않음

        await Future.delayed(const Duration(milliseconds: 250));
        expect(notifier.saveCallCount, 1); // 1번만 저장됨

        container.dispose();
      });

      test('장시간 사용 시나리오 (메모리 안정성)', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(performanceCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 장시간 사용 시뮬레이션 (1000번 조작)
        for (int i = 0; i < 1000; i++) {
          if (i % 10 == 0) {
            // 가끔 서브 카운터 토글
            if (notifier.state.hasSubCounter) {
              notifier.removeSubCounter();
            } else {
              notifier.addSubCounter();
            }
          } else if (i % 7 == 0) {
            // 가끔 count by 변경
            notifier.setMainCountBy((i % 5) + 1);
          } else {
            // 대부분은 일반 카운팅
            notifier.incrementMain();
          }

          // 매 100번마다 강제 저장하여 메모리 정리
          if (i % 100 == 99) {
            await notifier.forceSave();
          }
        }

        // Then - 메모리 안정성 확인
        final state = container.read(performanceCounterProvider);

        // 상태가 정상적으로 유지되어야 함
        expect(state.projectId, projectId);
        expect(state.mainCounter, greaterThan(0));

        // 저장 횟수가 합리적이어야 함 (10번 강제 저장 + 디바운싱)
        expect(notifier.saveCallCount, lessThanOrEqualTo(15));

        container.dispose();
      });
    });

    group('성능 벤치마크', () {
      late AppDb db;
      late int projectId;

      setUp(() async {
        db = createTestDb();
        projectId = await createTestProject(db);
      });

      tearDown(() async {
        await db.close();
      });

      test('대량 카운터 조작 성능 측정', () async {
        // Given
        final container = ProviderContainer(
          overrides: [appDbProvider.overrideWithValue(db)],
        );
        final notifier = container.read(performanceCounterProvider.notifier);

        await notifier.initializeForProject(projectId);

        // When - 대량 조작 (10,000번)
        final startTime = DateTime.now();

        for (int i = 0; i < 10000; i++) {
          notifier.incrementMain();
        }

        final endTime = DateTime.now();
        final operationTime = endTime.difference(startTime);

        // Then - 성능 기준 확인
        final state = container.read(performanceCounterProvider);
        expect(state.mainCounter, 10000);

        // 10,000번 조작이 1초 이내에 완료되어야 함
        expect(operationTime.inMilliseconds, lessThan(1000));

        // 평균 조작 시간 계산 (마이크로초 단위)
        final avgOperationTime = operationTime.inMicroseconds / 10000;
        expect(avgOperationTime, lessThan(100)); // 100마이크로초 이내

        print('10,000번 카운터 조작 완료: ${operationTime.inMilliseconds}ms');
        print('평균 조작 시간: ${avgOperationTime.toStringAsFixed(2)}μs');

        container.dispose();
      });
    });
  });
}
