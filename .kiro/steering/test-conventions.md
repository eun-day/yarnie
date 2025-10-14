# 테스트 컨벤션

## 파일 구조
```
test/
├── helpers/                    # 공통 테스트 헬퍼들
│   ├── database_test_base.dart # DB 테스트 기본 클래스
│   └── test_helpers.dart       # 모든 테스트 헬퍼 함수들 (카운터 포함)
├── counter_feature/            # 카운터 기능 테스트
├── session_management/         # 세션 관리 테스트
└── widget_test.dart           # 위젯 테스트
```

## DB 테스트 패턴

### 기본 구조
모든 DB 관련 테스트는 다음 패턴을 따라야 합니다:

```dart
import '../helpers/test_helpers.dart';
import '../helpers/database_test_base.dart';

void main() {
  databaseTestGroup('테스트 그룹명', (db, projectId) {
    test('테스트 케이스', () async {
      // Given
      // When  
      // Then
    });
  });
}
```

### 카운터 테스트 패턴
카운터 관련 테스트는 통합된 헬퍼를 사용합니다:

```dart
import '../helpers/test_helpers.dart';

void main() {
  databaseTestGroup('카운터 테스트', (db, projectId) {
    test('카운터 상태 검증', () async {
      // Given
      await CounterTestHelpers.createTestCounterData(db, projectId);
      
      // When
      final container = CounterTestHelpers.createCounterTestContainer(db);
      
      // Then
      CounterTestHelpers.expectCounterState(state, ...);
      container.dispose();
    });
  });
}
```

### 필수 import
- `../helpers/test_helpers.dart`: 모든 테스트 헬퍼 함수들 (카운터 포함)
- `../helpers/database_test_base.dart`: DB 테스트 기본 클래스 (필요시)

### 헬퍼 함수 사용
#### 공통 헬퍼 (`test_helpers.dart`)
- `createTestDb()`: 테스트용 DB 생성
- `createTestProject()`: 테스트용 프로젝트 생성
- `databaseTestGroup()`: DB 테스트 그룹 설정
- `createCompletedSession()`: 완료된 세션 생성
- `expectDurationCloseTo()`: 시간 정확도 검증

#### 카운터 헬퍼 (`test_helpers.dart` 내 `CounterTestHelpers` 클래스)
- `CounterTestHelpers.createTestCounterData()`: 테스트용 카운터 데이터 생성
- `CounterTestHelpers.expectCounterState()`: 카운터 상태 검증
- `CounterTestHelpers.createCounterTestContainer()`: 카운터 테스트 컨테이너 생성
- `testCounterProvider`: 저장 횟수 추적 가능한 테스트 프로바이더

### Provider 테스트 패턴
```dart
final container = ProviderContainer(
  overrides: [appDbProvider.overrideWithValue(db)],
);
// 테스트 로직
container.dispose(); // 반드시 정리
```

## 네이밍 컨벤션
- 테스트 파일: `feature_name_test.dart`
- 헬퍼 파일: `*_helpers.dart` 또는 `*_test_base.dart`
- 테스트 그룹: 한국어로 명확한 설명
- 테스트 케이스: Given-When-Then 패턴 사용

## 마이그레이션 가이드
기존 테스트 파일들의 import 경로를 다음과 같이 변경:
- `../session_management/test_helpers.dart` → `../helpers/test_helpers.dart`
- `../session_management/database_test_base.dart` → `../helpers/database_test_base.dart`