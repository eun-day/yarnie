import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../lib/providers/counter_provider.dart';

void main() {
  group('카운터 데이터 지속성 간단 테스트', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('기본값 테스트', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(counterProvider);

      expect(state.mainCounter, 0);
      expect(state.mainCountBy, 1);
      expect(state.hasSubCounter, false);
      expect(state.subCounter, null);
      expect(state.subCountBy, 1);
    });

    test('메인 카운터 증감 테스트', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(counterProvider.notifier);

      // 증가 테스트
      notifier.incrementMain();
      final state1 = container.read(counterProvider);
      expect(state1.mainCounter, 1);

      // 감소 테스트
      notifier.decrementMain();
      final state2 = container.read(counterProvider);
      expect(state2.mainCounter, 0);
    });

    test('서브 카운터 추가/삭제 테스트', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(counterProvider.notifier);

      // 서브 카운터 추가
      notifier.addSubCounter();
      final state1 = container.read(counterProvider);
      expect(state1.hasSubCounter, true);
      expect(state1.subCounter, 0);

      // 서브 카운터 삭제
      notifier.removeSubCounter();
      final state2 = container.read(counterProvider);
      expect(state2.hasSubCounter, false);
      expect(state2.subCounter, null);
    });

    test('count by 설정 테스트', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(counterProvider.notifier);

      // 메인 카운터 count by 설정
      notifier.setMainCountBy(3);
      final state1 = container.read(counterProvider);
      expect(state1.mainCountBy, 3);

      // 서브 카운터 count by 설정
      notifier.addSubCounter();
      notifier.setSubCountBy(2);
      final state2 = container.read(counterProvider);
      expect(state2.subCountBy, 2);
    });

    test('SharedPreferences 저장 테스트', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(counterProvider.notifier);

      // 값 설정
      notifier.setMainCountBy(5);
      notifier.incrementMain(); // 5
      notifier.addSubCounter();
      notifier.setSubCountBy(2);
      notifier.incrementSub(); // 2

      // 저장 대기
      await Future.delayed(const Duration(milliseconds: 100));

      // SharedPreferences에서 직접 확인
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('counter_main_value'), 5);
      expect(prefs.getInt('counter_main_count_by'), 5);
      expect(prefs.getBool('counter_has_sub'), true);
      expect(prefs.getInt('counter_sub_value'), 2);
      expect(prefs.getInt('counter_sub_count_by'), 2);
    });
  });
}
