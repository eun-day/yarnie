# 구현 계획

- [x] 1. 프로젝트 설정 및 의존성 추가
  - pubspec.yaml에 shared_preferences 의존성 추가
  - flutter pub get 실행하여 의존성 설치
  - _요구사항: 6.1, 6.2, 6.3, 6.4_

- [x] 2. 카운터 데이터 모델 생성
  - lib/model/counter_data.dart 파일 생성
  - CounterData 클래스 구현 (mainCounter, mainCountBy, subCounter, subCountBy, hasSubCounter 필드)
  - JSON 직렬화/역직렬화 메서드 구현 (toJson, fromJson)
  - _요구사항: 6.1, 6.2, 6.3, 6.4, 7.1, 7.2, 7.3_

- [x] 3. 카운터 프로바이더 구현
- [x] 3.1 기본 카운터 상태 관리 구현
  - lib/providers/counter_provider.dart 파일 생성
  - CounterState 클래스 구현 (copyWith 메서드 포함)
  - CounterNotifier 클래스의 기본 구조 구현
  - 기본 상태 초기화 로직 구현
  - _요구사항: 3.1, 4.2, 7.4_

- [x] 3.2 메인 카운터 조작 메서드 구현
  - incrementMain, decrementMain 메서드 구현 (countBy 단위로 증감)
  - resetMain 메서드 구현
  - setMainCountBy 메서드 구현
  - _요구사항: 3.1, 4.5, 5.3, 5.4_

- [x] 3.3 서브 카운터 관리 메서드 구현
  - addSubCounter, removeSubCounter 메서드 구현
  - incrementSub, decrementSub 메서드 구현 (서브 카운터의 countBy 단위로 증감)
  - resetSub 메서드 구현
  - setSubCountBy 메서드 구현
  - _요구사항: 2.1, 3.1, 4.5_

- [x] 3.4 SharedPreferences 데이터 지속성 구현
  - _saveToPrefs 메서드 구현 (모든 카운터 값들을 개별 키로 저장)
  - _loadFromPrefs 메서드 구현 (저장된 값들을 로드하여 상태 복원)
  - 에러 처리 로직 구현 (저장/로드 실패 시 기본값 사용)
  - _요구사항: 6.1, 6.2, 6.3, 6.4, 7.1, 7.2, 7.3, 7.4_

- [x] 4. 카운터 표시 위젯 구현
- [x] 4.1 메인 카운터 표시 위젯 생성
  - lib/widget/counter_display.dart 파일 생성
  - 큰 숫자를 중앙정렬로 표시하는 위젯 구현
  - 터치 시 초기화 확인 다이얼로그 표시 기능 구현
  - 플랫폼별 다이얼로그 스타일 적용 (iOS: CupertinoAlertDialog, Android: AlertDialog)
  - _요구사항: 3.1, 3.2, 8.1, 8.2, 8.3_

- [x] 4.2 서브 카운터 아이템 위젯 생성
  - lib/widget/sub_counter_item.dart 파일 생성
  - "- [ 숫자 ] +" 형태의 간소한 UI 구현
  - 서브 카운터 증감 버튼 기능 구현
  - 삭제 버튼 기능 구현
  - _요구사항: 2.1_

- [x] 5. Count By 설정 위젯 구현
- [x] 5.1 Count By 선택기 위젯 생성
  - lib/widget/count_by_selector.dart 파일 생성
  - "count by X" 버튼 UI 구현
  - 현재 설정된 count by 값 표시 기능 구현
  - _요구사항: 4.1, 4.2_

- [x] 5.2 Count By 설정 팝업 구현
  - 휠피커를 사용한 숫자 선택 팝업 구현
  - 플랫폼별 피커 스타일 적용 (iOS: CupertinoPicker, Android: ListWheelScrollView)
  - 1-10 범위의 숫자 선택 기능 구현
  - 확인/취소 버튼 기능 구현
  - _요구사항: 4.3, 4.4, 8.1, 8.2, 8.3_

- [ ] 6. 메인 카운터 화면 UI 구현
- [x] 6.1 스톱워치 연동 표시 영역 구현
  - 스톱워치가 실행 중일 때만 표시되는 상단 영역 구현
  - 스톱워치 시간 표시 및 시작/일시정지 버튼 구현
  - stopwatchProvider와의 연동 로직 구현
  - _요구사항: 1.1, 1.2, 1.3_

- [x] 6.2 카운터 추가 버튼 구현
  - "카운터 추가" 버튼 UI 구현
  - 서브 카운터가 이미 있을 때는 버튼 비활성화 또는 숨김 처리
  - 버튼 클릭 시 서브 카운터 생성 기능 구현
  - _요구사항: 2.1_

- [x] 6.3 메인 카운터 영역 구성
  - CounterDisplay 위젯을 사용한 메인 카운터 숫자 표시
  - 메인 카운터용 CountBySelector 위젯 배치
  - 적절한 레이아웃과 스타일링 적용
  - _요구사항: 3.1, 4.1, 4.2_

- [x] 6.4 메인 카운터 +/- 버튼 영역 구현
  - 화면 너비를 절반씩 차지하는 세로로 긴 - 버튼과 + 버튼 구현
  - 버튼 클릭 시 메인 카운터 증감 기능 구현
  - 플랫폼별 버튼 스타일 적용
  - _요구사항: 5.1, 5.2, 5.3, 5.4, 8.1, 8.2, 8.3_

- [x] 6.5 서브 카운터 영역 구성
  - 서브 카운터가 있을 때만 표시되는 조건부 렌더링 구현
  - SubCounterItem 위젯을 사용한 서브 카운터 표시
  - 서브 카운터용 CountBySelector 위젯 배치
  - _요구사항: 2.1, 4.1, 4.2_

- [x] 7. 기존 _CounterView 교체
- [x] 7.1 기존 _CounterView 클래스 백업 및 제거
  - project_detail_screen.dart에서 기존 _CounterView 클래스 주석 처리
  - 새로운 _CounterView 클래스 구현 준비
  - _요구사항: 모든 요구사항_

- [x] 7.2 새로운 _CounterView 클래스 구현
  - ConsumerStatefulWidget으로 새로운 _CounterView 클래스 구현
  - counterProvider 연동 및 상태 구독 구현
  - 앞서 구현한 모든 위젯들을 조합한 완전한 카운터 화면 구성
  - 플랫폼별 레이아웃 최적화
  - _요구사항: 모든 요구사항_

- [x] 8. 통합 테스트 및 버그 수정
- [x] 8.1 카운터 기능 전체 플로우 테스트
  - 메인 카운터 증감, 초기화 기능 테스트
  - 서브 카운터 생성, 조작, 삭제 기능 테스트
  - count by 설정 기능 테스트
  - 스톱워치 연동 기능 테스트
  - _요구사항: 모든 요구사항_

- [x] 8.2 데이터 지속성 테스트
  - 앱 재시작 후 카운터 값 복원 테스트
  - SharedPreferences 저장/로드 기능 테스트
  - 에러 상황에서의 기본값 처리 테스트
  - _요구사항: 6.1, 6.2, 6.3, 6.4, 7.1, 7.2, 7.3, 7.4_

- [x] 8.3 플랫폼별 UI 테스트
  - iOS에서 Cupertino 스타일 컴포넌트 동작 테스트
  - Android에서 Material Design 컴포넌트 동작 테스트
  - 다양한 화면 크기에서의 레이아웃 테스트
  - _요구사항: 8.1, 8.2, 8.3, 8.4_

- [x] 8.4 성능 최적화 및 최종 검토
  - 불필요한 리빌드 방지를 위한 Provider 최적화
  - 메모리 사용량 확인 및 최적화
  - 코드 리뷰 및 리팩토링
  - _요구사항: 모든 요구사항_