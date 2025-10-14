import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/counter_data.dart';
import '../db/app_db.dart';
import '../db/di.dart';

/// 카운터 상태 클래스
/// CounterData 모델을 기반으로 한 상태 관리
class CounterState {
  /// 현재 프로젝트 ID
  final int projectId;

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
    required this.projectId,
    required this.mainCounter,
    required this.mainCountBy,
    this.subCounter,
    required this.subCountBy,
    required this.hasSubCounter,
  });

  /// 기본값으로 초기화된 CounterState 생성
  factory CounterState.initial(int projectId) {
    return CounterState(
      projectId: projectId,
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
      projectId: data.projectId,
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
      projectId: projectId,
      mainCounter: mainCounter,
      mainCountBy: mainCountBy,
      subCounter: subCounter,
      subCountBy: subCountBy,
      hasSubCounter: hasSubCounter,
    );
  }

  /// 새로운 값으로 복사본 생성
  CounterState copyWith({
    int? projectId,
    int? mainCounter,
    int? mainCountBy,
    int? subCounter,
    int? subCountBy,
    bool? hasSubCounter,
  }) {
    return CounterState(
      projectId: projectId ?? this.projectId,
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
        other.projectId == projectId &&
        other.mainCounter == mainCounter &&
        other.mainCountBy == mainCountBy &&
        other.subCounter == subCounter &&
        other.subCountBy == subCountBy &&
        other.hasSubCounter == hasSubCounter;
  }

  @override
  int get hashCode {
    return projectId.hashCode ^
        mainCounter.hashCode ^
        mainCountBy.hashCode ^
        subCounter.hashCode ^
        subCountBy.hashCode ^
        hasSubCounter.hashCode;
  }

  @override
  String toString() {
    return 'CounterState('
        'projectId: $projectId, '
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
  late final AppDb _db;
  Timer? _saveTimer; // 디바운싱을 위한 타이머

  @override
  CounterState build() {
    // DB 인스턴스 가져오기 (테스트에서 오버라이드 가능)
    _db = ref.watch(appDbProvider);

    // 초기 상태를 기본값으로 설정 (projectId는 나중에 initializeForProject에서 설정)
    return CounterState.initial(0);
  }

  /// 프로젝트별 초기화
  Future<void> initializeForProject(int projectId) async {
    // 해당 프로젝트의 카운터 데이터 로드
    await _loadFromDatabase(projectId);
  }

  /// 디바운싱된 DB 저장 예약
  /// 200ms 지연 후 DB에 현재 상태를 저장
  void _scheduleDbSave() {
    // 기존 타이머가 있으면 취소
    _saveTimer?.cancel();

    // 새로운 타이머 설정 (200ms 후 저장)
    _saveTimer = Timer(const Duration(milliseconds: 200), () {
      saveToDatabase();
    });
  }

  /// 현재 상태를 즉시 데이터베이스에 저장
  @protected
  Future<void> saveToDatabase() async {
    try {
      final counterData = state.toCounterData();
      await _db.saveProjectCounter(counterData);
    } catch (e) {
      // 저장 실패 시 로그만 출력하고 계속 진행
      print('카운터 데이터 저장 실패: $e');
    }
  }

  /// 데이터베이스에서 프로젝트별 카운터 데이터를 로드하여 상태 복원
  Future<void> _loadFromDatabase(int projectId) async {
    try {
      // 데이터베이스에서 해당 프로젝트의 카운터 데이터 조회
      final counterData = await _db.getProjectCounter(projectId);

      if (counterData != null) {
        // 데이터가 있으면 로드
        state = CounterState(
          projectId: projectId,
          mainCounter: counterData.mainCounter,
          mainCountBy: counterData.mainCountBy,
          subCounter: counterData.subCounter,
          subCountBy: counterData.subCountBy,
          hasSubCounter: counterData.hasSubCounter,
        );
      } else {
        // 데이터가 없으면 기본값으로 설정
        state = CounterState.initial(projectId);
      }
    } catch (e) {
      // 로드 실패 시 기본값으로 설정
      print('카운터 데이터 로드 실패: $e');
      state = CounterState.initial(projectId);
    }
  }

  // === 메인 카운터 조작 메서드들 ===

  /// 메인 카운터를 countBy 단위로 증가
  void incrementMain() {
    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(mainCounter: state.mainCounter + state.mainCountBy);

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  /// 메인 카운터를 countBy 단위로 감소 (0 이하로는 내려가지 않음)
  void decrementMain() {
    // 0 이하로 내려가지 않도록 제한
    final newValue = state.mainCounter - state.mainCountBy;
    final clampedValue = newValue < 0 ? 0 : newValue;

    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(mainCounter: clampedValue);

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  /// 메인 카운터를 0으로 초기화
  void resetMain() {
    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(mainCounter: 0);

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  /// 메인 카운터의 countBy 값 설정
  void setMainCountBy(int value) {
    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(mainCountBy: value);

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  // === 서브 카운터 관리 메서드들 ===

  /// 서브 카운터 추가 (1개만 허용)
  void addSubCounter() {
    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(
      hasSubCounter: true,
      subCounter: 0, // 새로 생성된 서브 카운터는 0으로 시작
    );

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  /// 서브 카운터 제거
  void removeSubCounter() {
    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(
      hasSubCounter: false,
      subCounter: null, // 서브 카운터 값을 null로 설정
    );

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  /// 서브 카운터를 countBy 단위로 증가
  void incrementSub() {
    if (state.hasSubCounter && state.subCounter != null) {
      // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
      state = state.copyWith(subCounter: state.subCounter! + state.subCountBy);

      // 디바운싱된 DB 저장 예약
      _scheduleDbSave();
    }
  }

  /// 서브 카운터를 countBy 단위로 감소 (0 이하로는 내려가지 않음)
  void decrementSub() {
    if (state.hasSubCounter && state.subCounter != null) {
      // 0 이하로 내려가지 않도록 제한
      final newValue = state.subCounter! - state.subCountBy;
      final clampedValue = newValue < 0 ? 0 : newValue;

      // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
      state = state.copyWith(subCounter: clampedValue);

      // 디바운싱된 DB 저장 예약
      _scheduleDbSave();
    }
  }

  /// 서브 카운터를 0으로 초기화
  void resetSub() {
    if (state.hasSubCounter) {
      // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
      state = state.copyWith(subCounter: 0);

      // 디바운싱된 DB 저장 예약
      _scheduleDbSave();
    }
  }

  /// 서브 카운터의 countBy 값 설정
  void setSubCountBy(int value) {
    // 즉시 메모리 상태 업데이트 (UI 반응성 보장)
    state = state.copyWith(subCountBy: value);

    // 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }

  /// 강제로 현재 상태를 즉시 저장
  /// Provider dispose, 화면 전환, 앱 백그라운드 진입 시 호출
  Future<void> forceSave() async {
    // 대기 중인 타이머 취소
    _saveTimer?.cancel();
    _saveTimer = null;

    // 즉시 DB에 저장
    await saveToDatabase();
  }

  // Notifier는 dispose 메서드가 없으므로 제거
  // 대신 forceSave를 통해 수동으로 저장 관리
}

/// 카운터 프로바이더
final counterProvider = NotifierProvider<CounterNotifier, CounterState>(() {
  return CounterNotifier();
});
