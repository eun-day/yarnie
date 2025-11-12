# Requirements Document

## Introduction

새로운 데이터베이스 스키마를 기반으로 Part 시스템을 구현합니다. Part는 프로젝트 내의 특정 구간 또는 단계를 나타내며, 각 Part는 기본적으로 MainCounter 1개를 가지고 필요에 따라 여러 개의 BuddyCounter를 추가할 수 있습니다. 사용자는 프로젝트를 여러 Part로 나누어 체계적으로 관리할 수 있습니다.

## Glossary

- **Part**: 프로젝트 내의 특정 구간 또는 단계 (예: 몸통, 소매, 목 부분)
- **Part_Management**: Part 생성, 수정, 삭제, 순서 변경 등의 데이터 관리 기능 (비즈니스 로직)
- **Part_Navigation**: Part 간 이동, 선택, 표시를 담당하는 UI 컴포넌트 및 네비게이션 로직
- **MainCounter**: 각 Part에 자동으로 생성되는 기본 카운터
- **BuddyCounter**: MainCounter를 보조하는 카운터 (Stitch 또는 Section 타입)
- **Default_Part**: 프로젝트 생성 시 자동으로 만들어지는 기본 Part
- **Active_Part**: 현재 작업 중인 Part

## Requirements

### Requirement 1

**User Story:** 사용자로서 프로젝트를 여러 구간으로 나누어 관리하고 싶으므로, Part를 생성하고 관리할 수 있는 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 새 프로젝트를 생성할 때, THE Part_Management SHALL 기본 Part를 자동으로 생성한다 (이름 수정 가능)
2. WHEN Part를 추가할 때, THE Part_Management SHALL 사용자가 입력한 이름으로 새 Part를 생성한다
3. WHEN Part 이름을 수정할 때, THE Part_Management SHALL 기존 Part의 이름을 업데이트한다
4. WHEN Part를 삭제할 때, THE Part_Management SHALL 관련된 Counter와 Session 데이터도 함께 삭제한다
5. WHEN Part 목록을 조회할 때, THE Part_Management SHALL order_index 순서로 정렬된 Part 목록을 반환한다

### Requirement 2

**User Story:** 사용자로서 Part의 순서를 자유롭게 변경하고 싶으므로, Part 순서 관리 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Part 순서를 변경할 때, THE Part_Management SHALL 드래그 앤 드롭으로 순서를 조정할 수 있다
2. WHEN Part 순서가 변경될 때, THE Part_Management SHALL order_index 값을 자동으로 재계산한다
3. WHEN 새 Part를 추가할 때, THE Part_Management SHALL 마지막 순서에 배치한다
4. WHEN Part를 삭제할 때, THE Part_Management SHALL 남은 Part들의 순서를 자동으로 정리한다

### Requirement 3

**User Story:** 개발자로서 각 Part에 MainCounter가 자동으로 생성되어야 하므로, Part-Counter 연동 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Part를 생성할 때, THE Part_Management SHALL 해당 Part에 MainCounter를 자동으로 생성한다
2. WHEN MainCounter를 생성할 때, THE Part_Management SHALL 기본값(현재값: 0, count_by: 1, mode: row)으로 설정한다
3. WHEN Part를 삭제할 때, THE Part_Management SHALL 연결된 MainCounter도 함께 삭제한다
4. WHEN Part별 MainCounter를 조회할 때, THE Part_Management SHALL Part ID로 연결된 MainCounter를 반환한다

### Requirement 4

**User Story:** 사용자로서 Part에 BuddyCounter를 추가하여 세부 작업을 추적하고 싶으므로, BuddyCounter 관리 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 무료 사용자가 BuddyCounter를 추가할 때, THE Part_Management SHALL Part당 최대 1개까지만 허용한다
2. WHEN 프리미엄 사용자가 BuddyCounter를 추가할 때, THE Part_Management SHALL Part당 제한 없이 여러 개를 허용한다
3. WHEN BuddyCounter를 생성할 때, THE Part_Management SHALL 사용자가 Stitch 또는 Section 타입을 선택할 수 있다
4. WHEN BuddyCounter를 삭제할 때, THE Part_Management SHALL 해당 카운터와 관련된 데이터를 함께 정리한다
5. WHEN 사용자 등급을 확인할 때, THE Part_Management SHALL 현재 사용자의 프리미엄 상태를 조회한다

### Requirement 5

**User Story:** 사용자로서 Part별로 메모를 작성하고 관리하고 싶으므로, Part 메모 시스템이 필요합니다.

#### Acceptance Criteria

1. WHEN Part 화면에서 메모를 추가할 때, THE Part_Management SHALL 새 메모를 생성하고 Part와 연결한다
2. WHEN 메모를 상단 고정할 때, THE Part_Management SHALL pinned 필드를 true로 설정하고 목록 상단에 표시한다
3. WHEN 메모 목록을 표시할 때, THE Part_Management SHALL pinned DESC, created_at DESC 순서로 정렬한다
4. WHEN 메모를 수정할 때, THE Part_Management SHALL 본문을 업데이트하고 수정일시를 갱신한다
5. WHEN 메모를 삭제할 때, THE Part_Management SHALL 사용자 확인 후 메모를 제거한다

### Requirement 6

**User Story:** 사용자로서 현재 작업 중인 Part를 명확히 알고 싶으므로, Active Part 관리 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 프로젝트에 진입할 때, THE Part_Navigation SHALL Projects 테이블의 current_part_id를 조회하여 Active Part로 설정한다
2. WHEN Part를 변경할 때, THE Part_Navigation SHALL 새로운 Part를 Active Part로 업데이트하고 current_part_id를 저장한다
3. WHEN 세션이 진행 중일 때, THE Part_Navigation SHALL Part 변경 시 세션을 자동 일시정지한다
4. WHEN Active Part를 표시할 때, THE Part_Navigation SHALL UI에서 현재 Part를 시각적으로 강조한다
5. WHEN current_part_id가 없는 프로젝트에 접근할 때, THE Part_Navigation SHALL 첫 번째 Part를 Active로 설정하고 current_part_id를 저장한다

### Requirement 7

**User Story:** 사용자로서 Part 관련 작업을 직관적으로 수행하고 싶으므로, 사용자 친화적인 Part UI가 필요합니다.

#### Acceptance Criteria

1. WHEN Part 목록을 표시할 때, THE Part_Navigation SHALL 탭 또는 리스트 형태로 Part들을 보여준다
2. WHEN Part를 추가할 때, THE Part_Navigation SHALL 간단한 다이얼로그나 인라인 입력으로 이름을 받는다
3. WHEN Part를 편집할 때, THE Part_Navigation SHALL 길게 누르기나 컨텍스트 메뉴로 편집 옵션을 제공한다
4. WHEN Part가 많을 때, THE Part_Navigation SHALL 스크롤 가능한 형태로 모든 Part를 표시한다
5. WHEN Part 작업 중 오류가 발생할 때, THE Part_Navigation SHALL 사용자에게 명확한 오류 메시지를 표시한다

### Requirement 8

**User Story:** 개발자로서 Part 데이터의 무결성을 보장하고 싶으므로, Part 관련 비즈니스 로직 검증이 필요합니다.

#### Acceptance Criteria

1. WHEN Part 이름을 입력할 때, THE Part_Management SHALL 빈 문자열이나 공백만 있는 이름을 거부한다
2. WHEN Part를 삭제할 때, THE Part_Management SHALL 프로젝트에 Part가 1개만 남은 경우 삭제를 거부한다
3. WHEN 같은 이름의 Part를 생성할 때, THE Part_Management SHALL 중복 이름을 허용하되 사용자에게 알림을 표시한다
4. WHEN Part와 연결된 세션이 있을 때, THE Part_Management SHALL 삭제 전 사용자에게 확인을 요청한다
5. WHEN Part 순서를 변경할 때, THE Part_Management SHALL 유효하지 않은 순서 값을 자동으로 보정한다