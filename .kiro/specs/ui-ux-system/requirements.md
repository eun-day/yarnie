# Requirements Document

## Introduction

새로운 Part/Counter/Session 시스템을 기반으로 전체 앱의 UI/UX를 재설계합니다. 홈/프로젝트/마이 3개 탭 구조를 유지하면서, Part 기반 작업 플로우와 직관적인 사용자 경험을 제공합니다. Figma Make를 활용한 UI 생성을 위해 구체적인 화면 명세와 상호작용을 정의합니다.

## Glossary

- **Home_Screen**: 최근 작업 프로젝트와 통계를 보여주는 메인 화면
- **Projects_Screen**: 프로젝트 목록을 표시하는 화면
- **Project_Detail_Screen**: 선택된 프로젝트의 Part들과 Counter/Session 데이터를 관리하는 화면
- **My_Screen**: 사용자 설정, 프로필, 도움말을 제공하는 화면
- **Part_Tab_Navigation**: 프로젝트 상세 화면 상단의 Part 선택 탭
- **Counter_Panel**: 선택된 Part의 MainCounter와 BuddyCounter들을 표시하는 영역
- **Session_Panel**: 현재 Part의 세션 상태와 타이머를 표시하는 영역
- **Quick_Action**: 홈 화면에서 최근 작업으로 빠르게 이동할 수 있는 버튼

## Requirements

### Requirement 1

**User Story:** 사용자로서 홈 화면에서 데이터 양에 관계없이 유용한 콘텐츠를 보고 싶으므로, 적응형 홈 화면이 필요합니다.

#### Acceptance Criteria

1. WHEN 사용자에게 충분한 데이터가 있을 때, THE UI_System SHALL 최근 작업 프로젝트 카드, 통계 위젯, 빠른 액션 버튼을 표시한다
2. WHEN 사용자가 신규이거나 데이터가 적을 때, THE UI_System SHALL "새 프로젝트 시작하기" 큰 버튼, 온보딩 카드, 뜨개질 팁, 격려 메시지를 표시한다
3. WHEN 최근 작업 프로젝트가 있을 때, THE UI_System SHALL 프로젝트 이름, 마지막 작업 Part, 마지막 작업 시간을 포함한 카드를 표시한다
4. WHEN 최근 작업 카드를 탭할 때, THE UI_System SHALL 해당 프로젝트의 마지막 작업 Part로 직접 이동한다
5. WHEN 일시정지된 세션이 있을 때, THE UI_System SHALL "이어하기" 버튼과 함께 해당 세션 정보를 상단에 표시한다
6. WHEN 신규 사용자일 때, THE UI_System SHALL "처음 사용하시나요?" 온보딩 카드를 표시한다
7. WHEN 오늘 뜨개질을 하지 않았을 때, THE UI_System SHALL "오늘도 뜨개질해볼까요?" 격려 메시지를 표시한다

### Requirement 2

**User Story:** 사용자로서 홈 화면에서 나의 뜨개질 통계를 한눈에 보고 싶으므로, 통계 데이터 표시 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 홈 화면이 표시될 때, THE UI_System SHALL 완료된 프로젝트 수, 이번 달 뜨개질한 날 수, 주간 뜨개질 패턴을 표시한다
2. WHEN 통계 데이터를 표시할 때, THE UI_System SHALL 시각적으로 구분되는 카드나 위젯 형태로 배치한다
3. WHEN 홈 화면에 히트맵을 표시할 때, THE UI_System SHALL 최근 30일간의 일별 뜨개질 시간을 색상 강도로 표현한다
4. WHEN 히트맵을 렌더링할 때, THE UI_System SHALL 7x5 그리드 형태로 배치하고 각 셀에 해당 날짜의 작업 시간에 따른 색상을 적용한다
5. WHEN 히트맵 셀을 탭할 때, THE UI_System SHALL 해당 날짜의 상세 작업 기록을 툴팁이나 바텀시트로 표시한다
6. WHEN 작업 시간이 없는 날일 때, THE UI_System SHALL 연한 회색으로 표시한다
7. WHEN 작업 시간이 많을수록, THE UI_System SHALL 더 진한 색상(예: 연한 초록 → 진한 초록)으로 표시한다
8. WHEN 통계 카드를 탭할 때, THE UI_System SHALL 상세 통계 화면으로 이동한다 (추후 구현)
9. WHEN 데이터가 없을 때, THE UI_System SHALL "아직 작업 기록이 없습니다" 메시지를 표시한다
10. WHEN 통계를 계산할 때, THE UI_System SHALL 모든 프로젝트의 완료된 세션 데이터를 집계한다

### Requirement 3

**User Story:** 사용자로서 프로젝트 목록에서 각 프로젝트의 진행 상황을 빠르게 파악하고 싶으므로, 프로젝트 목록 개선이 필요합니다.

#### Acceptance Criteria

1. WHEN 프로젝트 목록이 표시될 때, THE UI_System SHALL 각 프로젝트 카드에 이름, 카테고리, 생성일, 마지막 작업일을 표시한다
2. WHEN 프로젝트에 활성 세션이 있을 때, THE UI_System SHALL 해당 프로젝트 카드에 "작업 중" 배지를 표시한다
3. WHEN 프로젝트 카드를 탭할 때, THE UI_System SHALL 해당 프로젝트의 상세 화면으로 이동한다
4. WHEN 프로젝트 목록이 비어있을 때, THE UI_System SHALL 빈 상태 일러스트와 "프로젝트 만들기" 버튼을 표시한다
5. WHEN 프로젝트를 길게 누를 때, THE UI_System SHALL 편집/삭제 컨텍스트 메뉴를 표시한다

### Requirement 4

**User Story:** 사용자로서 프로젝트 상세 화면에서 Part들을 쉽게 전환하면서 작업하고 싶으므로, Part 탭 네비게이션이 필요합니다.

#### Acceptance Criteria

1. WHEN 프로젝트 상세 화면이 표시될 때, THE UI_System SHALL 상단에 해당 프로젝트의 모든 Part를 탭 형태로 표시한다
2. WHEN Part 탭을 표시할 때, THE UI_System SHALL 각 Part의 이름과 현재 MainCounter 값을 포함한다
3. WHEN Part 탭을 선택할 때, THE UI_System SHALL 해당 Part의 Counter와 Session 데이터를 하단에 표시한다
4. WHEN 활성 세션이 있는 Part일 때, THE UI_System SHALL 해당 탭에 타이머 아이콘이나 진행 표시를 추가한다
5. WHEN Part가 1개뿐일 때, THE UI_System SHALL 탭 네비게이션을 숨기고 Part 이름만 표시한다
6. WHEN "+" 버튼을 탭할 때, THE UI_System SHALL 새 Part 생성 다이얼로그를 표시한다
7. WHEN 프로젝트 상세 화면 상단에 메뉴 버튼(⋮)을 표시할 때, THE UI_System SHALL 앱바 우상단에 배치한다
8. WHEN 메뉴 버튼을 탭할 때, THE UI_System SHALL 프로젝트 정보 보기/편집 옵션을 포함한 드롭다운 메뉴를 표시한다

### Requirement 5

**User Story:** 사용자로서 선택된 Part의 Counter들을 직관적으로 조작하고 싶으므로, Counter 패널 UI가 필요합니다.

#### Acceptance Criteria

1. WHEN Counter 패널이 표시될 때, THE UI_System SHALL 2열 그리드 시스템을 기반으로 레이아웃을 구성한다
2. WHEN MainCounter를 표시할 때, THE UI_System SHALL 2x1 크기(전체 너비)로 배치하고 현재 값, +/- 버튼을 포함한다
3. WHEN BuddyCounter들이 있을 때, THE UI_System SHALL MainCounter 아래에 1x1 크기로 2열 구조로 배치한다
4. WHEN Stitch Counter를 표시할 때, THE UI_System SHALL 이름, 현재 값, +/- 버튼을 포함한다
5. WHEN Section Counter를 표시할 때, THE UI_System SHALL 이름, 진행률, 링크 상태 배지를 포함한다
6. WHEN Section Counter가 unlinked 상태일 때, THE UI_System SHALL "연결 해제됨" 배지를 표시한다
7. WHEN "버디 카운터 추가" 버튼을 탭할 때, THE UI_System SHALL Stitch/Section 선택 다이얼로그를 표시한다
8. WHEN BuddyCounter가 홀수 개일 때, THE UI_System SHALL 마지막 카운터를 왼쪽에 배치하고 오른쪽은 빈 공간으로 둔다
9. WHEN BuddyCounter가 많아질 때, THE UI_System SHALL 2열 그리드를 유지하면서 세로로 스크롤 가능하도록 배치한다
10. WHEN BuddyCounter를 길게 누를 때, THE UI_System SHALL 드래그 모드로 전환하고 카운터에 시각적 피드백(그림자, 확대 등)을 제공한다
11. WHEN 드래그 모드에서 BuddyCounter를 이동할 때, THE UI_System SHALL 다른 카운터들의 위치를 실시간으로 재배치한다
12. WHEN BuddyCounter 순서 변경이 완료될 때, THE UI_System SHALL 새로운 순서를 데이터베이스에 저장한다
13. WHEN 드래그 중일 때, THE UI_System SHALL 드롭 가능한 위치에 시각적 가이드(점선 테두리 등)를 표시한다

### Requirement 6

**User Story:** 사용자로서 현재 Part의 세션 상태를 명확히 파악하고 제어하고 싶으므로, Session 패널 UI가 필요합니다.

#### Acceptance Criteria

1. WHEN Session 패널이 표시될 때, THE UI_System SHALL Part 탭 바로 아래에 띠배너 형태로 배치하고 현재 세션의 상태(running/paused/stopped)를 명확히 표시한다
2. WHEN 세션이 running 상태일 때, THE UI_System SHALL 실시간 타이머와 일시정지 버튼을 표시한다
3. WHEN 세션이 paused 상태일 때, THE UI_System SHALL 누적 시간과 재시작/종료 버튼을 표시한다
4. WHEN 세션이 없을 때, THE UI_System SHALL "작업 시작" 버튼을 표시한다
5. WHEN 백그라운드에서 세션이 진행 중일 때, THE UI_System SHALL 알림 표시와 함께 현재 시간을 업데이트한다
6. WHEN 세션 종료 버튼을 탭할 때, THE UI_System SHALL 세션 완료 다이얼로그를 표시한다

### Requirement 7

**User Story:** 사용자로서 Section Counter를 생성할 때 직관적인 설정 과정을 원하므로, Section Counter 생성 플로우가 필요합니다.

#### Acceptance Criteria

1. WHEN Section Counter 생성을 시작할 때, THE UI_System SHALL 5가지 상위 유형(Range, Repeat, Interval, Shaping, Length)을 카드 형태로 표시한다
2. WHEN 상위 유형을 선택할 때, THE UI_System SHALL 해당 유형의 하위 옵션들을 목록으로 표시한다
3. WHEN 하위 옵션을 선택할 때, THE UI_System SHALL 해당 옵션에 맞는 설정 폼을 표시한다
4. WHEN Length Type을 선택할 때, THE UI_System SHALL 프로젝트 게이지 정보가 있으면 자동으로 채우고, 없으면 입력 필드를 표시한다
5. WHEN 설정을 완료할 때, THE UI_System SHALL 미리보기와 함께 확인 버튼을 표시한다
6. WHEN 뒤로가기를 할 때, THE UI_System SHALL 입력된 데이터 손실 경고를 표시한다

### Requirement 8

**User Story:** 사용자로서 마이 화면에서 앱 설정과 개인 정보를 관리하고 싶으므로, 마이 화면 구성이 필요합니다.

#### Acceptance Criteria

1. WHEN 마이 화면이 표시될 때, THE UI_System SHALL 프로필 영역, 설정 메뉴, 도움말 섹션을 구분하여 표시한다
2. WHEN 프로필 영역을 표시할 때, THE UI_System SHALL 사용자 아바타(선택사항), 총 작업 시간, 완료 프로젝트 수를 포함한다
3. WHEN 설정 메뉴를 표시할 때, THE UI_System SHALL 알림 설정, 백그라운드 타이머 설정, 테마 설정을 포함한다
4. WHEN 도움말 섹션을 표시할 때, THE UI_System SHALL 사용법 가이드, 문의하기, 앱 정보를 포함한다
5. WHEN 설정 항목을 탭할 때, THE UI_System SHALL 해당 설정의 상세 화면이나 토글을 표시한다

### Requirement 9

**User Story:** 사용자로서 모든 화면에서 일관된 디자인과 네비게이션을 경험하고 싶으므로, 전체 UI 시스템 일관성이 필요합니다.

#### Acceptance Criteria

1. WHEN 모든 화면이 표시될 때, THE UI_System SHALL Material Design 3 기반의 일관된 색상과 타이포그래피를 사용한다
2. WHEN 네비게이션이 발생할 때, THE UI_System SHALL 부드러운 전환 애니메이션을 제공한다
3. WHEN 로딩 상태일 때, THE UI_System SHALL 일관된 로딩 인디케이터를 표시한다
4. WHEN 에러가 발생할 때, THE UI_System SHALL 사용자 친화적인 에러 메시지와 재시도 옵션을 제공한다
5. WHEN 다이얼로그나 바텀시트를 표시할 때, THE UI_System SHALL 플랫폼별 네이티브 스타일을 적용한다
6. WHEN 접근성이 필요할 때, THE UI_System SHALL 적절한 시맨틱 라벨과 포커스 관리를 제공한다

### Requirement 10

**User Story:** 사용자로서 나의 뜨개질 활동 패턴을 시각적으로 파악하고 싶으므로, 30일 히트맵 기능이 필요합니다.

#### Acceptance Criteria

1. WHEN 히트맵을 표시할 때, THE UI_System SHALL 오늘부터 역순으로 30일간의 데이터를 7x5 그리드로 배치한다
2. WHEN 각 날짜 셀을 렌더링할 때, THE UI_System SHALL 해당 날짜의 총 작업 시간(분)을 기준으로 색상 강도를 계산한다
3. WHEN 색상 강도를 적용할 때, THE UI_System SHALL 0분(투명), 1-30분(연한 초록), 31-60분(중간 초록), 61-120분(진한 초록), 121분 이상(가장 진한 초록) 단계를 사용한다
4. WHEN 히트맵 하단에, THE UI_System SHALL "Less" - 색상 범례 - "More" 형태의 범례를 표시한다
5. WHEN 날짜 셀을 탭할 때, THE UI_System SHALL 해당 날짜의 작업한 프로젝트 목록과 시간을 바텀시트로 표시한다
6. WHEN 오늘 날짜 셀일 때, THE UI_System SHALL 테두리나 다른 시각적 표시로 구분한다
7. WHEN 미래 날짜일 때, THE UI_System SHALL 셀을 표시하지 않거나 비활성화 상태로 표시한다
8. WHEN 히트맵 데이터를 계산할 때, THE UI_System SHALL SessionSegment의 duration을 날짜별로 집계한다
9. WHEN 주간 패턴을 표시할 때, THE UI_System SHALL 월요일부터 일요일까지 각 요일의 뜨개질 활동 여부를 도트나 아이콘으로 표시한다
10. WHEN 주간 패턴을 계산할 때, THE UI_System SHALL 해당 요일에 완료된 세션이 있으면 활성 상태로, 없으면 비활성 상태로 표시한다
11. WHEN 이번 달 뜨개질 날 수를 표시할 때, THE UI_System SHALL "이번 달 N일 뜨개질했어요" 형태의 격려 메시지로 표현한다

### Requirement 11

**User Story:** 사용자로서 홈 화면에서 뜨개질과 관련된 유용한 도구와 정보를 빠르게 접근하고 싶으므로, 실용적 기능 위젯이 필요합니다.

#### Acceptance Criteria

1. WHEN 홈 화면에 도구 섹션을 표시할 때, THE UI_System SHALL 게이지 계산기, 바늘 크기 변환표 등의 빠른 접근 버튼을 제공한다
2. WHEN 뜨개질 팁을 표시할 때, THE UI_System SHALL 랜덤하게 선택된 유용한 팁을 카드 형태로 보여준다
3. WHEN 계절별 추천을 표시할 때, THE UI_System SHALL 현재 계절에 맞는 뜨개질 아이템을 제안한다
4. WHEN 성취 배지를 표시할 때, THE UI_System SHALL 첫 프로젝트 생성, 첫 완성 등의 마일스톤을 시각적으로 표현한다
5. WHEN 최근 메모가 있을 때, THE UI_System SHALL Part 메모 중 가장 최근 것을 미리보기로 표시한다
6. WHEN 빠른 타이머 버튼을 탭할 때, THE UI_System SHALL 프로젝트 선택 없이 간단한 뜨개질 타이머를 시작한다

### Requirement 12

**User Story:** 사용자로서 프로젝트를 생성하거나 편집하고 싶으므로, 프로젝트 정보 입력/수정 화면이 필요합니다.

#### Acceptance Criteria

1. WHEN 프로젝트 생성 화면이 표시될 때, THE UI_System SHALL 빈 입력 폼과 "프로젝트 만들기" 제목을 표시한다
2. WHEN 프로젝트 편집 화면이 표시될 때, THE UI_System SHALL 기존 데이터가 채워진 폼과 "프로젝트 정보" 제목을 표시한다
3. WHEN 입력 폼을 표시할 때, THE UI_System SHALL 프로젝트 이름(필수), 카테고리, 바늘 종류/크기, 로트 번호, 메모 필드를 포함한다
4. WHEN 프로젝트 이름이 비어있을 때, THE UI_System SHALL 저장 버튼을 비활성화하고 유효성 메시지를 표시한다
5. WHEN 저장 버튼을 탭할 때, THE UI_System SHALL 데이터 저장 후 성공 메시지를 표시하고 이전 화면으로 돌아간다
6. WHEN 편집 모드에서 삭제 옵션을 제공할 때, THE UI_System SHALL 위험 색상과 확인 다이얼로그를 포함한다
7. WHEN 게이지 정보 입력 섹션을 표시할 때, THE UI_System SHALL 선택적 입력으로 구성하고 단위 선택을 포함한다

### Requirement 13

**User Story:** 개발자로서 Figma Make를 통해 정확한 UI를 생성하고 싶으므로, 구체적인 레이아웃 명세가 필요합니다.

#### Acceptance Criteria

1. WHEN UI 컴포넌트를 정의할 때, THE UI_System SHALL 정확한 크기, 간격, 색상 값을 명시한다
2. WHEN 레이아웃을 구성할 때, THE UI_System SHALL Grid 시스템과 반응형 규칙을 적용한다
3. WHEN 상호작용을 정의할 때, THE UI_System SHALL 터치 영역, 애니메이션, 피드백을 구체적으로 명시한다
4. WHEN 상태 변화를 표현할 때, THE UI_System SHALL 각 상태별 시각적 차이점을 명확히 정의한다
5. WHEN 플랫폼별 차이가 있을 때, THE UI_System SHALL iOS/Android 각각의 네이티브 패턴을 반영한다