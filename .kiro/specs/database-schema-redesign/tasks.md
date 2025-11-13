# Implementation Plan

- [ ] 1. 데이터베이스 스키마 정의 및 기본 구조 설정
  - Drift 테이블 클래스 정의 (Parts, MainCounters, StitchCounters, SectionCounters, SectionRuns, Sessions, SessionSegments, PartNotes, Tags)
  - Projects 테이블에 currentPartId, imagePath, tagIds 필드 추가, category 필드 제거
  - 모든 테이블에 외래키 관계 및 cascade 삭제 설정
  - enum 타입 정의 (LinkState, SessionStatus, SegmentReason, RunState)
  - _Requirements: 1.1, 1.2, 1.3, 2.1, 2.2, 2.3, 3.1, 3.2, 5.1, 5.2, 7.1, 7.2, 7.3, 8.1, 8.2_

- [ ] 2. 인덱스 및 제약조건 설정
  - 자주 조회되는 필드에 인덱스 추가 (project_id, part_id, session_id 등)
  - 고유성 제약조건 설정 (Tags.name UNIQUE)
  - NOT NULL 제약조건 적용
  - 복합 인덱스 생성 (parts_project_order, section_runs_counter_ord 등)
  - _Requirements: 5.3, 6.1, 6.2, 6.3, 6.4, 6.5, 7.2, 7.7_

- [ ] 3. 마이그레이션 전략 구현
  - schemaVersion을 2로 업데이트
  - onUpgrade에서 기존 테이블 삭제 (work_sessions, project_counters)
  - 새 테이블 생성 로직 구현
  - Projects 테이블 컬럼 추가/삭제 처리
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 8.3_

- [ ] 4. 코드 생성 및 빌드
  - build_runner로 .g.dart 파일 생성
  - 생성된 코드 검증 및 컴파일 오류 수정
  - _Requirements: 4.4_

- [ ] 5. Part 관련 데이터베이스 작업 구현
- [ ] 5.1 Part CRUD 작업 구현
  - createPart 메서드 (MainCounter 자동 생성 포함)
  - getPart, getProjectParts 조회 메서드
  - updatePart, deletePart 메서드
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.6_

- [ ] 5.2 Part 순서 관리 구현
  - reorderParts 메서드 (orderIndex 업데이트)
  - Part 순서대로 조회하는 쿼리
  - _Requirements: 1.4_

- [ ] 5.3 BuddyCounter 순서 관리 구현
  - getPartBuddyCounters 메서드 (순서대로 조회)
  - reorderBuddyCounters 메서드 (JSON 업데이트)
  - _Requirements: 1.5, 2.4, 2.5_

- [ ] 6. Counter 관련 데이터베이스 작업 구현
- [ ] 6.1 MainCounter 작업 구현
  - getMainCounter 조회 메서드
  - updateMainCounter 메서드 (currentValue 증감)
  - _Requirements: 2.1_

- [ ] 6.2 StitchCounter 작업 구현
  - createStitchCounter 메서드 (순서 리스트 업데이트 포함)
  - updateStitchCounter 메서드 (currentValue, countBy 수정)
  - deleteStitchCounter 메서드 (순서 리스트 업데이트 포함)
  - _Requirements: 2.2, 2.6_

- [ ] 6.3 SectionCounter 작업 구현
  - createSectionCounter 메서드 (SectionRuns 전개 포함)
  - updateSectionCounter 메서드 (spec 수정)
  - deleteSectionCounter 메서드 (순서 리스트 업데이트 포함)
  - unlinkSectionCounter, relinkSectionCounter 메서드
  - _Requirements: 2.3, 2.4, 2.6_

- [ ] 6.4 SectionRuns 전개 로직 구현
  - _expandSectionRuns 헬퍼 메서드
  - Section spec에 따라 runs 생성
  - _Requirements: 2.3_

- [ ] 7. Session 관련 데이터베이스 작업 구현
- [ ] 7.1 Session CRUD 작업 구현
  - getSession 조회 메서드 (Part당 1개)
  - startSession 메서드 (Session + 첫 Segment 생성)
  - pauseSession 메서드 (현재 Segment 종료, totalDuration 누적)
  - resumeSession 메서드 (새 Segment 시작)
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 7.2 SessionSegment 관리 구현
  - Segment 종료 시 duration 계산 및 저장
  - startCount, endCount 스냅샷 저장
  - reason enum 처리
  - _Requirements: 3.2, 3.5_

- [ ] 7.3 자정 교차 처리 구현
  - 자정을 넘어가면 Segment 자동 분할
  - midnight_split reason 설정
  - _Requirements: 3.5_

- [ ] 8. 통계 쿼리 구현
- [ ] 8.1 날짜별 통계 쿼리
  - getDailyWorkSeconds 메서드 (히트맵용)
  - SessionSegment 기반 집계
  - _Requirements: 3.4_

- [ ] 8.2 프로젝트별 통계 쿼리
  - getProjectTotalSeconds 메서드
  - Sessions.totalDurationSeconds 합산
  - _Requirements: 3.1, 3.4_

- [ ] 9. PartNote 관련 데이터베이스 작업 구현
  - createPartNote, updatePartNote, deletePartNote 메서드
  - getPartNotes 조회 (isPinned 우선 정렬)
  - _Requirements: 5.1, 5.2, 5.3, 5.4_

- [ ] 10. Tag 시스템 구현
- [ ] 10.1 Tag CRUD 작업 구현
  - createTag, updateTag, deleteTag 메서드
  - getAllTags, searchTags 조회 메서드
  - _Requirements: 7.1, 7.2, 7.3, 7.7_

- [ ] 10.2 Tag 삭제 시 프로젝트 정리
  - deleteTag에서 모든 프로젝트의 tagIds JSON 업데이트
  - _Requirements: 7.6_

- [ ] 10.3 프로젝트-태그 관계 관리
  - getProjectTags 메서드 (프로젝트의 태그 조회)
  - updateProjectTags 메서드 (tagIds JSON 업데이트)
  - getProjectsByTag, getProjectsByTags 메서드 (태그 필터링)
  - _Requirements: 7.4, 7.5_

- [ ] 11. 프로젝트 이미지 관리 구현
  - updateProjectImage 메서드 (imagePath 업데이트)
  - 이미지 파일 저장/삭제는 애플리케이션 레벨에서 처리
  - _Requirements: 8.1, 8.2, 8.4_

- [ ] 12. Dart 모델 클래스 구현
  - BuddyCounterData sealed class (StitchCounterData, SectionCounterData)
  - SessionViewModel 클래스
  - SectionCounterData의 calculateProgress, calculateProgressPercent 헬퍼 메서드
  - _Requirements: 2.1, 2.2, 2.3, 3.1_

- [ ] 13. 에러 처리 구현
  - SqliteException 처리 (외래키 제약 위반 등)
  - 애플리케이션 레벨 검증 (Part당 MainCounter 1개, 활성 세션 1개)
  - 커스텀 DatabaseException 정의
  - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [ ]* 14. 단위 테스트 작성
- [ ]* 14.1 Part 테스트
  - Part 생성 시 MainCounter 자동 생성 검증
  - Part 삭제 시 cascade 삭제 검증
  - Part 순서 관리 테스트
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.6_

- [ ]* 14.2 Counter 테스트
  - MainCounter, StitchCounter, SectionCounter CRUD 테스트
  - BuddyCounter 순서 관리 테스트
  - SectionCounter 링크/언링크 테스트
  - SectionRuns 전개 테스트
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6_

- [ ]* 14.3 Session 테스트
  - Session 시작/일시정지/재시작 테스트
  - SessionSegment 자동 생성 검증
  - totalDuration 누적 계산 검증
  - _Requirements: 3.1, 3.2, 3.3_

- [ ]* 14.4 통계 쿼리 테스트
  - 날짜별 작업 시간 집계 테스트
  - 프로젝트별 총 시간 계산 테스트
  - _Requirements: 3.4_

- [ ]* 14.5 Tag 시스템 테스트
  - Tag CRUD 테스트
  - Tag 삭제 시 프로젝트 정리 검증
  - 프로젝트-태그 관계 테스트
  - 태그 필터링 테스트
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7_

- [ ]* 14.6 통합 테스트
  - 전체 작업 플로우 테스트 (프로젝트 생성 → Part 생성 → Counter 추가 → 세션 시작 → 일시정지)
  - 복잡한 시나리오 테스트 (여러 Part, 여러 Counter, 여러 Segment)
  - _Requirements: 모든 요구사항_
