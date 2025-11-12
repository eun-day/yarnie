# Requirements Document

## Introduction

새로운 Part 시스템을 기반으로 Session과 SessionSegment 시스템을 구현합니다. Part와 Session의 1:1 관계, 세그먼트 기반 시간 추적, 백그라운드 타이머를 통해 정확하고 끊김 없는 뜨개 작업 시간 관리를 제공합니다.

## Glossary

- **Session**: Part와 1:1 관계로 연결된 작업 시간 기록 단위
- **SessionSegment**: Session 내부적으로 관리되는 시간 구간 (사용자에게는 노출되지 않음)
- **Active_Session**: 현재 진행 중이거나 일시정지된 세션
- **Segment_Split**: 일시정지, 재시작, 자정 교차 등으로 인한 세그먼트 분할
- **Background_Timer**: 앱이 백그라운드에 있어도 계속 동작하는 타이머
- **Session_Recovery**: 앱 크래시나 강제 종료 후 세션 상태를 복구하는 기능


## Requirements

### Requirement 1

**User Story:** 사용자로서 Part별로 독립적인 세션을 유지하면서 작업 시간을 추적하고 싶으므로, Part-Session 1:1 관계 기반 세션 관리가 필요합니다.

#### Acceptance Criteria

1. WHEN 현재 작업 중인 Part에서 세션을 시작할 때, THE Session_System SHALL 해당 Part에 세션이 없으면 새로 생성하고 첫 번째 세그먼트를 시작한다
2. WHEN 이미 세션이 있는 Part에서 세션을 시작할 때, THE Session_System SHALL 기존 세션의 상태를 running으로 변경하고 새 세그먼트를 생성한다
3. WHEN Part를 변경할 때, THE Session_System SHALL 현재 세션을 일시정지(paused 상태)하고 새 Part의 세션 상태를 running으로 변경한다
4. WHEN 동일 Part로 돌아와 이어하기를 선택할 때, THE Session_System SHALL 해당 Part의 세션 상태를 running으로 변경한다


### Requirement 2

**User Story:** 사용자로서 일시정지와 재시작을 자유롭게 하면서도 정확한 시간 추적을 원하므로, 세그먼트 기반 시간 관리가 필요합니다.

#### Acceptance Criteria

1. WHEN 세션을 일시정지할 때, THE Session_System SHALL 현재 세그먼트를 종료하고 reason을 'pause'로 기록한다
2. WHEN 세션을 재시작할 때, THE Session_System SHALL 새로운 세그먼트를 생성하고 reason을 'resume'으로 기록한다
3. WHEN 자정을 넘어갈 때, THE Session_System SHALL 자동으로 세그먼트를 분할하고 reason을 'midnight_split'으로 기록한다
4. WHEN Part를 변경할 때, THE Session_System SHALL 현재 세그먼트를 종료하고 reason을 'part_change'로 기록한다
5. WHEN 세그먼트가 종료될 때, THE Session_System SHALL 해당 세그먼트의 지속 시간을 계산하고 Session의 총 시간에 누적한다

### Requirement 3

**User Story:** 사용자로서 앱을 백그라운드에 두거나 화면을 꺼도 시간 추적이 계속되기를 원하므로, 백그라운드 타이머 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 앱이 백그라운드로 전환될 때, THE Session_System SHALL 타이머를 계속 실행하고 알림에 일시정지/종료 버튼을 표시한다
2. WHEN 화면이 꺼질 때, THE Session_System SHALL 타이머 동작을 유지한다 (화면 켜짐 유지 설정이 꺼진 경우)
3. WHEN 장시간 백그라운드 상태일 때, THE Session_System SHALL 설정된 시간 후 자동 일시정지 확인 알림을 표시한다
4. WHEN 앱으로 복귀할 때, THE Session_System SHALL 이탈 시간을 계산하고 시간 반영 여부를 사용자에게 확인한다
5. WHEN 백그라운드 알림 버튼을 누를 때, THE Session_System SHALL 해당 동작(일시정지/종료)을 즉시 실행한다

### Requirement 4

**User Story:** 사용자로서 앱 크래시나 예상치 못한 종료 후에도 세션이 복구되기를 원하므로, 세션 복구 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 세션을 시작할 때, THE Session_System SHALL 시작 정보를 즉시 로컬 DB에 저장한다
2. WHEN 앱이 예상치 못하게 종료될 때, THE Session_System SHALL 마지막 저장된 상태 정보를 보존한다
3. WHEN 앱을 재시작할 때, THE Session_System SHALL running 상태로 남아있는 세션이 있는지 확인하고 복구 옵션을 제공한다
4. WHEN 세션 복구를 선택할 때, THE Session_System SHALL 세션 상태를 복구하고 앱 종료 시점까지의 시간을 계산하여 미완성 세그먼트를 완료 처리한다
5. WHEN 세션 복구를 거부할 때, THE Session_System SHALL 세션 상태를 paused로 변경하고 미완성 세그먼트를 삭제한다

### Requirement 5

**User Story:** 사용자로서 세션 통계와 히트맵을 정확하게 보고 싶으므로, 세그먼트 기반 통계 계산 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 일별 통계를 계산할 때, THE Session_System SHALL 해당 날짜의 모든 세그먼트 시간을 합산한다
2. WHEN Part별 통계를 계산할 때, THE Session_System SHALL Part ID로 세그먼트를 필터링하여 집계한다
3. WHEN 단수 진행률을 계산할 때, THE Session_System SHALL 세그먼트의 시작/종료 카운터 값 차이를 사용한다
4. WHEN 평균 페이스를 계산할 때, THE Session_System SHALL (총 단수 증가) / (총 시간)으로 계산한다
5. WHEN 히트맵을 생성할 때, THE Session_System SHALL 세그먼트 시간을 날짜별로 그룹화하여 표시한다

### Requirement 6

**User Story:** 사용자로서 세션 관련 설정을 조정하고 싶으므로, 세션 동작 커스터마이징 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 백그라운드 자동 일시정지를 설정할 때, THE Session_System SHALL 설정된 시간(5/10/15분 또는 무제한) 후 확인 알림을 표시한다
2. WHEN 복귀 시 확인 설정을 조정할 때, THE Session_System SHALL 설정된 임계값(3분) 이상 이탈 시에만 확인한다
3. WHEN 알림 권한이 없을 때, THE Session_System SHALL 백그라운드 기능 제한을 사용자에게 안내한다
4. WHEN 배터리 최적화가 활성화된 경우, THE Session_System SHALL 정확한 시간 추적을 위한 설정 가이드를 제공한다

### Requirement 7

**User Story:** 개발자로서 정확한 시간 측정과 데이터 무결성을 보장하고 싶으므로, 세션 관련 비즈니스 로직 검증이 필요합니다.

#### Acceptance Criteria

1. WHEN 시간을 측정할 때, THE Session_System SHALL 정확한 경과 시간 계산을 위해 적절한 시간 측정 방식을 사용한다
2. WHEN 세그먼트를 생성할 때, THE Session_System SHALL 동일 세션 내에서 시간 순서가 올바른지 확인한다

3. WHEN 세션 데이터를 조회할 때, THE Session_System SHALL 인덱스를 활용하여 성능을 최적화한다
4. WHEN 대량의 세그먼트를 처리할 때, THE Session_System SHALL 페이징을 적용하여 메모리 사용량을 제한한다