import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/providers/counter_provider.dart';
import 'package:yarnie/db/di.dart';

/// 카운터 데이터 지속성 테스트
///
/// 테스트 범위:
/// - 앱 재시작 후 카운터 값 복원 테스트
/// - 데이터베이스 저장/로드 기능 테스트
/// - 에러 상황에서의 기본값 처리 테스트
void main() {
  // Flutter binding 초기화 (데이터베이스 사용을 위해 필요)
  TestWidgetsFlutterBinding.ensureInitialized();
  group('카운터 데이터 지속성 테스트', () {
    const testProjectId = 994; // 테스트용 프로젝트 ID

    tearDown(() async {
      // 테스트 데이터 정리
      await (appDb.delete(
        appDb.projectCounters,
      )..where((t) => t.projectId.equals(testProjectId))).go();
    });

    test('메인 카운터 값 저장 및 복원 테스트', () async {
      // 첫 번째 컨테이너에서 카운터 값 설정
      final container1 = ProviderContainer();
      addTearDown(container1.dispose);

      final notifier1 = container1.read(counterProvider.notifier);
      await notifier1.initializeForProject(testProjectId);

      // 메인 카운터 값 변경
      notifier1.incrementMain();
      notifier1.incrementMain();
      notifier1.incrementMain();

      final state1 = container1.read(counterProvider);
      expect(state1.mainCounter, 3);

      // 저장이 완료될 때까지 대기
      await Future.delayed(const Duration(milliseconds: 150));

      // 새로운 컨테이너 생성 (앱 재시작 시뮬레이션)
      final container2 = ProviderContainer();
      addTearDown(container2.dispose);

      // 명시적으로 데이터 로드
      final notifier2 = container2.read(counterProvider.notifier);
      await notifier2.initializeForProject(testProjectId);

      final state2 = container2.read(counterProvider);
      expect(state2.mainCounter, 3); // 값이 복원되어야 함
    });

    test('메인 카운터 count by 값 저장 및 복원 테스트', () async {
      final container1 = ProviderContainer();
      addTearDown(container1.dispose);

      final notifier1 = container1.read(counterProvider.notifier);
      await notifier1.initializeForProject(testProjectId);

      // count by 값 변경
      notifier1.setMainCountBy(5);

      final state1 = container1.read(counterProvider);
      expect(state1.mainCountBy, 5);

      // 저장 대기
      await Future.delayed(const Duration(milliseconds: 150));

      // 새로운 컨테이너 생성
      final container2 = ProviderContainer();
      addTearDown(container2.dispose);

      // 명시적으로 데이터 로드
      final notifier2 = container2.read(counterProvider.notifier);
      await notifier2.initializeForProject(testProjectId);

      final state2 = container2.read(counterProvider);
      expect(state2.mainCountBy, 5); // count by 값이 복원되어야 함
    });

    test('저장된 데이터가 없을 때 기본값 처리 테스트', () async {
      const newProjectId = 993; // 새로운 프로젝트 ID (데이터가 없음)

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 명시적으로 데이터 로드
      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(newProjectId);

      final state = container.read(counterProvider);

      // 기본값으로 초기화되어야 함
      expect(state.projectId, newProjectId);
      expect(state.mainCounter, 0);
      expect(state.mainCountBy, 1);
      expect(state.hasSubCounter, false);
      expect(state.subCounter, null);
      expect(state.subCountBy, 1);

      // 테스트 데이터 정리
      await (appDb.delete(
        appDb.projectCounters,
      )..where((t) => t.projectId.equals(newProjectId))).go();
    });

    test('데이터베이스 저장 정확성 테스트', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(counterProvider.notifier);
      await notifier.initializeForProject(testProjectId);

      // 다양한 값 설정
      notifier.setMainCountBy(3);
      notifier.incrementMain();
      notifier.addSubCounter();
      notifier.setSubCountBy(2);
      notifier.incrementSub();

      // 저장 대기
      await Future.delayed(const Duration(milliseconds: 150));

      // 데이터베이스에서 직접 값 확인
      final counterData = await (appDb.select(
        appDb.projectCounters,
      )..where((t) => t.projectId.equals(testProjectId))).getSingleOrNull();

      expect(counterData, isNotNull);
      expect(counterData!.mainCounter, 3);
      expect(counterData.mainCountBy, 3);
      expect(counterData.hasSubCounter, true);
      expect(counterData.subCounter, 2);
      expect(counterData.subCountBy, 2);
    });

    test('프로젝트별 데이터 격리 테스트', () async {
      const project1Id = 992;
      const project2Id = 991;

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(counterProvider.notifier);

      // 프로젝트 1 설정
      await notifier.initializeForProject(project1Id);
      notifier.setMainCountBy(3);
      notifier.incrementMain(); // 3

      // 저장 대기
      await Future.delayed(const Duration(milliseconds: 150));

      // 프로젝트 2로 전환
      await notifier.initializeForProject(project2Id);
      final state2 = container.read(counterProvider);
      expect(state2.projectId, project2Id);
      expect(state2.mainCounter, 0); // 새 프로젝트는 기본값

      // 프로젝트 1로 다시 전환
      await notifier.initializeForProject(project1Id);
      final state1Again = container.read(counterProvider);
      expect(state1Again.projectId, project1Id);
      expect(state1Again.mainCounter, 3); // 이전 값 복원

      // 테스트 데이터 정리
      await (appDb.delete(
        appDb.projectCounters,
      )..where((t) => t.projectId.isIn([project1Id, project2Id]))).go();
    });
  });
}
