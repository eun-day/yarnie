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
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**변경 사항:**
- `currentPartId`: 사용자가 마지막으로 작업한 Part를 추적 (nullable, Part 삭제 시 null로 설정)
- `imagePath`: 프로젝트 이미지 파일 경로 (예: 'project_images/1.jpg')
- `category` 삭제: 태그 시스템으로 대체하여 더 유연한 분류 지원

### 2. Parts 테이블 (신규)

프로젝트 내의 작업 구간을 나타냅니다.

```dart
class Parts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()(); // 정렬 순서
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(projectId, orderIndex)`: Part 목록 조회 최적화

**특징:**
- Part 삭제 시 관련 Counter, Session, Note 모두 cascade 삭제
- `orderIndex`로 사용자 정의 순서 지원

### 3. Counters 테이블 (신규)

MainCounter와 BuddyCounter를 통합한 테이블.

```dart
// Enum 정의
enum BuddyType {
  stitch,  // Stitch Counter
  section, // Section Counter
}

class Counters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  // Main/Buddy 구분
  BoolColumn get isMain => boolean()();
  
  // Buddy Counter 전용 필드
  TextColumn get buddyType => textEnum<BuddyType>().nullable()();
  TextColumn get name => text().nullable()(); // Buddy Counter 이름
  IntColumn get orderIndex => integer().nullable()(); // Buddy Counter 정렬 순서
  
  // Counter 값
  IntColumn get currentValue => integer().withDefault(const Constant(0))();
  IntColumn get countBy => integer().withDefault(const Constant(1))();
  
  // Section Counter 전용 필드
  BoolColumn get linkedToMainCounter => boolean().nullable()(); // Main과 연동 여부
  IntColumn get targetValue => integer().nullable()(); // Section의 목표값
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**제약 조건:**
- Part당 MainCounter는 1개만 존재 (애플리케이션 레벨에서 보장)
- `isMain = true`일 때: `buddyType`, `name`, `orderIndex`, `linkedToMainCounter`는 null
- `isMain = false`일 때: `buddyType`, `name`, `orderIndex`는 필수

**인덱스:**
- `(partId, isMain)`: MainCounter 빠른 조회
- `(partId, orderIndex)`: BuddyCounter 정렬 조회

**필드 설명:**
- `isMain`: true면 MainCounter, false면 BuddyCounter
- `buddyType`: Stitch 또는 Section
- `countBy`: 증감 단위 (MainCounter와 Stitch Counter에서 사용)
- `linkedToMainCounter`: Section Counter가 Main과 연동되는지 여부
- `targetValue`: Section Counter의 목표값 (예: 10단 반복)

### 4. Sessions 테이블 (신규)

Part별 작업 세션을 관리합니다.

```dart
enum SessionStatus {
  running,  // 진행 중
  paused,   // 일시정지
  stopped,  // 종료
}

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get partId => integer()
      .references(Parts, #id, onDelete: KeyAction.cascade)();
  
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get stoppedAt => dateTime().nullable()();
  
  IntColumn get totalDurationSeconds => integer().withDefault(const Constant(0))();
  
  IntColumn get status => intEnum<SessionStatus>()
      .withDefault(Constant(SessionStatus.running.index))();
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

**인덱스:**
- `(partId, status)`: 활성 세션 조회 최적화
- `(startedAt)`: 시간순 정렬 최적화

**특징:**
- Part당 활성 세션(running/paused)은 1개만 존재 (애플리케이션 레벨에서 보장)
- `totalDurationSeconds`: 각 SessionSegment 종료 시마다 누적
- 종료된 세션만 통계에 포함

### 5. SessionSegments 테이블 (신규)

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

### 6. PartNotes 테이블 (신규)

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

### 7. Tags 테이블 (신규)

사용자 정의 태그를 관리합니다.

```dart
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()(); // 태그 이름 (고유)
  IntColumn get color => integer()(); // Flutter Color 값 (0xFFRRGGBB)
  
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
}
```

**제약 조건:**
- `name`: UNIQUE 제약으로 중복 태그 이름 방지

**인덱스:**
- `(name)`: 태그 이름 검색 최적화

**특징:**
- `color`: Flutter의 Color.value를 정수로 저장 (예: Colors.pink.value = 0xFFE91E63)
- 태그 삭제 시 ProjectTags의 관련 레코드도 cascade 삭제

### 8. ProjectTags 테이블 (신규)

프로젝트와 태그의 다대다 관계를 나타냅니다.

```dart
class ProjectTags extends Table {
  IntColumn get projectId => integer()
      .references(Projects, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer()
      .references(Tags, #id, onDelete: KeyAction.cascade)();
  
  @override
  Set<Column> get primaryKey => {projectId, tagId};
}
```

**제약 조건:**
- 복합 기본키 `(projectId, tagId)`: 같은 프로젝트에 같은 태그 중복 방지

**인덱스:**
- 복합 기본키가 자동으로 인덱스 생성
- `(tagId)`: 태그별 프로젝트 조회 최적화를 위한 추가 인덱스

**특징:**
- 프로젝트 삭제 시 관련 태그 연결 자동 삭제
- 태그 삭제 시 관련 프로젝트 연결 자동 삭제
- 별도 ID 없이 두 외래키 조합이 기본키

### 9. 삭제할 테이블

- `WorkSessions`: Sessions + SessionSegments로 대체
- `ProjectCounters`: Counters로 대체

## Data Models

### Dart 모델 클래스

Drift가 자동 생성하는 클래스 외에 추가로 필요한 모델:

```dart
// Counter 데이터를 UI에서 사용하기 쉽게 래핑
class CounterData {
  final int id;
  final int partId;
  final bool isMain;
  final BuddyType? buddyType;
  final String? name;
  final int currentValue;
  final int countBy;
  final bool? linkedToMainCounter;
  final int? targetValue;
  
  // UI 헬퍼
  bool get isStitchCounter => buddyType == BuddyType.stitch;
  bool get isSectionCounter => buddyType == BuddyType.section;
  double? get progress => 
      (targetValue != null && targetValue! > 0) 
          ? currentValue / targetValue! 
          : null;
}

// Session 상태를 UI에서 표시하기 위한 모델
class SessionViewModel {
  final Session session;
  final List<SessionSegment> segments;
  final Duration currentDuration;
  
  bool get isRunning => session.status == SessionStatus.running;
  bool get isPaused => session.status == SessionStatus.paused;
  bool get isStopped => session.status == SessionStatus.stopped;
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
      ),
    );
    
    // MainCounter 자동 생성
    await into(counters).insert(
      CountersCompanion.insert(
        partId: partId,
        isMain: true,
        currentValue: const Value(0),
        countBy: const Value(1),
      ),
    );
    
    return partId;
  });
}

// Part의 모든 Counter 조회
Future<List<Counter>> getPartCounters(int partId) {
  return (select(counters)
    ..where((t) => t.partId.equals(partId))
    ..orderBy([
      (t) => OrderingTerm.desc(t.isMain), // MainCounter 먼저
      (t) => OrderingTerm.asc(t.orderIndex), // 그 다음 순서대로
    ])).get();
}

// MainCounter만 조회
Future<Counter> getMainCounter(int partId) {
  return (select(counters)
    ..where((t) => t.partId.equals(partId) & t.isMain.equals(true))
  ).getSingle();
}
```

#### 2. Session 관련

```dart
// 활성 세션 조회
Future<Session?> getActiveSession(int partId) {
  return (select(sessions)
    ..where((t) => 
      t.partId.equals(partId) &
      t.status.isIn([
        SessionStatus.running.index,
        SessionStatus.paused.index,
      ])
    )
    ..limit(1)
  ).getSingleOrNull();
}

// 세션 시작
Future<int> startSession({required int partId}) async {
  return transaction(() async {
    // 기존 활성 세션 확인
    final active = await getActiveSession(partId);
    if (active != null) {
      throw StateError('이미 활성 세션이 있습니다');
    }
    
    final now = DateTime.now();
    final mainCounter = await getMainCounter(partId);
    
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
        startCount: Value(mainCounter.currentValue),
        reason: Value(SegmentReason.resume),
      ),
    );
    
    return sessionId;
  });
}

// 세션 일시정지
Future<void> pauseSession({required int sessionId}) async {
  return transaction(() async {
    final session = await (select(sessions)
      ..where((t) => t.id.equals(sessionId))
    ).getSingle();
    
    if (session.status != SessionStatus.running) {
      throw StateError('진행 중인 세션이 아닙니다');
    }
    
    final now = DateTime.now();
    final mainCounter = await getMainCounter(session.partId);
    
    // 현재 Segment 종료
    final currentSegment = await (select(sessionSegments)
      ..where((t) => 
        t.sessionId.equals(sessionId) &
        t.endedAt.isNull()
      )
    ).getSingle();
    
    final duration = now.difference(currentSegment.startedAt).inSeconds;
    
    await (update(sessionSegments)
      ..where((t) => t.id.equals(currentSegment.id))
    ).write(
      SessionSegmentsCompanion(
        endedAt: Value(now),
        durationSeconds: Value(duration),
        endCount: Value(mainCounter.currentValue),
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
```

#### 3. 통계 쿼리

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

// 프로젝트별 총 작업 시간
Future<int> getProjectTotalSeconds(int projectId) async {
  final result = await customSelect(
    '''
    SELECT COALESCE(SUM(s.total_duration_seconds), 0) as total
    FROM sessions s
    JOIN parts p ON s.part_id = p.id
    WHERE p.project_id = ?1 AND s.status = ?2
    ''',
    variables: [
      Variable.withInt(projectId),
      Variable.withInt(SessionStatus.stopped.index),
    ],
    readsFrom: {sessions, parts},
  ).getSingle();
  
  return result.data['total'] as int;
}
```

#### 4. 태그 관련 쿼리

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
    ),
  );
}

// 태그 삭제 (ProjectTags도 cascade 삭제됨)
Future<void> deleteTag(int tagId) {
  return (delete(tags)..where((t) => t.id.equals(tagId))).go();
}

// 프로젝트에 태그 연결
Future<void> addTagToProject({
  required int projectId,
  required int tagId,
}) {
  return into(projectTags).insert(
    ProjectTagsCompanion.insert(
      projectId: projectId,
      tagId: tagId,
    ),
    mode: InsertMode.insertOrIgnore, // 이미 있으면 무시
  );
}

// 프로젝트에서 태그 제거
Future<void> removeTagFromProject({
  required int projectId,
  required int tagId,
}) {
  return (delete(projectTags)
    ..where((t) => 
      t.projectId.equals(projectId) & 
      t.tagId.equals(tagId)
    )
  ).go();
}

// 프로젝트의 모든 태그 조회
Future<List<Tag>> getProjectTags(int projectId) async {
  final query = select(tags).join([
    innerJoin(
      projectTags,
      projectTags.tagId.equalsExp(tags.id),
    ),
  ])..where(projectTags.projectId.equals(projectId));
  
  final result = await query.get();
  return result.map((row) => row.readTable(tags)).toList();
}

// 태그별 프로젝트 조회 (단일 태그)
Future<List<Project>> getProjectsByTag(int tagId) async {
  final query = select(projects).join([
    innerJoin(
      projectTags,
      projectTags.projectId.equalsExp(projects.id),
    ),
  ])..where(projectTags.tagId.equals(tagId));
  
  final result = await query.get();
  return result.map((row) => row.readTable(projects)).toList();
}

// 다중 태그 필터 (AND 조건)
Future<List<Project>> getProjectsByTags(List<int> tagIds) async {
  if (tagIds.isEmpty) {
    return (select(projects)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
    ).get();
  }
  
  final result = await customSelect(
    '''
    SELECT p.* FROM projects p
    WHERE p.id IN (
      SELECT project_id FROM project_tags
      WHERE tag_id IN (${tagIds.map((_) => '?').join(',')})
      GROUP BY project_id
      HAVING COUNT(DISTINCT tag_id) = ?
    )
    ORDER BY p.created_at DESC
    ''',
    variables: [
      ...tagIds.map((id) => Variable.withInt(id)),
      Variable.withInt(tagIds.length),
    ],
    readsFrom: {projects, projectTags},
  ).get();
  
  return result.map((row) {
    return Project(
      id: row.data['id'] as int,
      name: row.data['name'] as String,
      needleType: row.data['needle_type'] as String?,
      needleSize: row.data['needle_size'] as String?,
      lotNumber: row.data['lot_number'] as String?,
      memo: row.data['memo'] as String?,
      currentPartId: row.data['current_part_id'] as int?,
      imagePath: row.data['image_path'] as String?,
      createdAt: DateTime.parse(row.data['created_at'] as String),
      updatedAt: row.data['updated_at'] != null 
          ? DateTime.parse(row.data['updated_at'] as String) 
          : null,
    );
  }).toList();
}

// 프로젝트의 태그 일괄 업데이트
Future<void> updateProjectTags({
  required int projectId,
  required List<int> tagIds,
}) async {
  return transaction(() async {
    // 기존 태그 연결 모두 삭제
    await (delete(projectTags)
      ..where((t) => t.projectId.equals(projectId))
    ).go();
    
    // 새 태그 연결
    for (final tagId in tagIds) {
      await into(projectTags).insert(
        ProjectTagsCompanion.insert(
          projectId: projectId,
          tagId: tagId,
        ),
      );
    }
  });
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
      await m.createTable(counters);
      await m.createTable(sessions);
      await m.createTable(sessionSegments);
      await m.createTable(partNotes);
      await m.createTable(tags);
      await m.createTable(projectTags);
      
      // Projects 테이블 수정
      await m.addColumn(projects, projects.currentPartId);
      await m.addColumn(projects, projects.imagePath);
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
@TableIndex(name: 'counters_part_main', columns: {#partId, #isMain})
@TableIndex(name: 'counters_part_order', columns: {#partId, #orderIndex})
@TableIndex(name: 'sessions_part_status', columns: {#partId, #status})
@TableIndex(name: 'session_segments_session', columns: {#sessionId})
@TableIndex(name: 'session_segments_started', columns: {#startedAt})
@TableIndex(name: 'tags_name', columns: {#name})
@TableIndex(name: 'project_tags_tag', columns: {#tagId})
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
