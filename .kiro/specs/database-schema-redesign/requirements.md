# Requirements Document

## Introduction

Yarnie 앱의 기존 Session, MainCounter, SubCounter, label 개념을 새로운 Part, MainCounter, BuddyCounter, Session, SessionSegment 구조로 전면 개편하기 위한 데이터베이스 스키마 변경입니다. 이는 더 유연하고 체계적인 프로젝트 관리를 위한 핵심 기반 작업입니다.

## Glossary

- **Part**: 프로젝트 내의 특정 구간 또는 단계 (예: 몸통, 소매, 목 부분)
- **MainCounter**: 각 Part의 중심 카운터 (Row 모드 또는 Free 모드)
- **BuddyCounter**: MainCounter를 보조하는 카운터 (Stitch 또는 Section 타입)
- **Session**: 사용자의 뜨개 작업 시간을 기록하는 단위
- **SessionSegment**: Session 내의 실제 시간 구간 (일시정지, 재시작, 모드 변경 등으로 분할)
- **Tag**: 프로젝트를 분류하기 위한 사용자 정의 태그 (이름과 색상 포함)
- **ProjectTag**: 프로젝트와 태그의 다대다 관계를 나타내는 연결 테이블
- **Database_Schema**: Drift ORM을 사용한 SQLite 데이터베이스 테이블 구조
- **Migration**: 기존 데이터베이스 구조에서 새로운 구조로의 변경 (개발 단계이므로 제외)

## Requirements

### Requirement 1

**User Story:** 개발자로서 새로운 Part 시스템을 지원하는 데이터베이스 구조가 필요하므로, Part 테이블과 관련 관계를 정의하고 싶습니다.

#### Acceptance Criteria

1. WHEN Part 테이블을 생성할 때, THE Database_Schema SHALL 프로젝트 ID, 이름, 순서, 생성일시, 수정일시 필드를 포함한다
2. WHEN Projects 테이블을 확장할 때, THE Database_Schema SHALL current_part_id 필드를 추가하여 활성 Part를 저장한다
3. WHEN Part와 Project 관계를 정의할 때, THE Database_Schema SHALL 1:N 관계를 외래키로 설정한다
4. WHEN Part 순서를 관리할 때, THE Database_Schema SHALL 정수형 order_index 필드를 제공한다
5. WHEN Part를 삭제할 때, THE Database_Schema SHALL 관련된 Counter와 Session 데이터의 cascade 삭제를 지원한다

### Requirement 2

**User Story:** 개발자로서 MainCounter와 BuddyCounter를 구분하여 관리하고 싶으므로, 통합된 Counter 테이블 구조가 필요합니다.

#### Acceptance Criteria

1. WHEN Counter 테이블을 생성할 때, THE Database_Schema SHALL Part ID, Main/Buddy 구분, Buddy 타입, 현재 값, count-by 설정 필드를 포함한다
2. WHEN MainCounter와 BuddyCounter를 구분할 때, THE Database_Schema SHALL is_main 불린 필드를 제공한다
3. WHEN BuddyCounter 타입을 구분할 때, THE Database_Schema SHALL buddy_type enum 필드(stitch/section)를 제공한다
4. WHEN count_by 설정을 저장할 때, THE Database_Schema SHALL Main Counter와 Stitch Counter에서 사용할 count_by 필드를 제공한다
5. WHEN Section Counter를 저장할 때, THE Database_Schema SHALL count_by를 사용하지 않고 메인과 연동되는 구조를 제공한다 (세부 유형별 필드는 3단계에서 정의)
6. WHEN BuddyCounter 링크 관계를 설정할 때, THE Database_Schema SHALL linked_to_main_counter 불린 필드를 제공한다 (MainCounter일 때는 null)


### Requirement 3

**User Story:** 개발자로서 새로운 Session과 SessionSegment 구조를 구현하고 싶으므로, 시간 추적과 통계를 위한 테이블이 필요합니다.

#### Acceptance Criteria

1. WHEN Session 테이블을 생성할 때, THE Database_Schema SHALL Part ID, 시작시간, 종료시간, 총 시간, 상태 필드를 포함한다 (Part와 1:1 관계, 총 시간은 각 SessionSegment 종료 시마다 누적하여 저장)
2. WHEN SessionSegment 테이블을 생성할 때, THE Database_Schema SHALL Session ID, Part ID, 시작시간, 종료시간, 시간, 시작 카운트, 종료 카운트, 분할 이유 필드를 포함한다
3. WHEN Session과 SessionSegment 관계를 정의할 때, THE Database_Schema SHALL 1:N 관계를 외래키로 설정한다
4. WHEN 통계 계산을 위해 데이터를 조회할 때, THE Database_Schema SHALL SessionSegment 데이터로 Row 모드 통계를 계산한다
5. WHEN 자정 교차나 모드 변경을 추적할 때, THE Database_Schema SHALL reason enum 필드(pause/resume/mode_change/part_change/midnight_split)를 제공한다

### Requirement 4

**User Story:** 개발자로서 기존 WorkSessions와 ProjectCounters 테이블을 새로운 구조로 전환하고 싶으므로, 기존 테이블 구조 변경이 필요합니다.

#### Acceptance Criteria

1. WHEN 기존 WorkSessions 테이블을 대체할 때, THE Database_Schema SHALL 새로운 Sessions와 SessionSegments 테이블로 기능을 분리한다
2. WHEN 기존 ProjectCounters 테이블을 대체할 때, THE Database_Schema SHALL 새로운 Counters 테이블로 mainCounter와 subCounter 기능을 통합한다
3. WHEN 기존 label 필드를 Part 시스템으로 전환할 때, THE Database_Schema SHALL WorkSessions의 label을 Part 관계로 대체한다
4. WHEN 코드 생성을 실행할 때, THE Database_Schema SHALL build_runner를 통해 새로운 구조의 .g.dart 파일을 생성한다

### Requirement 5

**User Story:** 개발자로서 Part별 메모 시스템을 지원하고 싶으므로, PartNote 테이블이 필요합니다.

#### Acceptance Criteria

1. WHEN PartNote 테이블을 생성할 때, THE Database_Schema SHALL Part ID, 메모 본문, 상단 고정 여부, 생성일시, 수정일시 필드를 포함한다
2. WHEN PartNote와 Part 관계를 정의할 때, THE Database_Schema SHALL 1:N 관계를 외래키로 설정한다
3. WHEN 메모 정렬을 위한 인덱스를 생성할 때, THE Database_Schema SHALL part_id와 pinned, created_at 필드에 복합 인덱스를 생성한다
4. WHEN Part를 삭제할 때, THE Database_Schema SHALL 관련된 PartNote들도 cascade 삭제한다

### Requirement 6

**User Story:** 개발자로서 데이터 무결성을 보장하고 싶으므로, 적절한 제약조건과 인덱스가 필요합니다.

#### Acceptance Criteria

1. WHEN 외래키 관계를 설정할 때, THE Database_Schema SHALL NOT NULL 제약조건을 필수 관계 필드에 적용한다
2. WHEN 고유성을 보장할 때, THE Database_Schema SHALL Part별 MainCounter 유일성 제약조건을 설정한다
3. WHEN 성능을 최적화할 때, THE Database_Schema SHALL 자주 조회되는 필드(project_id, part_id, session_id)에 인덱스를 생성한다
4. WHEN enum 값을 검증할 때, THE Database_Schema SHALL 유효한 enum 값만 허용하는 제약조건을 설정한다
5. WHEN 시간 데이터를 저장할 때, THE Database_Schema SHALL DateTime 필드에 적절한 기본값과 제약조건을 설정한다

### Requirement 7

**User Story:** 사용자로서 프로젝트를 유연하게 분류하고 싶으므로, 태그 시스템이 필요합니다.

#### Acceptance Criteria

1. WHEN Tags 테이블을 생성할 때, THE Database_Schema SHALL 태그 이름, 색상 코드, 생성일시 필드를 포함한다
2. WHEN 태그 이름의 고유성을 보장할 때, THE Database_Schema SHALL name 필드에 UNIQUE 제약조건을 설정한다
3. WHEN 태그 색상을 저장할 때, THE Database_Schema SHALL 정수형 color 필드를 제공한다 (Flutter Color 값 저장)
4. WHEN ProjectTags 테이블을 생성할 때, THE Database_Schema SHALL project_id와 tag_id를 복합 기본키로 설정한다
5. WHEN 프로젝트와 태그 관계를 정의할 때, THE Database_Schema SHALL 다대다(N:M) 관계를 ProjectTags 테이블로 구현한다
6. WHEN 태그를 삭제할 때, THE Database_Schema SHALL 관련된 ProjectTags 레코드도 cascade 삭제한다
7. WHEN 프로젝트를 삭제할 때, THE Database_Schema SHALL 관련된 ProjectTags 레코드도 cascade 삭제한다
8. WHEN 태그 검색을 위한 인덱스를 생성할 때, THE Database_Schema SHALL name 필드에 인덱스를 생성한다

### Requirement 8

**User Story:** 사용자로서 프로젝트에 이미지를 설정하고 싶으므로, 프로젝트 이미지 저장 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN Projects 테이블을 수정할 때, THE Database_Schema SHALL image_path 필드를 추가한다
2. WHEN 이미지 경로를 저장할 때, THE Database_Schema SHALL 상대 경로 문자열을 nullable로 저장한다 (예: 'project_images/1.jpg')
3. WHEN category 필드를 제거할 때, THE Database_Schema SHALL 기존 category 필드를 삭제하고 태그 시스템으로 대체한다
4. WHEN 프로젝트를 삭제할 때, THE Database_Schema SHALL 이미지 파일 삭제는 애플리케이션 레벨에서 처리한다