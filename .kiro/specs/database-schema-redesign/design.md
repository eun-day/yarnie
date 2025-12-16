# Database Schema Redesign - Design Document

## Overview

Yarnie 앱의 데이터베이스를 기존 Session/Counter 중심 구조에서 Part 기반 구조로 전면 재설계합니다. Drift ORM을 사용하여 타입 안전한 SQLite 스키마를 구현하며, Part를 중심으로 MainCounter, BuddyCounter, Session, SessionSegment가 계층적으로 연결됩니다.

## Architecture

### 데이터 모델 계층 구조

```
Project
  ├─ current_part_id (FK)
  └─ Parts (1:N)
       ├─ MainCounter (1:1)
       ├─ BuddyCounters (1:N)
       ├─ Session (1:1, 활성 세션)
       │    └─ SessionSegments (1:N)
       └─ PartNotes (1:N)
```

### 핵심 설계 원칙

1. **Part 중심 설계**: 모든 작업 데이터는 Part에 종속
2. **타입 안전성**: Drift의 타입 시스템 활용
3. **데이터 무결성**: 외래키와 cascade 삭제로 일관성 보장
4. **성능 최적화**: 자주 조회되는 필드에 인덱스 설정
5. **확장 가능성**: Section Counter의 다양한 타입을 지원할 수 있는 구조

## Database Schema

### 1. Projects 테이블 (수정)

기존 테이블에 `current_part_id`, `image_path` 필드 추가, `category` 필드 삭제.

```dart
class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  
  // category 필드 삭제 (태그 시스템으로 대체)
  
  TextColumn get needleType => text().nullable()();
  TextColumn get needleSize => text().nullable()();
  TextColumn get lotNumber => text().nullable()();
  TextColumn get memo => text().nullable()();
  
  // 새로 추가
  IntColumn get currentPartId => integer().nullable()
      .references(Parts, #id, onDelete: KeyAction.setNull)();
  TextColumn get imagePath => text().nullable()(); // 프로젝트 이미지 경로
  TextColumn get tagIds => text().nullable()(); // 태그 ID 배열 (JSON: '[1,2,3]')
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**변경 사항:**
- `currentPartId`: 사용자가 마지막으로 작업한 Part를 추적 (nullable, Part 삭제 시 null로 설정)
- `imagePath`: 프로젝트 이미지 파일 경로 (예: 'project_images/1.jpg')
- `tagIds`: 프로젝트에 연결된 태그 ID 배열 (JSON: '[1,2,3]')
- `category` 삭제: 태그 시스템으로 대체하여 더 유연한 분류 지원

### 2. Parts 테이블 (신규)

프로젝트 내의 작업 구간을 나타냅니다.

```dart
class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()(); // Part 정렬 순서
  
  // BuddyCounter 순서 관리
  TextColumn get buddyCounterOrder => text().nullable()();
  // JSON: '[{"type":"stitch","id":1},{"type":"section","id":2},...]'
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(projectId, orderIndex)`: Part 목록 조회 최적화

**특징:**
- Part 삭제 시 관련 Counter, Session, Note 모두 cascade 삭제
- `orderIndex`로 Part 간 사용자 정의 순서 지원
- `buddyCounterOrder`로 BuddyCounter 드래그 앤 드롭 순서 관리

### 3. MainCounters 테이블 (신규)

각 Part의 중심 카운터를 관리합니다.

```dart
class MainCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**제약 조건:**
- Part당 MainCounter는 1개만 존재 (애플리케이션 레벨에서 보장)

**인덱스:**
- `(partId)`: Part별 MainCounter 조회

**특징:**
- Row 모드에서는 항상 +1씩 증가
- Free 모드 지원은 추후 개발 예정

### 4. StitchCounters 테이블 (신규)

독립적으로 조작 가능한 BuddyCounter입니다.

```dart
class StitchCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  TextColumn get name => text()(); // 사용자 정의 이름
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  IntColumn get countBy => integer().withDefault(const Constant(1))();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(partId)`: Part별 StitchCounter 조회

**특징:**
- MainCounter와 완전히 독립적으로 동작
- 사용자가 +/- 버튼으로 직접 조작
- `countBy` 설정으로 증감 단위 조절 가능

### 5. SectionCounters 테이블 (신규)

MainCounter와 연동되는 BuddyCounter입니다.

```dart
// 링크 상태 enum (Free 모드 추가 시 확장 가능)
enum LinkState {
  linked,   // MainCounter와 연동 중
  unlinked, // 연동 해제됨
  // 추후 Free 모드 추가 시: autoUnlinked (자동 언링크) 등 확장 가능
}

class SectionCounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  TextColumn get name => text()(); // 사용자 정의 이름
  TextColumn get specJson => text()(); // Section 유형별 설정 (JSON, schemaVer 포함)
  
  // 링크 관리 (enum으로 향후 확장성 확보)
  TextColumn get linkState => textEnum<LinkState>()
      .withDefault(const Constant('linked'))();
  IntColumn get frozenMainAt => integer().nullable()(); // 언링크 시 고정값
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(partId)`: Part별 SectionCounter 조회
- `(partId, linkState)`: 링크 상태별 조회

**특징:**
- `specJson`: Range, Repeat, Interval, Shaping, Length 등 유형별 설정 저장 (schemaVer 포함)
  ```json
  {
    "schemaVer": 1,
    "type": "range",
    "startRow": 10,
    "rowsTotal": 20,
    "label": "코 줄임 구간"
  }
  ```
- `linkState`: linked일 때만 MainCounter 값으로 자동 계산 (enum으로 Free 모드 등 향후 확장 대비)
- `frozenMainAt`: unlinked 시 고정 표시용 MainCounter 값
- 사용자가 직접 조작 불가, MainCounter 연동으로만 값 변경

### 6. SectionRuns 테이블 (신규)

SectionCounter의 구간을 전개한 캐시 테이블입니다.

```dart
enum RunState {
  scheduled, // 예정
  active,    // 진행 중
  completed, // 완료
  skipped,   // 건너뜀
}

class SectionRuns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sectionCounterId => integer()
      .references(SectionCounters, #id, onDelete: KeyAction.cascade)();
  
  IntColumn get ord => integer()(); // 순서
  IntColumn get startRow => integer()(); // 시작 행
  IntColumn get rowsTotal => integer()(); // 총 행수
  TextColumn get label => text().nullable()(); // 라벨 (예: "1회차", "색상 변경")
  
  TextColumn get state => textEnum<RunState>()
      .withDefault(const Constant('scheduled'))();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
```

**인덱스:**
- `(sectionCounterId, ord)`: Section별 순서대로 조회
- `(sectionCounterId, state)`: 상태별 조회

**특징:**
- SectionCounter 생성 시 자동으로 구간 전개
- MainCounter 값으로 현재 활성 run 계산
- 진행률 계산 최적화를 위한 캐시 테이블

### 7. Sessions 테이블 (신규)

Part별 작업 세션을 관리합니다.

```dart
enum SessionStatus {
  running,  // 진행 중
  paused,   // 일시정지
}

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  DateTimeColumn get startedAt => dateTime()();
  
  IntColumn get totalDurationSeconds => integer().withDefault(const Constant(0))();
  
  IntColumn get status => intEnum<SessionStatus>()
      .withDefault(Constant(SessionStatus.running.index))();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(partId)`: Part별 세션 조회 최적화
- `(startedAt)`: 시간순 정렬 최적화

**특징:**
- Part당 Session은 최대 1개 (첫 작업 시작 시 생성)
- Session이 없으면 = 아직 작업 시작 안 함
- `totalDurationSeconds`: 각 SessionSegment 종료 시마다 누적
- stopped 상태 제거: Part당 1개 세션 모델에서는 불필요
- 통계는 SessionSegment의 duration으로 계산

### 8. SessionSegments 테이블 (신규)

Session 내의 실제 작업 시간 구간을 기록합니다.

```dart
enum SegmentReason {
  pause,          // 일시정지
  resume,         // 재시작
  modeChange,     // Row/Free 모드 변경
  partChange,     // Part 전환
  midnightSplit,  // 자정 교차
}

class SessionSegments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer()
      .references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  
  // Counter 스냅샷
  IntColumn get startCount => integer().nullable()();
  IntColumn get endCount => integer().nullable()();
  
  // 분할 이유
  TextColumn get reason => textEnum<SegmentReason>().nullable()();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
```

**인덱스:**
- `(sessionId)`: Session별 Segment 조회
- `(partId, startedAt)`: Part별 시간순 조회
- `(startedAt)`: 날짜별 통계 계산

**특징:**
- 일시정지, 재시작, 모드 변경 등으로 Segment 분할
- 자정을 넘어가면 자동으로 분할 (날짜별 통계를 위해)
- `startCount`/`endCount`: 해당 Segment 동안의 Counter 변화 추적

### 9. PartNotes 테이블 (신규)

Part별 메모를 관리합니다.

```dart
class PartNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  TextColumn get content => text()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(partId, isPinned, createdAt)`: 고정 메모 우선 정렬

**특징:**
- `isPinned`: 상단 고정 메모 지원
- Part 삭제 시 메모도 함께 삭제

### 10. Tags 테이블 (신규)

사용자 정의 태그를 관리합니다.

```dart
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()(); // 태그 이름 (고유)
  IntColumn get color => integer()(); // Flutter Color 값 (0xFFRRGGBB)
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**제약 조건:**
- `name`: UNIQUE 제약으로 중복 태그 이름 방지

**인덱스:**
- `(name)`: 태그 이름 검색 최적화

**특징:**
- `color`: Flutter의 Color.value를 정수로 저장 (예: Colors.pink.value = 0xFFE91E63)
- 태그 삭제 시 ProjectTags의 관련 레코드도 cascade 삭제

### 11. 삭제할 테이블

- `WorkSessions`: Sessions + SessionSegments로 대체
- `ProjectCounters`: Counters로 대체

## Data Models

### Dart 모델 클래스

Drift가 자동 생성하는 클래스 외에 추가로 필요한 모델:

```dart
// BuddyCounter를 통합하여 UI에서 사용하기 쉽게 래핑
sealed class BuddyCounterData {
  int get id;
  int get partId;
  String get name;
}

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
}

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
  
  // UI 헬퍼
  bool get isLinked => linkState == LinkState.linked;
  
  // MainCounter 값으로 진행도 계산
  int calculateProgress(int mainCounterValue) {
    final baseValue = isLinked ? mainCounterValue : (frozenMainAt ?? 0);
    final startRow = spec['startRow'] as int? ?? 0;
    final rowsTotal = spec['rowsTotal'] as int? ?? 0;
    
    if (rowsTotal == 0) return 0;
    return (baseValue - startRow).clamp(0, rowsTotal);
  }
  
  double? calculateProgressPercent(int mainCounterValue) {
    final progress = calculateProgress(mainCounterValue);
    final rowsTotal = spec['rowsTotal'] as int? ?? 0;
    
    if (rowsTotal == 0) return null;
    return progress / rowsTotal;
  }
}

// Session 상태를 UI에서 표시하기 위한 모델
class SessionViewModel {
  final Session? session; // null이면 아직 시작 안 함
  final List<SessionSegment> segments;
  final Duration currentDuration;
  
  bool get notStarted => session == null;
  bool get isRunning => session?.status == SessionStatus.running;
  bool get isPaused => session?.status == SessionStatus.paused;
}
```

## Database Operations

### 주요 쿼리 패턴

#### 1. Part 관련

```dart
// Part 생성 (MainCounter 자동 생성)
Future<int> createPart({
  required int projectId,
  required String name,
  int? orderIndex,
}) async {
  return transaction(() async {
    // Part 생성
    final partId = await into(parts).insert(
      PartsCompanion.insert(
        projectId: projectId,
        name: name,
        orderIndex: orderIndex ?? 0,
        buddyCounterOrder: const Value(null), // 초기에는 빈 순서
      ),
    );
    
    // MainCounter 자동 생성
    await into(mainCounters).insert(
      MainCountersCompanion.insert(
        partId: partId,
        currentValue: const Value(0),
      ),
    );
    
    return partId;
  });
}

// MainCounter 조회
Future<MainCounter> getMainCounter(int partId) {
  return (select(mainCounters)
    ..where((t) => t.partId.equals(partId))
  ).getSingle();
}

// Part의 모든 BuddyCounter 조회 (순서대로)
Future<List<dynamic>> getPartBuddyCounters(int partId) async {
  // 1. Part의 순서 정보 가져오기
  final part = await (select(parts)
    ..where((t) => t.id.equals(partId))
  ).getSingle();
  
  if (part.buddyCounterOrder == null) {
    return [];
  }
  
  final orderList = jsonDecode(part.buddyCounterOrder!) as List;
  
  // 2. 각 테이블에서 카운터 조회
  final stitchCounters = await (select(stitchCounters)
    ..where((t) => t.partId.equals(partId))
  ).get();
  
  final sectionCounters = await (select(sectionCounters)
    ..where((t) => t.partId.equals(partId))
  ).get();
  
  // 3. 순서대로 정렬
  final result = <dynamic>[];
  for (final item in orderList) {
    final type = item['type'] as String;
    final id = item['id'] as int;
    
    if (type == 'stitch') {
      final counter = stitchCounters.firstWhere((c) => c.id == id);
      result.add(counter);
    } else if (type == 'section') {
      final counter = sectionCounters.firstWhere((c) => c.id == id);
      result.add(counter);
    }
  }
  
  return result;
}
```

#### 2. Counter 관련

```dart
// StitchCounter 생성 (UI에서 업데이트된 순서 리스트 받기)
Future<int> createStitchCounter({
  required int partId,
  required String name,
  required List<Map<String, dynamic>> newOrder,
  int countBy = 1,
}) async {
  return transaction(() async {
    // StitchCounter 생성
    final counterId = await into(stitchCounters).insert(
      StitchCountersCompanion.insert(
        partId: partId,
        name: name,
        countBy: Value(countBy),
      ),
    );
    
    // 새 순서 리스트 업데이트 (UI에서 이미 새 카운터 추가됨)
    await (update(parts)..where((t) => t.id.equals(partId))).write(
      PartsCompanion(
        buddyCounterOrder: Value(jsonEncode(newOrder)),
      ),
    );
    
    return counterId;
  });
}

// SectionCounter 생성 (UI에서 업데이트된 순서 리스트 받기)
Future<int> createSectionCounter({
  required int partId,
  required String name,
  required Map<String, dynamic> spec,
  required List<Map<String, dynamic>> newOrder,
}) async {
  return transaction(() async {
    // SectionCounter 생성
    final counterId = await into(sectionCounters).insert(
      SectionCountersCompanion.insert(
        partId: partId,
        name: name,
        specJson: jsonEncode(spec),
        linkState: const Value(LinkState.linked),
      ),
    );
    
    // SectionRuns 전개
    await _expandSectionRuns(counterId, spec);
    
    // 새 순서 리스트 업데이트 (UI에서 이미 새 카운터 추가됨)
    await (update(parts)..where((t) => t.id.equals(partId))).write(
      PartsCompanion(
        buddyCounterOrder: Value(jsonEncode(newOrder)),
      ),
    );
    
    return counterId;
  });
}

// BuddyCounter 순서 변경
Future<void> reorderBuddyCounters({
  required int partId,
  required List<Map<String, dynamic>> newOrder,
}) {
  return (update(parts)..where((t) => t.id.equals(partId))).write(
    PartsCompanion(
      buddyCounterOrder: Value(jsonEncode(newOrder)),
    ),
  );
}

// StitchCounter 삭제 (UI에서 업데이트된 순서 리스트 받기)
Future<void> deleteStitchCounter({
  required int counterId,
  required int partId,
  required List<Map<String, dynamic>> newOrder,
}) async {
  return transaction(() async {
    // 1. StitchCounter 삭제
    await (delete(stitchCounters)
      ..where((t) => t.id.equals(counterId))
    ).go();
    
    // 2. 새 순서 리스트 업데이트
    await (update(parts)..where((t) => t.id.equals(partId))).write(
      PartsCompanion(
        buddyCounterOrder: Value(jsonEncode(newOrder)),
      ),
    );
  });
}

// SectionCounter 삭제 (UI에서 업데이트된 순서 리스트 받기)
Future<void> deleteSectionCounter({
  required int counterId,
  required int partId,
  required List<Map<String, dynamic>> newOrder,
}) async {
  return transaction(() async {
    // 1. SectionCounter 삭제 (SectionRuns도 cascade 삭제됨)
    await (delete(sectionCounters)
      ..where((t) => t.id.equals(counterId))
    ).go();
    
    // 2. 새 순서 리스트 업데이트
    await (update(parts)..where((t) => t.id.equals(partId))).write(
      PartsCompanion(
        buddyCounterOrder: Value(jsonEncode(newOrder)),
      ),
    );
  });
}

// SectionCounter 링크/언링크 (UI에서 현재 MainCounter 값 받기)
Future<void> unlinkSectionCounter({
  required int counterId,
  required int currentMainValue,
}) {
  return (update(sectionCounters)..where((t) => t.id.equals(counterId))).write(
    SectionCountersCompanion(
      linkState: const Value(LinkState.unlinked),
      frozenMainAt: Value(currentMainValue),
    ),
  );
}

Future<void> relinkSectionCounter(int counterId) {
  return (update(sectionCounters)..where((t) => t.id.equals(counterId))).write(
    const SectionCountersCompanion(
      linkState: Value(LinkState.linked),
      frozenMainAt: Value(null),
    ),
  );
}
```

#### 3. Session 관련

```dart
// 세션 조회 (없으면 null = 아직 시작 안 함)
Future<Session?> getSession(int partId) {
  return (select(sessions)
    ..where((t) => t.partId.equals(partId))
    ..limit(1)
  ).getSingleOrNull();
}

// 세션 시작 (첫 작업 시작 시 Session 생성, UI에서 현재 MainCounter 값 받기)
Future<int> startSession({
  required int partId,
  required int currentMainValue,
}) async {
  return transaction(() async {
    // 기존 세션 확인
    final existing = await getSession(partId);
    if (existing != null) {
      throw StateError('이미 세션이 있습니다');
    }
    
    final now = DateTime.now();
    
    // Session 생성
    final sessionId = await into(sessions).insert(
      SessionsCompanion.insert(
        partId: partId,
        startedAt: now,
        status: Value(SessionStatus.running),
      ),
    );
    
    // 첫 번째 Segment 생성
    await into(sessionSegments).insert(
      SessionSegmentsCompanion.insert(
        sessionId: sessionId,
        partId: partId,
        startedAt: now,
        startCount: Value(currentMainValue),
        reason: Value(SegmentReason.resume),
      ),
    );
    
    return sessionId;
  });
}

// 세션 일시정지 (UI에서 현재 MainCounter 값과 Segment ID 받기)
Future<void> pauseSession({
  required int sessionId,
  required int currentSegmentId,
  required int currentMainValue,
  required DateTime segmentStartedAt,
}) async {
  return transaction(() async {
    final session = await (select(sessions)
      ..where((t) => t.id.equals(sessionId))
    ).getSingle();
    
    final now = DateTime.now();
    final duration = now.difference(segmentStartedAt).inSeconds;
    
    // 현재 Segment 종료
    await (update(sessionSegments)
      ..where((t) => t.id.equals(currentSegmentId))
    ).write(
      SessionSegmentsCompanion(
        endedAt: Value(now),
        durationSeconds: Value(duration),
        endCount: Value(currentMainValue),
        reason: Value(SegmentReason.pause),
      ),
    );
    
    // Session 상태 업데이트
    await (update(sessions)
      ..where((t) => t.id.equals(sessionId))
    ).write(
      SessionsCompanion(
        status: Value(SessionStatus.paused),
        totalDurationSeconds: Value(session.totalDurationSeconds + duration),
        updatedAt: Value(now),
      ),
    );
  });
}

// 세션 재시작 (UI에서 현재 MainCounter 값 받기)
Future<void> resumeSession({
  required int sessionId,
  required int partId,
  required int currentMainValue,
}) async {
  return transaction(() async {
    final now = DateTime.now();
    
    // Session 상태 업데이트
    await (update(sessions)
      ..where((t) => t.id.equals(sessionId))
    ).write(
      SessionsCompanion(
        status: Value(SessionStatus.running),
        updatedAt: Value(now),
      ),
    );
    
    // 새 Segment 시작
    await into(sessionSegments).insert(
      SessionSegmentsCompanion.insert(
        sessionId: sessionId,
        partId: partId,
        startedAt: now,
        startCount: Value(currentMainValue),
        reason: Value(SegmentReason.resume),
      ),
    );
  });
}
```

#### 4. 통계 쿼리

```dart
// 날짜별 작업 시간 집계 (히트맵용)
Future<Map<DateTime, int>> getDailyWorkSeconds({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final result = await customSelect(
    '''
    SELECT 
      DATE(started_at) as date,
      SUM(duration_seconds) as total_seconds
    FROM session_segments
    WHERE started_at >= ?1 AND started_at < ?2
      AND duration_seconds IS NOT NULL
    GROUP BY DATE(started_at)
    ORDER BY date
    ''',
    variables: [
      Variable.withDateTime(startDate),
      Variable.withDateTime(endDate),
    ],
    readsFrom: {sessionSegments},
  ).get();
  
  return {
    for (var row in result)
      DateTime.parse(row.data['date'] as String): 
        row.data['total_seconds'] as int,
  };
}

// 프로젝트별 총 작업 시간 (Sessions 기반)
Future<int> getProjectTotalSeconds(int projectId) async {
  final result = await customSelect(
    '''
    SELECT COALESCE(SUM(s.total_duration_seconds), 0) as total
    FROM sessions s
    JOIN parts p ON s.part_id = p.id
    WHERE p.project_id = ?1
    ''',
    variables: [Variable.withInt(projectId)],
    readsFrom: {sessions, parts},
  ).getSingle();
  
  return result.data['total'] as int;
}
```

#### 5. 태그 관련 쿼리

```dart
// 태그 생성
Future<int> createTag({
  required String name,
  required int color,
}) {
  return into(tags).insert(
    TagsCompanion.insert(
      name: name,
      color: color,
    ),
  );
}

// 태그 이름으로 검색
Future<List<Tag>> searchTags(String query) {
  return (select(tags)
    ..where((t) => t.name.like('%$query%'))
    ..orderBy([(t) => OrderingTerm.asc(t.name)])
  ).get();
}

// 모든 태그 조회 (이름순)
Future<List<Tag>> getAllTags() {
  return (select(tags)
    ..orderBy([(t) => OrderingTerm.asc(t.name)])
  ).get();
}

// 태그 수정
Future<void> updateTag({
  required int tagId,
  required String name,
  required int color,
}) {
  return (update(tags)..where((t) => t.id.equals(tagId))).write(
    TagsCompanion(
      name: Value(name),
      color: Value(color),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

// 태그 삭제 (모든 프로젝트에서 해당 태그 제거)
Future<void> deleteTag(int tagId) async {
  return transaction(() async {
    // 1. 태그 삭제
    await (delete(tags)..where((t) => t.id.equals(tagId))).go();
    
    // 2. 모든 프로젝트에서 해당 태그 ID 제거
    final projects = await (select(projects)
      ..where((t) => t.tagIds.isNotNull())
    ).get();
    
    for (final project in projects) {
      final tagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
      if (tagIds.contains(tagId)) {
        tagIds.remove(tagId);
        await (update(projects)..where((t) => t.id.equals(project.id))).write(
          ProjectsCompanion(
            tagIds: Value(jsonEncode(tagIds)),
          ),
        );
      }
    }
  });
}

// 프로젝트의 태그 조회
Future<List<Tag>> getProjectTags(int projectId) async {
  final project = await (select(projects)
    ..where((t) => t.id.equals(projectId))
  ).getSingle();
  
  if (project.tagIds == null) return [];
  
  final tagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
  if (tagIds.isEmpty) return [];
  
  return (select(tags)
    ..where((t) => t.id.isIn(tagIds))
  ).get();
}

// 프로젝트의 태그 업데이트
Future<void> updateProjectTags({
  required int projectId,
  required List<int> tagIds,
}) {
  return (update(projects)..where((t) => t.id.equals(projectId))).write(
    ProjectsCompanion(
      tagIds: Value(tagIds.isEmpty ? null : jsonEncode(tagIds)),
    ),
  );
}

// 태그별 프로젝트 조회 (단일 태그)
Future<List<Project>> getProjectsByTag(int tagId) {
  return (select(projects)
    ..where((t) => t.tagIds.like('%$tagId%'))
    ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
  ).get();
}

// 다중 태그 필터 (AND 조건)
Future<List<Project>> getProjectsByTags(List<int> tagIds) async {
  if (tagIds.isEmpty) {
    return (select(projects)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ).get();
  }
  
  // 모든 프로젝트 조회 후 필터링 (개인 앱 규모에서는 충분히 빠름)
  final allProjects = await (select(projects)
    ..where((t) => t.tagIds.isNotNull())
  ).get();
  
  return allProjects.where((project) {
    final projectTagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
    return tagIds.every((tagId) => projectTagIds.contains(tagId));
  }).toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
```

## Migration Strategy

### 개발 단계 마이그레이션

기존 데이터를 보존하지 않고 새로 시작합니다.

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    await m.createAll();
  },
  onUpgrade: (m, from, to) async {
    if (from == 1 && to == 2) {
      // 기존 테이블 삭제
      await m.deleteTable('work_sessions');
      await m.deleteTable('project_counters');
      
      // 새 테이블 생성
      await m.createTable(parts);
      await m.createTable(mainCounters);
      await m.createTable(stitchCounters);
      await m.createTable(sectionCounters);
      await m.createTable(sectionRuns);
      await m.createTable(sessions);
      await m.createTable(sessionSegments);
      await m.createTable(partNotes);
      await m.createTable(tags);
      
      // Projects 테이블 수정
      await m.addColumn(projects, projects.currentPartId);
      await m.addColumn(projects, projects.imagePath);
      await m.addColumn(projects, projects.tagIds);
      await m.dropColumn(projects, 'category');
    }
  },
);
```

### 프로덕션 마이그레이션 (추후)

실제 사용자 데이터가 있을 때는 마이그레이션 로직 필요:

1. 기존 Project → 기본 Part 생성 ("전체" 또는 프로젝트 이름)
2. ProjectCounters → Counters (MainCounter + BuddyCounter)
3. WorkSessions → Sessions + SessionSegments
4. label → Part 매핑

## Error Handling

### 제약 조건 위반 처리

```dart
try {
  await createPart(projectId: 1, name: 'Test');
} on SqliteException catch (e) {
  if (e.extendedResultCode == 787) { // SQLITE_CONSTRAINT_FOREIGNKEY
    throw DatabaseException('존재하지 않는 프로젝트입니다');
  }
  rethrow;
}
```

### 애플리케이션 레벨 검증

```dart
// Part당 MainCounter 1개 보장
Future<void> ensureSingleMainCounter(int partId) async {
  final mainCounters = await (select(counters)
    ..where((t) => t.partId.equals(partId) & t.isMain.equals(true))
  ).get();
  
  if (mainCounters.length > 1) {
    throw StateError('Part에 MainCounter가 여러 개 있습니다');
  }
}

// Part당 활성 세션 1개 보장
Future<void> ensureSingleActiveSession(int partId) async {
  final activeSessions = await (select(sessions)
    ..where((t) => 
      t.partId.equals(partId) &
      t.status.isIn([
        SessionStatus.running.index,
        SessionStatus.paused.index,
      ])
    )
  ).get();
  
  if (activeSessions.length > 1) {
    throw StateError('Part에 활성 세션이 여러 개 있습니다');
  }
}
```

## Testing Strategy

### 단위 테스트

```dart
void main() {
  late AppDb db;
  
  setUp(() async {
    db = AppDb.forTesting(
      DatabaseConnection(
        NativeDatabase.memory(),
      ),
    );
  });
  
  tearDown(() async {
    await db.close();
  });
  
  group('Parts', () {
    test('Part 생성 시 MainCounter 자동 생성', () async {
      // Given
      final projectId = await db.createProject(name: 'Test Project');
      
      // When
      final partId = await db.createPart(
        projectId: projectId,
        name: 'Body',
      );
      
      // Then
      final mainCounter = await db.getMainCounter(partId);
      expect(mainCounter.isMain, true);
      expect(mainCounter.currentValue, 0);
    });
    
    test('Part 삭제 시 Counter도 삭제', () async {
      // Given
      final projectId = await db.createProject(name: 'Test Project');
      final partId = await db.createPart(
        projectId: projectId,
        name: 'Body',
      );
      
      // When
      await (db.delete(db.parts)
        ..where((t) => t.id.equals(partId))
      ).go();
      
      // Then
      final counters = await db.getPartCounters(partId);
      expect(counters, isEmpty);
    });
  });
  
  group('Sessions', () {
    test('세션 시작 시 Segment 자동 생성', () async {
      // Given
      final projectId = await db.createProject(name: 'Test Project');
      final partId = await db.createPart(
        projectId: projectId,
        name: 'Body',
      );
      
      // When
      final sessionId = await db.startSession(partId: partId);
      
      // Then
      final segments = await (db.select(db.sessionSegments)
        ..where((t) => t.sessionId.equals(sessionId))
      ).get();
      expect(segments.length, 1);
      expect(segments.first.reason, SegmentReason.resume);
    });
  });
}
```

### 통합 테스트

```dart
test('전체 작업 플로우', () async {
  // 1. 프로젝트 생성
  final projectId = await db.createProject(name: 'Sweater');
  
  // 2. Part 생성
  final bodyPartId = await db.createPart(
    projectId: projectId,
    name: 'Body',
  );
  
  // 3. BuddyCounter 추가
  await db.into(db.counters).insert(
    CountersCompanion.insert(
      partId: bodyPartId,
      isMain: false,
      buddyType: Value(BuddyType.stitch),
      name: Value('Stitch Count'),
      orderIndex: Value(0),
    ),
  );
  
  // 4. 세션 시작
  final sessionId = await db.startSession(partId: bodyPartId);
  
  // 5. Counter 증가
  final mainCounter = await db.getMainCounter(bodyPartId);
  await (db.update(db.counters)
    ..where((t) => t.id.equals(mainCounter.id))
  ).write(
    CountersCompanion(
      currentValue: Value(mainCounter.currentValue + 1),
    ),
  );
  
  // 6. 세션 일시정지
  await db.pauseSession(sessionId: sessionId);
  
  // 7. 검증
  final session = await (db.select(db.sessions)
    ..where((t) => t.id.equals(sessionId))
  ).getSingle();
  expect(session.status, SessionStatus.paused);
  expect(session.totalDurationSeconds, greaterThan(0));
});
```

## Performance Considerations

### 인덱스 전략

```dart
// Drift에서 인덱스는 @TableIndex 어노테이션으로 정의
@TableIndex(name: 'parts_project_order', columns: {#projectId, #orderIndex})
@TableIndex(name: 'main_counters_part', columns: {#partId})
@TableIndex(name: 'stitch_counters_part', columns: {#partId})
@TableIndex(name: 'section_counters_part', columns: {#partId})
@TableIndex(name: 'section_counters_part_link', columns: {#partId, #linkState})
@TableIndex(name: 'section_runs_counter_ord', columns: {#sectionCounterId, #ord})
@TableIndex(name: 'section_runs_counter_state', columns: {#sectionCounterId, #state})
@TableIndex(name: 'sessions_part', columns: {#partId})
@TableIndex(name: 'session_segments_session', columns: {#sessionId})
@TableIndex(name: 'session_segments_started', columns: {#startedAt})
@TableIndex(name: 'tags_name', columns: {#name})
```

### 쿼리 최적화

1. **Eager Loading**: JOIN을 사용해 관련 데이터 한 번에 조회
2. **Lazy Loading**: 필요할 때만 추가 쿼리
3. **Batch Operations**: 여러 레코드를 한 번에 처리
4. **Transaction**: 관련 작업을 트랜잭션으로 묶어 성능 향상

## Next Steps

1. ✅ Design 문서 작성 완료
2. ⏭️ Tasks 문서 작성 (구현 계획)
3. ⏭️ 실제 코드 구현
4. ⏭️ 테스트 작성
5. ⏭️ UI 연동
