import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/counter_data.dart';

/// 카운터 상태 클래스
/// CounterData 모델을 기반으로 한 상태 관리
class CounterState {
  /// 메인 카운터 값
  final int mainCounter;

  /// 메인 카운터의 증감 단위
  final int mainCountBy;

  /// 서브 카운터 값 (null이면 서브 카운터가 없음)
  final int? subCounter;

  /// 서브 카운터의 증감 단위
  final int subCountBy;

  /// 서브 카운터 존재 여부
  final bool hasSubCounter;

  const CounterState({
    required this.mainCounter,
    required this.mainCountBy,
    this.subCounter,
    required this.subCountBy,
    required this.hasSubCounter,
  });

  /// 기본값으로 초기화된 CounterState 생성
  factory CounterState.initial() {
    return const CounterState(
      mainCounter: 0,
      mainCountBy: 1,
      subCounter: null,
      subCountBy: 1,
      hasSubCounter: false,
    );
  }

  /// CounterData에서 CounterState 생성
  factory CounterState.fromCounterData(CounterData data) {
    return CounterState(
      mainCounter: data.mainCounter,
      mainCountBy: data.mainCountBy,
      subCounter: data.subCounter,
      subCountBy: data.subCountBy,
      hasSubCounter: data.hasSubCounter,
    );
  }

  /// CounterState를 CounterData로 변환
  CounterData toCounterData() {
    return CounterData(
      mainCounter: mainCounter,
      mainCountBy: mainCountBy,
      subCounter: subCounter,
      subCountBy: subCountBy,
      hasSubCounter: hasSubCounter,
    );
  }

  /// 새로운 값으로 복사본 생성
  CounterState copyWith({
    int? mainCounter,
    int? mainCountBy,
    int? subCounter,
    int? subCountBy,
    bool? hasSubCounter,
  }) {
    return CounterState(
      mainCounter: mainCounter ?? this.mainCounter,
      mainCountBy: mainCountBy ?? this.mainCountBy,
      subCounter: subCounter ?? this.subCounter,
      subCountBy: subCountBy ?? this.subCountBy,
      hasSubCounter: hasSubCounter ?? this.hasSubCounter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CounterState &&
        other.mainCounter == mainCounter &&
        other.mainCountBy == mainCountBy &&
        other.subCounter == subCounter &&
        other.subCountBy == subCountBy &&
        other.hasSubCounter == hasSubCounter;
  }

  @override
  int get hashCode {
    return mainCounter.hashCode ^
        mainCountBy.hashCode ^
        subCounter.hashCode ^
        subCountBy.hashCode ^
        hasSubCounter.hashCode;
  }

  @override
  String toString() {
    return 'CounterState('
        'mainCounter: $mainCounter, '
        'mainCountBy: $mainCountBy, '
        'subCounter: $subCounter, '
        'subCountBy: $subCountBy, '
        'hasSubCounter: $hasSubCounter'
        ')';
  }
}

/// 카운터 상태 관리를 위한 Notifier 클래스
class CounterNotifier extends Notifier<CounterState> {
  /// SharedPreferences 키 상수들
  static const String _keyMainValue = 'counter_main_value';
  static const String _keyMainCountBy = 'counter_main_count_by';
  static const String _keyHasSub = 'counter_has_sub';
  static const String _keySubValue = 'counter_sub_value';
  static const String _keySubCountBy = 'counter_sub_count_by';

  @override
  CounterState build() {
    // Provider가 dispose될 때 타이머 정리
    ref.onDispose(() {
      _saveTimer?.cancel();
    });

    // 초기 상태를 기본값으로 설정
    final initialState = CounterState.initial();

    // 비동기적으로 저장된 데이터 로드
    _loadFromPrefs();

    return initialState;
  }

  /// 테스트용 동기 로딩 메서드
  Future<void> loadFromPrefsForTest() async {
    await _loadFromPrefs();
  }

  /// SharedPreferences에서 저장된 데이터를 로드하여 상태 복원
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 저장된 값들을 로드 (기본값 사용)
      final mainCounter = prefs.getInt(_keyMainValue) ?? 0;
      final mainCountBy = prefs.getInt(_keyMainCountBy) ?? 1;
      final hasSubCounter = prefs.getBool(_keyHasSub) ?? false;
      final subValue = prefs.getInt(_keySubValue);
      final subCountBy = prefs.getInt(_keySubCountBy) ?? 1;

      // 데이터 유효성 검증
      final validMainCounter = mainCounter < 0 ? 0 : mainCounter;
      final validMainCountBy = mainCountBy < 1 ? 1 : mainCountBy;
      final validSubCountBy = subCountBy < 1 ? 1 : subCountBy;

      // 서브 카운터 값 처리 및 유효성 검증
      int? subCounter;
      if (hasSubCounter) {
        final rawSubValue = subValue ?? 0;
        subCounter = rawSubValue < 0 ? 0 : rawSubValue;
      }

      // 상태 업데이트
      state = CounterState(
        mainCounter: validMainCounter,
        mainCountBy: validMainCountBy,
        subCounter: subCounter,
        subCountBy: validSubCountBy,
        hasSubCounter: hasSubCounter,
      );
    } catch (e) {
      // 로드 실패 시 기본값 유지 (이미 build()에서 설정됨)
      // 에러를 사용자에게 노출하지 않고 조용히 처리
      // 개발 환경에서만 로그 출력
      assert(() {
        print('카운터 데이터 로드 실패: $e');
        return true;
      }());

      // 손상된 데이터가 있을 수 있으므로 기본값으로 재설정
      state = CounterState.initial();

      // 기본값을 저장하여 다음 실행 시 정상 동작 보장
      _saveToPrefs();
    }
  }

  /// 저장 디바운싱을 위한 타이머
  Timer? _saveTimer;

  /// 현재 상태를 SharedPreferences에 저장 (디바운싱 적용)
  Future<void> _saveToPrefs() async {
    // 기존 타이머가 있으면 취소
    _saveTimer?.cancel();

    // 100ms 후에 실제 저장 실행 (빠른 연속 변경 시 마지막 것만 저장)
    _saveTimer = Timer(const Duration(milliseconds: 100), () async {
      await _performSave();
    });
  }

  /// 실제 저장 로직
  Future<void> _performSave() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 데이터 유효성 검증 후 저장
      final validMainCounter = state.mainCounter < 0 ? 0 : state.mainCounter;
      final validMainCountBy = state.mainCountBy < 1 ? 1 : state.mainCountBy;
      final validSubCountBy = state.subCountBy < 1 ? 1 : state.subCountBy;

      // 모든 카운터 값들을 개별 키로 저장
      await Future.wait([
        prefs.setInt(_keyMainValue, validMainCounter),
        prefs.setInt(_keyMainCountBy, validMainCountBy),
        prefs.setBool(_keyHasSub, state.hasSubCounter),
        prefs.setInt(_keySubCountBy, validSubCountBy),
      ]);

      // 서브 카운터 값은 존재할 때만 저장
      if (state.hasSubCounter && state.subCounter != null) {
        final validSubCounter = state.subCounter! < 0 ? 0 : state.subCounter!;
        await prefs.setInt(_keySubValue, validSubCounter);
      } else {
        // 서브 카운터가 없으면 저장된 값 제거
        await prefs.remove(_keySubValue);
      }
    } catch (e) {
      // 저장 실패 시 조용히 처리 (사용자에게 알림 없음)
      // 개발 환경에서만 로그 출력
      assert(() {
        print('카운터 데이터 저장 실패: $e');
        return true;
      }());

      // 저장 실패가 반복될 수 있으므로 재시도 로직은 추가하지 않음
      // 다음 상태 변경 시 다시 저장 시도됨
    }
  }

  // === 메인 카운터 조작 메서드들 ===

  /// 메인 카운터를 countBy 단위로 증가
  void incrementMain() {
    state = state.copyWith(mainCounter: state.mainCounter + state.mainCountBy);
    _saveToPrefs();
  }

  /// 메인 카운터를 countBy 단위로 감소
  void decrementMain() {
    // 음수가 되지 않도록 제한
    final newValue = state.mainCounter - state.mainCountBy;
    state = state.copyWith(mainCounter: newValue < 0 ? 0 : newValue);
    _saveToPrefs();
  }

  /// 메인 카운터를 0으로 초기화
  void resetMain() {
    state = state.copyWith(mainCounter: 0);
    _saveToPrefs();
  }

  /// 메인 카운터의 countBy 값 설정
  void setMainCountBy(int value) {
    // 1 이상의 값만 허용하고, 현재 값과 다를 때만 업데이트
    if (value >= 1 && value != state.mainCountBy) {
      state = state.copyWith(mainCountBy: value);
      _saveToPrefs();
    }
  }

  // === 서브 카운터 관리 메서드들 ===

  /// 서브 카운터 추가 (1개만 허용)
  void addSubCounter() {
    if (!state.hasSubCounter) {
      state = state.copyWith(
        hasSubCounter: true,
        subCounter: 0, // 새 서브 카운터는 0으로 시작
        subCountBy: 1, // 기본 증감 단위
      );
      _saveToPrefs();
    }
  }

  /// 서브 카운터 제거
  void removeSubCounter() {
    if (state.hasSubCounter) {
      state = state.copyWith(
        hasSubCounter: false,
        subCounter: null,
        subCountBy: 1, // 기본값으로 리셋
      );
      _saveToPrefs();
    }
  }

  /// 서브 카운터를 countBy 단위로 증가
  void incrementSub() {
    if (state.hasSubCounter && state.subCounter != null) {
      state = state.copyWith(subCounter: state.subCounter! + state.subCountBy);
      _saveToPrefs();
    }
  }

  /// 서브 카운터를 countBy 단위로 감소
  void decrementSub() {
    if (state.hasSubCounter && state.subCounter != null) {
      // 음수가 되지 않도록 제한
      final newValue = state.subCounter! - state.subCountBy;
      state = state.copyWith(subCounter: newValue < 0 ? 0 : newValue);
      _saveToPrefs();
    }
  }

  /// 서브 카운터를 0으로 초기화
  void resetSub() {
    if (state.hasSubCounter) {
      state = state.copyWith(subCounter: 0);
      _saveToPrefs();
    }
  }

  /// 서브 카운터의 countBy 값 설정
  void setSubCountBy(int value) {
    // 1 이상의 값만 허용하고, 현재 값과 다를 때만 업데이트
    if (value >= 1 && value != state.subCountBy) {
      state = state.copyWith(subCountBy: value);
      _saveToPrefs();
    }
  }
}

/// 카운터 프로바이더
final counterProvider = NotifierProvider<CounterNotifier, CounterState>(() {
  return CounterNotifier();
});
