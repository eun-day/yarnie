# Requirements Document

## Introduction

새로운 데이터베이스 스키마와 Part 시스템을 기반으로 Counter 시스템을 개편합니다. MainCounter의 Row 모드, BuddyCounter의 Stitch/Section 타입, Counter 간 링크 기능을 구현하여 정교한 카운팅 시스템을 제공합니다. (Free 모드는 추후 개발 예정)

## Glossary

- **MainCounter**: 각 Part의 중심 카운터 (Row 모드 또는 Free 모드)
- **BuddyCounter**: MainCounter를 보조하는 카운터 (Stitch 또는 Section 타입)
- **Row_Mode**: 단(행) 진행을 추적하는 모드, 세션과 연동되어 통계 계산
- **Free_Mode**: 자유 카운팅 모드, 시간만 기록하고 통계에서 제외 (추후 개발 예정)
- **Stitch_Counter**: 독립적으로 조작 가능한 BuddyCounter (코 수, 묶음 단위 등), 링크 기능 없음
- **Section_Counter**: MainCounter와 연동되는 BuddyCounter (구간, 패턴 반복 등), 5가지 유형 지원
- **Range_Type**: 특정 구간을 추적하는 Section Counter 유형 (예: "60행부터 10행 동안")
- **Repeat_Type**: 패턴 반복을 추적하는 Section Counter 유형 (예: "4행 패턴 × 5회")
- **Interval_Type**: 일정 간격마다 이벤트를 추적하는 Section Counter 유형 (예: "20행마다 색상 변경")
- **Shaping_Type**: 증감 패턴을 추적하는 Section Counter 유형 (예: "매 2행마다 1코 줄임")
- **Length_Type**: 길이 기준으로 목표를 추적하는 Section Counter 유형 (예: "25cm까지")
- **Link_State**: Section Counter의 연결 상태 ('linked' 또는 'unlinked')
- **Frozen_Main_At**: 언링크 시점의 MainCounter 값 (고정 표시용)
- **SpecJson**: Section Counter의 유형별 설정을 저장하는 JSON 필드
- **SectionRuns**: Section Counter의 구간을 전개한 캐시 테이블
- **Count_By**: 한 번에 증가할 값 설정 (1, 2, 5, 10 등)

## Requirements

### Requirement 1

**User Story:** 사용자로서 MainCounter를 Row 모드로 사용하고 싶으므로, Row 모드 기능이 필요합니다. (Free 모드는 추후 개발 예정)

#### Acceptance Criteria

1. WHEN MainCounter를 Row 모드로 설정할 때, THE Counter_System SHALL count_by를 1로 고정하고 세션 통계에 포함한다
2. WHEN Row 모드에서 카운터를 증가할 때, THE Counter_System SHALL 항상 +1씩 증가한다
3. WHEN MainCounter를 Free 모드로 설정할 때, THE Counter_System SHALL count_by 설정을 허용하고 세션에서 시간만 기록한다 (추후 개발 예정)
4. WHEN MainCounter 모드를 전환할 때, THE Counter_System SHALL 각 모드별 카운터 값을 별도로 저장하고 복원한다 (추후 개발 예정)
5. WHEN 모드를 전환할 때, THE Counter_System SHALL 현재 세그먼트를 종료하고 새로운 모드로 새 세그먼트를 시작한다 (추후 개발 예정)
6. WHEN Free 모드에서 카운터를 조작할 때, THE Counter_System SHALL 설정된 count_by 값만큼 증가/감소한다 (추후 개발 예정)

### Requirement 2

**User Story:** 사용자로서 Stitch Counter를 추가하여 코 수나 묶음 단위를 세고 싶으므로, 독립적인 Stitch Counter 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Stitch Counter를 생성할 때, THE Counter_System SHALL 사용자가 이름과 count_by 값을 설정할 수 있다
2. WHEN Stitch Counter를 조작할 때, THE Counter_System SHALL +/- 버튼으로 독립적으로 값을 변경할 수 있다
3. WHEN Stitch Counter를 리셋할 때, THE Counter_System SHALL 값을 0으로 초기화한다
4. WHEN Stitch Counter를 생성할 때, THE Counter_System SHALL 링크 기능 없이 완전히 독립적으로 동작하도록 한다
5. WHEN Stitch Counter 값을 변경할 때, THE Counter_System SHALL MainCounter나 다른 Counter에 영향을 주지 않는다
6. WHEN Stitch Counter를 표시할 때, THE Counter_System SHALL buddy_type을 'stitch'로 설정하고 linked_to_main_counter를 false로 유지한다

### Requirement 3

**User Story:** 사용자로서 Section Counter를 추가하여 구간이나 패턴 반복을 자동으로 추적하고 싶으므로, Section Counter 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Section Counter를 생성할 때, THE Counter_System SHALL 항상 MainCounter와 링크된 상태로 생성한다
2. WHEN Section Counter를 설정할 때, THE Counter_System SHALL 먼저 5가지 상위 유형(Range, Repeat, Interval, Shaping, Length) 중 하나를 선택하고, 그 다음 해당 유형의 하위 세부 옵션을 선택하도록 한다
3. WHEN MainCounter가 증가할 때, THE Counter_System SHALL Section Counter의 specJson 규칙에 따라 clamp 기반으로 자동 계산한다
4. WHEN Section Counter가 목표에 도달할 때, THE Counter_System SHALL 사용자에게 알림을 표시한다
5. WHEN MainCounter가 Free 모드일 때, THE Counter_System SHALL Section Counter 생성은 허용하되 링크를 비활성화한다 (추후 개발 예정)
6. WHEN Free 모드에서 Section Counter 링크를 활성화하려 할 때, THE Counter_System SHALL Row 모드 전환 확인 다이얼로그를 표시한다 (추후 개발 예정)
7. WHEN Section Counter의 specJson을 저장할 때, THE Counter_System SHALL 유형별 필수 필드를 검증한다
8. WHEN Section Counter를 생성할 때, THE Counter_System SHALL SectionRuns 테이블에 구간 전개 캐시를 자동 생성한다
9. WHEN Range Type을 선택할 때, THE Counter_System SHALL 코 줄임 구간, 무늬 구간, 색상 구간 등의 하위 옵션을 제공한다
10. WHEN Repeat Type을 선택할 때, THE Counter_System SHALL 무늬 반복, 리브 반복 등의 하위 옵션을 제공한다
11. WHEN Interval Type을 선택할 때, THE Counter_System SHALL 색상 교체, 케이블 교차, 무늬 교체 등의 하위 옵션을 제공한다
12. WHEN Shaping Type을 선택할 때, THE Counter_System SHALL 줄임 패턴, 늘림 패턴, 혼합형 등의 하위 옵션을 제공한다

### Requirement 4

**User Story:** 사용자로서 Section Counter의 링크 관계를 관리하고 싶으므로, 링크/언링크 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Section Counter를 언링크할 때, THE Counter_System SHALL link_state를 'unlinked'로 설정하고 frozen_main_at에 현재 MainCounter 값을 저장한다
2. WHEN Section Counter를 재링크할 때, THE Counter_System SHALL link_state를 'linked'로 설정하고 frozen_main_at을 NULL로 초기화한다
3. WHEN Section Counter가 linked 상태일 때, THE Counter_System SHALL MainCounter 값으로 실시간 계산한다
4. WHEN Section Counter가 unlinked 상태일 때, THE Counter_System SHALL frozen_main_at 값을 기준으로 고정 표시한다
5. WHEN MainCounter가 Free 모드로 변경될 때, THE Counter_System SHALL 모든 Section Counter를 자동 언링크한다 (추후 개발 예정)
6. WHEN Section Counter를 재링크할 때, THE Counter_System SHALL 현재 MainCounter 값으로 즉시 동기화한다
7. WHEN Section Counter가 unlinked 상태일 때, THE Counter_System SHALL UI에 "연결 해제됨" 배지를 표시한다

### Requirement 5

**User Story:** 사용자로서 Counter 값을 대량으로 수정하거나 잘못된 값을 빠르게 교정하고 싶으므로, 직접 수정 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Counter 값을 직접 수정할 때, THE Counter_System SHALL 숫자 입력 다이얼로그를 제공한다
2. WHEN MainCounter 값을 직접 수정할 때, THE Counter_System SHALL link_state가 'linked'인 Section Counter들에만 변경을 전파한다
3. WHEN Stitch Counter 값을 직접 수정할 때, THE Counter_System SHALL 해당 Counter만 새로운 값으로 설정한다
4. WHEN 직접 수정으로 음수 값을 입력할 때, THE Counter_System SHALL 0으로 보정한다
5. WHEN Section Counter를 표시할 때, THE Counter_System SHALL 직접 수정 UI를 제공하지 않고 MainCounter 연동을 통해서만 값이 변경되도록 한다
6. WHEN MainCounter 값이 감소할 때, THE Counter_System SHALL Stitch Counter는 독립적으로 동작하고 Section Counter는 link_state가 'linked'인 경우에만 메인 값으로 진행도를 재계산한다
7. WHEN Section Counter 링크를 해제할 때, THE Counter_System SHALL link_state를 'unlinked'로 변경하고 frozen_main_at에 현재 MainCounter 값을 저장한다

### Requirement 6

**User Story:** 사용자로서 Counter를 실수로 조작하는 것을 방지하고 싶으므로, Counter 잠금 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Counter를 잠글 때, THE Counter_System SHALL 모든 +/- 버튼을 비활성화한다
2. WHEN 잠긴 Counter를 조작하려 할 때, THE Counter_System SHALL 잠금 해제를 요청하는 메시지를 표시한다
3. WHEN Counter 잠금을 해제할 때, THE Counter_System SHALL 확인 절차를 거쳐 잠금을 해제한다
4. WHEN MainCounter를 잠글 때, THE Counter_System SHALL 링크된 모든 BuddyCounter도 함께 잠근다
5. WHEN 잠긴 상태에서 모드를 변경하려 할 때, THE Counter_System SHALL 잠금 해제 후 모드 변경을 허용한다 (추후 개발 예정)

### Requirement 7

**User Story:** 사용자로서 Section Counter의 진행률을 확인하고 싶으므로, Section Counter 진행률 표시 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Section Counter를 표시할 때, THE Counter_System SHALL specJson에 정의된 목표를 기반으로 자동 진행률을 계산한다
2. WHEN Section Counter의 진행률을 계산할 때, THE Counter_System SHALL Σ(progress_i) / Σ(rows_total_i) 공식을 사용한다
3. WHEN Section Counter가 목표에 도달할 때, THE Counter_System SHALL 완료 상태를 표시하고 알림을 제공한다
4. WHEN Section Counter의 각 run이 완료될 때, THE Counter_System SHALL 해당 run의 state를 'completed'로 변경한다
5. WHEN Section Counter를 표시할 때, THE Counter_System SHALL 현재 활성 run과 다음 이벤트까지 남은 행수를 보여준다

### Requirement 8

**User Story:** 사용자로서 Section Counter의 Range Type을 사용하여 특정 구간을 추적하고 싶으므로, Range Type 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Range Type Section Counter를 생성할 때, THE Counter_System SHALL 시작행(start_row)과 총 행수(rows_total)를 입력받는다
2. WHEN Range Type의 specJson을 저장할 때, THE Counter_System SHALL type, start_row, rows_total, label 필드를 포함한다
3. WHEN MainCounter가 Range 구간에 진입할 때, THE Counter_System SHALL 진행률을 clamp(main - start_row, 0, rows_total)로 계산한다
4. WHEN Range Type이 완료될 때, THE Counter_System SHALL SectionRuns의 state를 'completed'로 변경한다
5. WHEN Range Type을 표시할 때, THE Counter_System SHALL "N행 중 M행 완료" 형태로 진행률을 보여준다

### Requirement 9

**User Story:** 사용자로서 Section Counter의 Repeat Type을 사용하여 패턴 반복을 추적하고 싶으므로, Repeat Type 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Repeat Type Section Counter를 생성할 때, THE Counter_System SHALL 시작행, 반복당 행수(rows_per_repeat), 반복 횟수(repeat_count)를 입력받는다
2. WHEN Repeat Type의 specJson을 저장할 때, THE Counter_System SHALL type, start_row, rows_per_repeat, repeat_count, label 필드를 포함한다
3. WHEN Repeat Type을 생성할 때, THE Counter_System SHALL SectionRuns에 각 반복을 별도 run으로 전개한다
4. WHEN MainCounter가 각 반복 구간에 진입할 때, THE Counter_System SHALL 현재 반복의 진행률을 계산한다
5. WHEN Repeat Type을 표시할 때, THE Counter_System SHALL "N회 중 M회 완료 (현재: X행/Y행)" 형태로 보여준다

### Requirement 10

**User Story:** 사용자로서 Section Counter의 Interval Type을 사용하여 일정 간격마다 발생하는 이벤트를 추적하고 싶으므로, Interval Type 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Interval Type Section Counter를 생성할 때, THE Counter_System SHALL 시작행, 간격(interval_rows), 액션 타입, 팔레트를 입력받는다
2. WHEN Interval Type의 specJson을 저장할 때, THE Counter_System SHALL type, start_row, interval_rows, action, palette 필드를 포함한다
3. WHEN Interval Type을 생성할 때, THE Counter_System SHALL 목표행까지 또는 +300행까지 구간을 전개한다
4. WHEN MainCounter가 각 간격에 도달할 때, THE Counter_System SHALL 해당 액션(색상 변경 등)을 알림으로 표시한다
5. WHEN Interval Type을 표시할 때, THE Counter_System SHALL 현재 구간과 다음 이벤트까지 남은 행수를 보여준다

### Requirement 11

**User Story:** 사용자로서 Section Counter의 Shaping Type을 사용하여 증감 패턴을 추적하고 싶으므로, Shaping Type 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Shaping Type Section Counter를 생성할 때, THE Counter_System SHALL 시작행, 간격(interval_rows), 증감량(amount), 반복 횟수를 입력받는다
2. WHEN Shaping Type의 specJson을 저장할 때, THE Counter_System SHALL type, start_row, interval_rows, amount, repeat_count 필드를 포함한다
3. WHEN Shaping Type을 생성할 때, THE Counter_System SHALL 각 증감 단위를 별도 run으로 SectionRuns에 전개한다
4. WHEN MainCounter가 각 증감 구간에 도달할 때, THE Counter_System SHALL 누적 증감량을 계산하여 표시한다
5. WHEN Shaping Type을 표시할 때, THE Counter_System SHALL "N회 중 M회 완료 (누적: +X코)" 형태로 보여준다

### Requirement 12

**User Story:** 사용자로서 Section Counter의 Length Type을 사용하여 길이 기준으로 목표를 추적하고 싶으므로, Length Type 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Length Type Section Counter를 생성할 때, THE Counter_System SHALL 프로젝트에 저장된 게이지 정보가 있으면 자동으로 채우고, 없으면 사용자에게 게이지를 입력받아 프로젝트 정보에 저장한다
2. WHEN Length Type의 specJson을 저장할 때, THE Counter_System SHALL type, start_row, target_length, gauge_rows_per_10cm, units 필드를 포함한다
3. WHEN Length Type을 생성할 때, THE Counter_System SHALL 게이지를 기반으로 필요 행수를 자동 계산한다
4. WHEN MainCounter가 Length 구간에 진입할 때, THE Counter_System SHALL 예상 길이와 진행률을 계산한다
5. WHEN Length Type을 표시할 때, THE Counter_System SHALL "목표 Ncm (예상 M행 중 X행 완료)" 형태로 보여준다
6. WHEN 사용자가 게이지를 새로 입력할 때, THE Counter_System SHALL 해당 게이지 정보를 프로젝트 정보에 자동으로 저장한다
7. WHEN 프로젝트에 게이지 정보가 이미 있을 때, THE Counter_System SHALL Length Type 생성 시 해당 값을 기본값으로 제공한다

### Requirement 13

**User Story:** 개발자로서 Section Counter의 데이터 모델을 구현하고 싶으므로, SectionCounters와 SectionRuns 테이블이 필요합니다.

#### Acceptance Criteria

1. WHEN SectionCounters 테이블을 생성할 때, THE Counter_System SHALL buddy_id, spec_json, link_state, frozen_main_at, schema_ver 필드를 포함한다
2. WHEN SectionRuns 테이블을 생성할 때, THE Counter_System SHALL buddy_id, ord, start_row, rows_total, label, state 필드를 포함한다
3. WHEN Section Counter를 생성할 때, THE Counter_System SHALL specJson을 파싱하여 SectionRuns에 구간을 전개한다
4. WHEN Section Counter 진행률을 계산할 때, THE Counter_System SHALL clamp(X - start_row, 0, rows_total) 공식을 사용한다
5. WHEN SectionRuns의 state를 업데이트할 때, THE Counter_System SHALL scheduled/active/completed/skipped 중 하나로 설정한다
6. WHEN Section Counter를 삭제할 때, THE Counter_System SHALL 관련된 SectionRuns도 cascade 삭제한다

### Requirement 14

**User Story:** 개발자로서 Counter 데이터의 무결성과 성능을 보장하고 싶으므로, Counter 관련 비즈니스 로직 검증이 필요합니다.

#### Acceptance Criteria

1. WHEN Counter 값을 변경할 때, THE Counter_System SHALL 음수 값을 허용하지 않는다
2. WHEN count_by 값을 설정할 때, THE Counter_System SHALL 1 이상의 정수만 허용한다
3. WHEN Counter 조작이 빈번할 때, THE Counter_System SHALL 디바운싱을 적용하여 DB 저장을 최적화한다
4. WHEN 여러 Counter를 동시에 업데이트할 때, THE Counter_System SHALL 트랜잭션으로 원자성을 보장한다
5. WHEN Counter 데이터를 조회할 때, THE Counter_System SHALL 캐싱을 활용하여 성능을 최적화한다
6. WHEN SectionRuns 캐시를 생성할 때, THE Counter_System SHALL 성능을 위해 필요한 인덱스를 활용한다
7. WHEN specJson을 검증할 때, THE Counter_System SHALL 각 유형별 필수 필드와 데이터 타입을 확인한다
8. WHEN Section Counter 생성 시 시작행을 비워둘 때, THE Counter_System SHALL 저장 시점의 MainCounter 값을 자동으로 시작행으로 설정한다