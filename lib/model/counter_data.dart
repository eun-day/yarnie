/// 카운터 데이터 모델
/// 메인 카운터와 서브 카운터의 상태를 관리하는 데이터 클래스
class CounterData {
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

  const CounterData({
    required this.mainCounter,
    required this.mainCountBy,
    this.subCounter,
    required this.subCountBy,
    required this.hasSubCounter,
  });

  /// 기본값으로 초기화된 CounterData 생성
  factory CounterData.initial() {
    return const CounterData(
      mainCounter: 0,
      mainCountBy: 1,
      subCounter: null,
      subCountBy: 1,
      hasSubCounter: false,
    );
  }

  /// JSON에서 CounterData 객체 생성
  factory CounterData.fromJson(Map<String, dynamic> json) {
    return CounterData(
      mainCounter: json['mainCounter'] as int? ?? 0,
      mainCountBy: json['mainCountBy'] as int? ?? 1,
      subCounter: json['subCounter'] as int?,
      subCountBy: json['subCountBy'] as int? ?? 1,
      hasSubCounter: json['hasSubCounter'] as bool? ?? false,
    );
  }

  /// CounterData 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'mainCounter': mainCounter,
      'mainCountBy': mainCountBy,
      'subCounter': subCounter,
      'subCountBy': subCountBy,
      'hasSubCounter': hasSubCounter,
    };
  }

  /// 새로운 값으로 복사본 생성
  CounterData copyWith({
    int? mainCounter,
    int? mainCountBy,
    int? subCounter,
    int? subCountBy,
    bool? hasSubCounter,
  }) {
    return CounterData(
      mainCounter: mainCounter ?? this.mainCounter,
      mainCountBy: mainCountBy ?? this.mainCountBy,
      subCounter: subCounter ?? this.subCounter,
      subCountBy: subCountBy ?? this.subCountBy,
      hasSubCounter: hasSubCounter ?? this.hasSubCounter,
    );
  }

  /// 서브 카운터를 제거한 복사본 생성
  CounterData removeSubCounter() {
    return CounterData(
      mainCounter: mainCounter,
      mainCountBy: mainCountBy,
      subCounter: null,
      subCountBy: 1, // 기본값으로 리셋
      hasSubCounter: false,
    );
  }

  /// 서브 카운터를 추가한 복사본 생성
  CounterData addSubCounter() {
    return CounterData(
      mainCounter: mainCounter,
      mainCountBy: mainCountBy,
      subCounter: 0, // 새 서브 카운터는 0으로 시작
      subCountBy: 1, // 기본 증감 단위
      hasSubCounter: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CounterData &&
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
    return 'CounterData('
        'mainCounter: $mainCounter, '
        'mainCountBy: $mainCountBy, '
        'subCounter: $subCounter, '
        'subCountBy: $subCountBy, '
        'hasSubCounter: $hasSubCounter'
        ')';
  }
}
