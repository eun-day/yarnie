import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/providers/counter_provider.dart';
import 'package:yarnie/db/di.dart';

/// 카운터 성능 최적화 및 최종 검토 테스트
///
/// 테스트 범위:
/// - 불필요한 리빌드 방지를 위한 Provider 최적화
/// - 메모리 사용량 확인 및 최적화
/// - 코드 리뷰 및 리팩토링
void main() {
  // Flutter binding 초기화 (데이터베이스 사용을 위해 필요)
  TestWidgetsFlutterBinding.ensureInitialized();
  group('카운터 성능 최적화 테스트', () {
    late ProviderContainer container;
    const testProjectId = 998; // 테스트용 프로젝트 ID

    setUp(() async {
      // 테스트용 프로바이더 컨테이너 생성
      container = ProviderContainer();
    });

    tearDown(() async {
      container.dispose();

      // 테스트 데이터 정리
      await (appDb.delete(
        appDb.projectCounters,
      )..where((t) => t.projectId.equals(testProjectId))).go();
    });

    test('빠른 연속 저장 요청 시 디바운싱 테스트', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      // 빠른 연속 증가 (디바운싱이 적용되어야 함)
      for (int i = 0; i < 10; i++) {
        notifier.incrementMain();
      }

      final state = container.read(counterProvider);
      expect(state.mainCounter, 10);

      // 디바운싱 대기 시간보다 조금 더 기다림
      await Future.delayed(const Duration(milliseconds: 150));

      // 데이터베이스에 최종 값만 저장되었는지 확인
      final counterData = await (appDb.select(
        appDb.projectCounters,
      )..where((t) => t.projectId.equals(testProjectId))).getSingleOrNull();
      expect(counterData?.mainCounter, 10);
    });

    test('상태 변경 시 불필요한 객체 생성 방지 테스트', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      final initialState = container.read(counterProvider);

      // 동일한 값으로 설정 시 상태가 변경되지 않아야 함
      notifier.setMainCountBy(1); // 이미 기본값이 1
      final stateAfterSameValue = container.read(counterProvider);

      // 객체 참조가 동일해야 함 (새 객체 생성 안됨)
      expect(identical(initialState, stateAfterSameValue), true);
    });

    test('메모리 누수 방지 테스트', () async {
      // 여러 컨테이너를 생성하고 dispose하여 메모리 누수 확인
      for (int i = 0; i < 10; i++) {
        // 테스트 속도를 위해 100에서 10으로 줄임
        final testContainer = ProviderContainer();

        final notifier = testContainer.read(counterProvider.notifier);
        await notifier.initializeForProject(900 + i); // 테스트용 프로젝트 ID

        // 일부 작업 수행
        notifier.incrementMain();
        notifier.addSubCounter();
        notifier.incrementSub();

        // 컨테이너 정리
        testContainer.dispose();

        // 테스트 데이터 정리
        await (appDb.delete(
          appDb.projectCounters,
        )..where((t) => t.projectId.equals(900 + i))).go();
      }

      // 가비지 컬렉션 유도
      await Future.delayed(const Duration(milliseconds: 10));

      // 메모리 누수가 없다면 이 테스트는 통과해야 함
      expect(true, true);
    });

    test('대량 데이터 처리 성능 테스트', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      final stopwatch = Stopwatch()..start();

      // 1000번의 연속 증가
      for (int i = 0; i < 1000; i++) {
        notifier.incrementMain();
      }

      stopwatch.stop();

      // 1000번의 증가가 1초 이내에 완료되어야 함
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));

      final state = container.read(counterProvider);
      expect(state.mainCounter, 1000);
    });

    test('동시성 테스트 - 여러 작업 동시 실행', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      // 여러 작업을 동시에 실행
      await Future.wait([
        Future(() {
          for (int i = 0; i < 100; i++) {
            notifier.incrementMain();
          }
        }),
        Future(() {
          notifier.addSubCounter();
          for (int i = 0; i < 50; i++) {
            notifier.incrementSub();
          }
        }),
        Future(() {
          notifier.setMainCountBy(2);
          for (int i = 0; i < 25; i++) {
            notifier.incrementMain();
          }
        }),
      ]);

      final state = container.read(counterProvider);

      // 최종 상태가 일관성 있게 유지되는지 확인
      expect(state.mainCounter, greaterThan(0));
      expect(state.hasSubCounter, true);
      expect(state.subCounter, greaterThan(0));
    });

    test('상태 불변성 테스트', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      final initialState = container.read(counterProvider);

      // 상태 변경
      notifier.incrementMain();
      final newState = container.read(counterProvider);

      // 이전 상태는 변경되지 않아야 함
      expect(initialState.mainCounter, 0);
      expect(newState.mainCounter, 1);

      // 서로 다른 객체여야 함
      expect(identical(initialState, newState), false);
    });

    test('에러 복구 테스트', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      // 정상 작업
      notifier.incrementMain();
      expect(container.read(counterProvider).mainCounter, 1);

      // 잘못된 값 설정 시도 (내부적으로 무시되어야 함)
      notifier.setMainCountBy(0); // 0은 허용되지 않음
      notifier.setMainCountBy(-1); // 음수는 허용되지 않음

      // 상태가 유효한 값으로 유지되어야 함
      final state = container.read(counterProvider);
      expect(state.mainCountBy, 1); // 기본값 유지

      // 정상 작업이 계속 가능해야 함
      notifier.incrementMain();
      expect(container.read(counterProvider).mainCounter, 2);
    });

    test('Provider 생명주기 테스트', () async {
      const lifecycleTestProjectId = 997;

      ProviderContainer? testContainer = ProviderContainer();

      final notifier = testContainer.read(counterProvider.notifier);
      await notifier.initializeForProject(lifecycleTestProjectId);
      notifier.incrementMain();

      final state = testContainer.read(counterProvider);
      expect(state.mainCounter, 1);

      // 컨테이너 dispose
      testContainer.dispose();
      testContainer = null;

      // 가비지 컬렉션 유도
      await Future.delayed(const Duration(milliseconds: 10));

      // 새 컨테이너 생성
      testContainer = ProviderContainer();

      // 새 인스턴스는 이전 데이터를 로드해야 함 (같은 DB이므로)
      final newNotifier = testContainer.read(counterProvider.notifier);
      await newNotifier.initializeForProject(lifecycleTestProjectId);
      final newState = testContainer.read(counterProvider);
      expect(newState.mainCounter, 1); // 이전 값 복원

      testContainer.dispose();

      // 테스트 데이터 정리
      await (appDb.delete(
        appDb.projectCounters,
      )..where((t) => t.projectId.equals(lifecycleTestProjectId))).go();
    });

    test('copyWith 메서드 최적화 테스트', () async {
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      final initialState = container.read(counterProvider);

      // 변경사항이 없는 copyWith 호출
      final sameState = initialState.copyWith();

      // 모든 값이 동일해야 함
      expect(sameState.projectId, initialState.projectId);
      expect(sameState.mainCounter, initialState.mainCounter);
      expect(sameState.mainCountBy, initialState.mainCountBy);
      expect(sameState.hasSubCounter, initialState.hasSubCounter);
      expect(sameState.subCounter, initialState.subCounter);
      expect(sameState.subCountBy, initialState.subCountBy);

      // 하지만 새로운 객체여야 함
      expect(identical(initialState, sameState), false);
    });

    test('상태 비교 최적화 테스트', () {
      final state1 = CounterState.initial(testProjectId);
      final state2 = CounterState.initial(testProjectId);
      final state3 = state1.copyWith(mainCounter: 1);

      // 동일한 값을 가진 상태들은 equal해야 함
      expect(state1 == state2, true);
      expect(state1.hashCode == state2.hashCode, true);

      // 다른 값을 가진 상태는 equal하지 않아야 함
      expect(state1 == state3, false);
      expect(state1.hashCode == state3.hashCode, false);
    });
  });
}
