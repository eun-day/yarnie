# 설계 문서

## 개요

Yarnie 앱의 카운터 기능을 확장하여 뜨개질 작업에 특화된 고급 카운팅 도구를 제공합니다. 현재 기본적인 카운터만 구현되어 있는 상태에서, 메인/서브 카운터, 카운트 단위 설정, 스톱워치 연동, 데이터 지속성 등의 기능을 추가합니다.

## 아키텍처

### 전체 구조

```
lib/
├── providers/
│   ├── stopwatch_provider.dart (기존)
│   └── counter_provider.dart (신규)
├── model/
│   └── counter_data.dart (신규)
├── widget/
│   ├── sub_counter_item.dart (신규)
│   └── count_by_selector.dart (신규)
└── project_detail_screen.dart (수정)
```

### 상태 관리 패턴

- **Riverpod Notifier 패턴**: 기존 `StopwatchProvider`와 동일한 패턴 사용
- **Drift Database**: 카운터 데이터 지속성을 위한 로컬 데이터베이스
- **플랫폼별 UI 분기**: `Platform.isIOS`를 활용한 조건부 렌더링

## 컴포넌트 및 인터페이스

### 1. CounterProvider (lib/providers/counter_provider.dart)

**역할**: 카운터 상태 관리 및 데이터 지속성 처리

```dart
class CounterState {
  final int projectId; // 현재 프로젝트 ID
  final int mainCounter;
  final int mainCountBy;
  final int? subCounter; // 서브 카운터 값 (null이면 없음)
  final int subCountBy; // 서브 카운터의 count by 값
  final bool hasSubCounter; // 서브 카운터 존재 여부
}

class CounterNotifier extends Notifier<CounterState> {
  // 초기화
  void initializeForProject(int projectId);
  
  // 메인 카운터 조작
  void incrementMain();
  void decrementMain();
  void resetMain();
  void setMainCountBy(int value);
  
  // 서브 카운터 관리 (1개만)
  void addSubCounter();
  void removeSubCounter();
  void incrementSub();
  void decrementSub();
  void resetSub();
  void setSubCountBy(int value);
  
  // 데이터 지속성
  Future<void> _saveToDatabase();
  Future<void> _loadFromDatabase(int projectId);
}
```

### 2. CounterData 모델 및 DB 테이블

**역할**: 카운터 데이터 구조 정의 및 데이터베이스 테이블

```dart
// Drift 테이블 정의 (lib/db/app_db.dart에 추가)
class ProjectCounters extends Table {
  IntColumn get projectId => integer()();
  IntColumn get mainCounter => integer().withDefault(const Constant(0))();
  IntColumn get mainCountBy => integer().withDefault(const Constant(1))();
  IntColumn get subCounter => integer().nullable()();
  IntColumn get subCountBy => integer().withDefault(const Constant(1))();
  BoolColumn get hasSubCounter => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {projectId};
}

// 데이터 모델 클래스 (lib/model/counter_data.dart)
class CounterData {
  final int projectId;
  final int mainCounter;
  final int mainCountBy;
  final int? subCounter; // 서브 카운터 값 (null이면 없음)
  final int subCountBy; // 서브 카운터의 count by 값
  final bool hasSubCounter; // 서브 카운터 존재 여부
}
```

### 3. UI 컴포넌트들

#### SubCounterItem (lib/widget/sub_counter_item.dart)
- 서브 카운터 UI (1개만)
- 간소화된 "- [ 숫자 ] +" 형태
- 서브 카운터 전용 count by 설정 버튼
- 삭제 기능

#### CountBySelector (lib/widget/count_by_selector.dart)
- "count by X" 버튼 (메인/서브 각각)
- 휠피커 팝업
- 플랫폼별 피커 스타일

### 4. _CounterView (project_detail_screen.dart)

**레이아웃 구조** (위에서 아래 순서):
1. 스톱워치 표시 (항상 표시)
2. 메인 카운터 영역 (스택 쌓기)
   - +/- 버튼 영역 (가로세로 비율 1:1.5, 화면 너비 반반)
   - Count by 버튼 (오른쪽 상단)
   - 메인 카운터 숫자 (크게, 중앙정렬)
3. "Add SubCounter" 버튼 (중앙정렬)
4. 서브 카운터 (1개만, 있을 때만 표시)
   - 서브 카운터 "- [ 숫자 ] +" 형태
   - 서브 카운터용 count by 설정 버튼

```dart
class _CounterView extends ConsumerStatefulWidget {
  // 레이아웃: Column
  //   - 스톱워치 표시 (항상 표시)
  //   - Stack (+/- 버튼들 + 메인 카운터 + count by 버튼)
  //   - "Add SubCounter" 버튼 (중앙정렬)
  //   - 서브 카운터 영역 (조건부)
}
```

## 데이터 모델

### 데이터베이스 테이블 구조

**ProjectCounters 테이블**:
- `projectId` (INT, PRIMARY KEY): 프로젝트 ID
- `mainCounter` (INT, DEFAULT 0): 메인 카운터 값
- `mainCountBy` (INT, DEFAULT 1): 메인 카운터 증감 단위
- `subCounter` (INT, NULLABLE): 서브 카운터 값 (null이면 서브 카운터 없음)
- `subCountBy` (INT, DEFAULT 1): 서브 카운터 증감 단위
- `hasSubCounter` (BOOLEAN, DEFAULT false): 서브 카운터 존재 여부

### 데이터 흐름

1. **초기화**: 프로젝트 진입 시 해당 프로젝트 ID로 DB에서 카운터 데이터 로드
2. **상태 변경**: 사용자 액션 → Provider 상태 업데이트 → DB에 저장
3. **UI 업데이트**: Provider 상태 변경 → Consumer 위젯 리빌드
4. **프로젝트별 격리**: 각 프로젝트마다 독립적인 카운터 데이터 유지

## 에러 처리

### 데이터베이스 에러
- **문제**: DB 저장/로드 실패
- **해결**: 기본값으로 폴백, 사용자에게 알림 없이 처리

### 프로젝트 데이터 없음
- **문제**: 새 프로젝트이거나 카운터 데이터가 없는 경우
- **해결**: 기본값으로 새 레코드 생성

### 플랫폼별 UI 에러
- **문제**: 특정 플랫폼에서 UI 컴포넌트 오류
- **해결**: Material Design으로 폴백

## 테스트 전략

### 단위 테스트
- **CounterProvider**: 상태 변경 로직 테스트
- **데이터 지속성**: 데이터베이스 저장/로드 테스트
- **프로젝트별 격리**: 서로 다른 프로젝트 ID로 데이터 격리 테스트

### 위젯 테스트
- **카운터 UI**: 터치 이벤트 및 표시 테스트
- **플랫폼별 UI**: iOS/Android 분기 테스트
- **스톱워치 표시**: 스톱워치 항상 표시 및 상태 변화 테스트

### 통합 테스트
- **전체 플로우**: 카운터 생성 → 사용 → 저장 → 복원
- **크로스 플랫폼**: 다양한 플랫폼에서 동일한 동작 확인

## 성능 고려사항

### 메모리 관리
- **서브 카운터**: 최대 1개만 생성 가능
- **상태 최적화**: 불필요한 리빌드 방지를 위한 적절한 Provider 분리

### 저장 최적화 - 디바운싱 패턴
- **즉시 UI 업데이트**: 카운터 값 변경 시 메모리 상태만 즉시 업데이트하여 UI 반응성 보장
- **지연된 DB 저장**: 연속된 카운터 변경 시 200ms 디바운싱을 통해 DB 저장 최적화
- **타이머 기반 저장**: `Timer`를 사용하여 마지막 변경 후 200ms 뒤에 DB 저장 실행
- **강제 저장**: 앱 종료, 화면 전환, Provider dispose 시 즉시 저장하여 데이터 손실 방지

```dart
class CounterNotifier extends Notifier<CounterState> {
  Timer? _saveTimer;
  
  void incrementMain() {
    // 1. 즉시 메모리 상태 업데이트 (UI 반응성)
    state = state.copyWith(mainCounter: state.mainCounter + state.mainCountBy);
    
    // 2. 디바운싱된 DB 저장 예약
    _scheduleDbSave();
  }
  
  void _scheduleDbSave() {
    _saveTimer?.cancel(); // 기존 타이머 취소
    _saveTimer = Timer(Duration(milliseconds: 200), () {
      _saveToDatabase(); // 실제 DB 저장
    });
  }
  
  @override
  void dispose() {
    _saveTimer?.cancel();
    _saveToDatabase(); // 강제 저장
    super.dispose();
  }
}
```

### UI 성능
- **조건부 렌더링**: 서브 카운터 UI의 필요시에만 표시
- **애니메이션**: 부드러운 카운터 값 변경 애니메이션
- **연타 대응**: 빠른 연속 탭에도 UI 지연 없이 즉시 반응

## 플랫폼별 구현 세부사항

### iOS (Cupertino)
- **피커**: `CupertinoPicker` 사용
- **다이얼로그**: `CupertinoAlertDialog` 사용
- **버튼**: `CupertinoButton` 스타일
- **색상**: iOS 시스템 색상 팔레트

### Android (Material)
- **피커**: `showModalBottomSheet` + `ListWheelScrollView` 조합
- **다이얼로그**: `AlertDialog` 사용
- **버튼**: `ElevatedButton`, `IconButton` 사용
- **색상**: Material Design 3 색상 시스템

### 공통 로직
- **비즈니스 로직**: 플랫폼에 관계없이 동일한 Provider 사용
- **데이터 저장**: 모든 플랫폼에서 동일한 Drift 데이터베이스 구조
- **상태 관리**: Riverpod을 통한 일관된 상태 관리

## 의존성

### 기존 의존성 활용
- `drift`: 데이터베이스 ORM (이미 프로젝트에 존재)
- `flutter_riverpod`: 상태 관리
- `cupertino_icons`: iOS 스타일 아이콘
- `material_design`: Android 스타일 컴포넌트

### 추가 의존성 없음
기존 Drift 데이터베이스를 활용하므로 새로운 의존성 추가가 필요하지 않습니다.

## 마이그레이션 계획

### 기존 코드 영향
- **_CounterView 클래스**: 완전히 새로운 구현으로 교체
- **project_detail_screen.dart**: 최소한의 수정 (import 추가)
- **기존 카운터 상태**: 새로운 Provider로 마이그레이션

### 호환성 유지
- **기존 사용자**: 첫 실행 시 기본값으로 초기화
- **기존 UI 구조**: 탭 구조 및 네비게이션 유지
- **스톱워치 연동**: 기존 StopwatchProvider와의 호환성 보장