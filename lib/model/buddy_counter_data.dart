import '../db/app_db.dart';

/// BuddyCounter를 통합하여 UI에서 사용하기 쉽게 래핑한 sealed class
sealed class BuddyCounterData {
  int get id;
  int get partId;
  String get name;
}

/// StitchCounter 데이터 모델
/// 독립적으로 조작 가능한 BuddyCounter
class StitchCounterData extends BuddyCounterData {
  @override
  final int id;
  @override
  final int partId;
  @override
  final String name;
  final int currentValue;
  final int countBy;

  StitchCounterData({
    required this.id,
    required this.partId,
    required this.name,
    required this.currentValue,
    required this.countBy,
  });

  /// Drift StitchCounter에서 StitchCounterData 객체 생성
  factory StitchCounterData.fromStitchCounter(StitchCounter counter) {
    return StitchCounterData(
      id: counter.id,
      partId: counter.partId,
      name: counter.name,
      currentValue: counter.currentValue,
      countBy: counter.countBy,
    );
  }

  /// 새로운 값으로 복사본 생성
  StitchCounterData copyWith({
    int? id,
    int? partId,
    String? name,
    int? currentValue,
    int? countBy,
  }) {
    return StitchCounterData(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      name: name ?? this.name,
      currentValue: currentValue ?? this.currentValue,
      countBy: countBy ?? this.countBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StitchCounterData &&
        other.id == id &&
        other.partId == partId &&
        other.name == name &&
        other.currentValue == currentValue &&
        other.countBy == countBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        partId.hashCode ^
        name.hashCode ^
        currentValue.hashCode ^
        countBy.hashCode;
  }

  @override
  String toString() {
    return 'StitchCounterData('
        'id: $id, '
        'partId: $partId, '
        'name: $name, '
        'currentValue: $currentValue, '
        'countBy: $countBy'
        ')';
  }
}

/// SectionCounter 데이터 모델
/// MainCounter와 연동되는 BuddyCounter
class SectionCounterData extends BuddyCounterData {
  @override
  final int id;
  @override
  final int partId;
  @override
  final String name;
  final Map<String, dynamic> spec;
  final LinkState linkState;
  final int? frozenMainAt;

  SectionCounterData({
    required this.id,
    required this.partId,
    required this.name,
    required this.spec,
    required this.linkState,
    this.frozenMainAt,
  });

  /// Drift SectionCounter에서 SectionCounterData 객체 생성
  factory SectionCounterData.fromSectionCounter(
    SectionCounter counter,
    Map<String, dynamic> spec,
  ) {
    return SectionCounterData(
      id: counter.id,
      partId: counter.partId,
      name: counter.name,
      spec: spec,
      linkState: counter.linkState,
      frozenMainAt: counter.frozenMainAt,
    );
  }

  /// UI 헬퍼: 링크 상태 확인
  bool get isLinked => linkState == LinkState.linked;

  /// MainCounter 값으로 진행도 계산
  ///
  /// [mainCounterValue]: 현재 MainCounter 값
  /// 반환값: 현재 진행된 행 수 (0 ~ rowsTotal)
  int calculateProgress(int mainCounterValue) {
    final baseValue = isLinked ? mainCounterValue : (frozenMainAt ?? 0);
    final startRow = spec['startRow'] as int? ?? 0;
    final rowsTotal = spec['rowsTotal'] as int? ?? 0;

    if (rowsTotal == 0) return 0;
    return (baseValue - startRow).clamp(0, rowsTotal);
  }

  /// MainCounter 값으로 진행률(%) 계산
  ///
  /// [mainCounterValue]: 현재 MainCounter 값
  /// 반환값: 진행률 (0.0 ~ 1.0), rowsTotal이 0이면 null
  double? calculateProgressPercent(int mainCounterValue) {
    final progress = calculateProgress(mainCounterValue);
    final rowsTotal = spec['rowsTotal'] as int? ?? 0;

    if (rowsTotal == 0) return null;
    return progress / rowsTotal;
  }

  /// 새로운 값으로 복사본 생성
  SectionCounterData copyWith({
    int? id,
    int? partId,
    String? name,
    Map<String, dynamic>? spec,
    LinkState? linkState,
    int? frozenMainAt,
  }) {
    return SectionCounterData(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      name: name ?? this.name,
      spec: spec ?? this.spec,
      linkState: linkState ?? this.linkState,
      frozenMainAt: frozenMainAt ?? this.frozenMainAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SectionCounterData &&
        other.id == id &&
        other.partId == partId &&
        other.name == name &&
        other.linkState == linkState &&
        other.frozenMainAt == frozenMainAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        partId.hashCode ^
        name.hashCode ^
        linkState.hashCode ^
        frozenMainAt.hashCode;
  }

  @override
  String toString() {
    return 'SectionCounterData('
        'id: $id, '
        'partId: $partId, '
        'name: $name, '
        'linkState: $linkState, '
        'frozenMainAt: $frozenMainAt, '
        'spec: $spec'
        ')';
  }
}
