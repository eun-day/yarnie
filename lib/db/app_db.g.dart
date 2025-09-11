// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needleTypeMeta = const VerificationMeta(
    'needleType',
  );
  @override
  late final GeneratedColumn<String> needleType = GeneratedColumn<String>(
    'needle_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needleSizeMeta = const VerificationMeta(
    'needleSize',
  );
  @override
  late final GeneratedColumn<String> needleSize = GeneratedColumn<String>(
    'needle_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lotNumberMeta = const VerificationMeta(
    'lotNumber',
  );
  @override
  late final GeneratedColumn<String> lotNumber = GeneratedColumn<String>(
    'lot_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    needleType,
    needleSize,
    lotNumber,
    memo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('needle_type')) {
      context.handle(
        _needleTypeMeta,
        needleType.isAcceptableOrUnknown(data['needle_type']!, _needleTypeMeta),
      );
    }
    if (data.containsKey('needle_size')) {
      context.handle(
        _needleSizeMeta,
        needleSize.isAcceptableOrUnknown(data['needle_size']!, _needleSizeMeta),
      );
    }
    if (data.containsKey('lot_number')) {
      context.handle(
        _lotNumberMeta,
        lotNumber.isAcceptableOrUnknown(data['lot_number']!, _lotNumberMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      needleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}needle_type'],
      ),
      needleSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}needle_size'],
      ),
      lotNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot_number'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final String? category;
  final String? needleType;
  final String? needleSize;
  final String? lotNumber;
  final String? memo;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Project({
    required this.id,
    required this.name,
    this.category,
    this.needleType,
    this.needleSize,
    this.lotNumber,
    this.memo,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || needleType != null) {
      map['needle_type'] = Variable<String>(needleType);
    }
    if (!nullToAbsent || needleSize != null) {
      map['needle_size'] = Variable<String>(needleSize);
    }
    if (!nullToAbsent || lotNumber != null) {
      map['lot_number'] = Variable<String>(lotNumber);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      needleType: needleType == null && nullToAbsent
          ? const Value.absent()
          : Value(needleType),
      needleSize: needleSize == null && nullToAbsent
          ? const Value.absent()
          : Value(needleSize),
      lotNumber: lotNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(lotNumber),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      needleType: serializer.fromJson<String?>(json['needleType']),
      needleSize: serializer.fromJson<String?>(json['needleSize']),
      lotNumber: serializer.fromJson<String?>(json['lotNumber']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'needleType': serializer.toJson<String?>(needleType),
      'needleSize': serializer.toJson<String?>(needleSize),
      'lotNumber': serializer.toJson<String?>(lotNumber),
      'memo': serializer.toJson<String?>(memo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Project copyWith({
    int? id,
    String? name,
    Value<String?> category = const Value.absent(),
    Value<String?> needleType = const Value.absent(),
    Value<String?> needleSize = const Value.absent(),
    Value<String?> lotNumber = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    needleType: needleType.present ? needleType.value : this.needleType,
    needleSize: needleSize.present ? needleSize.value : this.needleSize,
    lotNumber: lotNumber.present ? lotNumber.value : this.lotNumber,
    memo: memo.present ? memo.value : this.memo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      needleType: data.needleType.present
          ? data.needleType.value
          : this.needleType,
      needleSize: data.needleSize.present
          ? data.needleSize.value
          : this.needleSize,
      lotNumber: data.lotNumber.present ? data.lotNumber.value : this.lotNumber,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('needleType: $needleType, ')
          ..write('needleSize: $needleSize, ')
          ..write('lotNumber: $lotNumber, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    needleType,
    needleSize,
    lotNumber,
    memo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.needleType == this.needleType &&
          other.needleSize == this.needleSize &&
          other.lotNumber == this.lotNumber &&
          other.memo == this.memo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<String?> needleType;
  final Value<String?> needleSize;
  final Value<String?> lotNumber;
  final Value<String?> memo;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.needleType = const Value.absent(),
    this.needleSize = const Value.absent(),
    this.lotNumber = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.needleType = const Value.absent(),
    this.needleSize = const Value.absent(),
    this.lotNumber = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? needleType,
    Expression<String>? needleSize,
    Expression<String>? lotNumber,
    Expression<String>? memo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (needleType != null) 'needle_type': needleType,
      if (needleSize != null) 'needle_size': needleSize,
      if (lotNumber != null) 'lot_number': lotNumber,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? category,
    Value<String?>? needleType,
    Value<String?>? needleSize,
    Value<String?>? lotNumber,
    Value<String?>? memo,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      needleType: needleType ?? this.needleType,
      needleSize: needleSize ?? this.needleSize,
      lotNumber: lotNumber ?? this.lotNumber,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (needleType.present) {
      map['needle_type'] = Variable<String>(needleType.value);
    }
    if (needleSize.present) {
      map['needle_size'] = Variable<String>(needleSize.value);
    }
    if (lotNumber.present) {
      map['lot_number'] = Variable<String>(lotNumber.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('needleType: $needleType, ')
          ..write('needleSize: $needleSize, ')
          ..write('lotNumber: $lotNumber, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkSessionsTable extends WorkSessions
    with TableInfo<$WorkSessionsTable, WorkSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stoppedAtMeta = const VerificationMeta(
    'stoppedAt',
  );
  @override
  late final GeneratedColumn<int> stoppedAt = GeneratedColumn<int>(
    'stopped_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elapsedMsMeta = const VerificationMeta(
    'elapsedMs',
  );
  @override
  late final GeneratedColumn<int> elapsedMs = GeneratedColumn<int>(
    'elapsed_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastStartedAtMeta = const VerificationMeta(
    'lastStartedAt',
  );
  @override
  late final GeneratedColumn<int> lastStartedAt = GeneratedColumn<int>(
    'last_started_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(SessionStatus.running.index),
      ).withConverter<SessionStatus>($WorkSessionsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    startedAt,
    stoppedAt,
    elapsedMs,
    lastStartedAt,
    label,
    memo,
    createdAt,
    updatedAt,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('stopped_at')) {
      context.handle(
        _stoppedAtMeta,
        stoppedAt.isAcceptableOrUnknown(data['stopped_at']!, _stoppedAtMeta),
      );
    }
    if (data.containsKey('elapsed_ms')) {
      context.handle(
        _elapsedMsMeta,
        elapsedMs.isAcceptableOrUnknown(data['elapsed_ms']!, _elapsedMsMeta),
      );
    }
    if (data.containsKey('last_started_at')) {
      context.handle(
        _lastStartedAtMeta,
        lastStartedAt.isAcceptableOrUnknown(
          data['last_started_at']!,
          _lastStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      stoppedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stopped_at'],
      ),
      elapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_ms'],
      )!,
      lastStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_started_at'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
      status: $WorkSessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $WorkSessionsTable createAlias(String alias) {
    return $WorkSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SessionStatus, int, int> $converterstatus =
      const EnumIndexConverter<SessionStatus>(SessionStatus.values);
}

class WorkSession extends DataClass implements Insertable<WorkSession> {
  final int id;
  final int projectId;
  final int startedAt;
  final int? stoppedAt;
  final int elapsedMs;
  final int? lastStartedAt;
  final String? label;
  final String? memo;
  final int createdAt;
  final int? updatedAt;
  final SessionStatus status;
  const WorkSession({
    required this.id,
    required this.projectId,
    required this.startedAt,
    this.stoppedAt,
    required this.elapsedMs,
    this.lastStartedAt,
    this.label,
    this.memo,
    required this.createdAt,
    this.updatedAt,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || stoppedAt != null) {
      map['stopped_at'] = Variable<int>(stoppedAt);
    }
    map['elapsed_ms'] = Variable<int>(elapsedMs);
    if (!nullToAbsent || lastStartedAt != null) {
      map['last_started_at'] = Variable<int>(lastStartedAt);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    {
      map['status'] = Variable<int>(
        $WorkSessionsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  WorkSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkSessionsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      startedAt: Value(startedAt),
      stoppedAt: stoppedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(stoppedAt),
      elapsedMs: Value(elapsedMs),
      lastStartedAt: lastStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastStartedAt),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      status: Value(status),
    );
  }

  factory WorkSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkSession(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      stoppedAt: serializer.fromJson<int?>(json['stoppedAt']),
      elapsedMs: serializer.fromJson<int>(json['elapsedMs']),
      lastStartedAt: serializer.fromJson<int?>(json['lastStartedAt']),
      label: serializer.fromJson<String?>(json['label']),
      memo: serializer.fromJson<String?>(json['memo']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
      status: $WorkSessionsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'startedAt': serializer.toJson<int>(startedAt),
      'stoppedAt': serializer.toJson<int?>(stoppedAt),
      'elapsedMs': serializer.toJson<int>(elapsedMs),
      'lastStartedAt': serializer.toJson<int?>(lastStartedAt),
      'label': serializer.toJson<String?>(label),
      'memo': serializer.toJson<String?>(memo),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
      'status': serializer.toJson<int>(
        $WorkSessionsTable.$converterstatus.toJson(status),
      ),
    };
  }

  WorkSession copyWith({
    int? id,
    int? projectId,
    int? startedAt,
    Value<int?> stoppedAt = const Value.absent(),
    int? elapsedMs,
    Value<int?> lastStartedAt = const Value.absent(),
    Value<String?> label = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    int? createdAt,
    Value<int?> updatedAt = const Value.absent(),
    SessionStatus? status,
  }) => WorkSession(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    startedAt: startedAt ?? this.startedAt,
    stoppedAt: stoppedAt.present ? stoppedAt.value : this.stoppedAt,
    elapsedMs: elapsedMs ?? this.elapsedMs,
    lastStartedAt: lastStartedAt.present
        ? lastStartedAt.value
        : this.lastStartedAt,
    label: label.present ? label.value : this.label,
    memo: memo.present ? memo.value : this.memo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    status: status ?? this.status,
  );
  WorkSession copyWithCompanion(WorkSessionsCompanion data) {
    return WorkSession(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      stoppedAt: data.stoppedAt.present ? data.stoppedAt.value : this.stoppedAt,
      elapsedMs: data.elapsedMs.present ? data.elapsedMs.value : this.elapsedMs,
      lastStartedAt: data.lastStartedAt.present
          ? data.lastStartedAt.value
          : this.lastStartedAt,
      label: data.label.present ? data.label.value : this.label,
      memo: data.memo.present ? data.memo.value : this.memo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkSession(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('stoppedAt: $stoppedAt, ')
          ..write('elapsedMs: $elapsedMs, ')
          ..write('lastStartedAt: $lastStartedAt, ')
          ..write('label: $label, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    startedAt,
    stoppedAt,
    elapsedMs,
    lastStartedAt,
    label,
    memo,
    createdAt,
    updatedAt,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkSession &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.startedAt == this.startedAt &&
          other.stoppedAt == this.stoppedAt &&
          other.elapsedMs == this.elapsedMs &&
          other.lastStartedAt == this.lastStartedAt &&
          other.label == this.label &&
          other.memo == this.memo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.status == this.status);
}

class WorkSessionsCompanion extends UpdateCompanion<WorkSession> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int> startedAt;
  final Value<int?> stoppedAt;
  final Value<int> elapsedMs;
  final Value<int?> lastStartedAt;
  final Value<String?> label;
  final Value<String?> memo;
  final Value<int> createdAt;
  final Value<int?> updatedAt;
  final Value<SessionStatus> status;
  const WorkSessionsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.stoppedAt = const Value.absent(),
    this.elapsedMs = const Value.absent(),
    this.lastStartedAt = const Value.absent(),
    this.label = const Value.absent(),
    this.memo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.status = const Value.absent(),
  });
  WorkSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required int startedAt,
    this.stoppedAt = const Value.absent(),
    this.elapsedMs = const Value.absent(),
    this.lastStartedAt = const Value.absent(),
    this.label = const Value.absent(),
    this.memo = const Value.absent(),
    required int createdAt,
    this.updatedAt = const Value.absent(),
    this.status = const Value.absent(),
  }) : projectId = Value(projectId),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt);
  static Insertable<WorkSession> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? startedAt,
    Expression<int>? stoppedAt,
    Expression<int>? elapsedMs,
    Expression<int>? lastStartedAt,
    Expression<String>? label,
    Expression<String>? memo,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (startedAt != null) 'started_at': startedAt,
      if (stoppedAt != null) 'stopped_at': stoppedAt,
      if (elapsedMs != null) 'elapsed_ms': elapsedMs,
      if (lastStartedAt != null) 'last_started_at': lastStartedAt,
      if (label != null) 'label': label,
      if (memo != null) 'memo': memo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (status != null) 'status': status,
    });
  }

  WorkSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int>? startedAt,
    Value<int?>? stoppedAt,
    Value<int>? elapsedMs,
    Value<int?>? lastStartedAt,
    Value<String?>? label,
    Value<String?>? memo,
    Value<int>? createdAt,
    Value<int?>? updatedAt,
    Value<SessionStatus>? status,
  }) {
    return WorkSessionsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startedAt: startedAt ?? this.startedAt,
      stoppedAt: stoppedAt ?? this.stoppedAt,
      elapsedMs: elapsedMs ?? this.elapsedMs,
      lastStartedAt: lastStartedAt ?? this.lastStartedAt,
      label: label ?? this.label,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (stoppedAt.present) {
      map['stopped_at'] = Variable<int>(stoppedAt.value);
    }
    if (elapsedMs.present) {
      map['elapsed_ms'] = Variable<int>(elapsedMs.value);
    }
    if (lastStartedAt.present) {
      map['last_started_at'] = Variable<int>(lastStartedAt.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $WorkSessionsTable.$converterstatus.toSql(status.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkSessionsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('startedAt: $startedAt, ')
          ..write('stoppedAt: $stoppedAt, ')
          ..write('elapsedMs: $elapsedMs, ')
          ..write('lastStartedAt: $lastStartedAt, ')
          ..write('label: $label, ')
          ..write('memo: $memo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $WorkSessionsTable workSessions = $WorkSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [projects, workSessions];
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> category,
      Value<String?> needleType,
      Value<String?> needleSize,
      Value<String?> lotNumber,
      Value<String?> memo,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> category,
      Value<String?> needleType,
      Value<String?> needleSize,
      Value<String?> lotNumber,
      Value<String?> memo,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$ProjectsTableFilterComposer extends Composer<_$AppDb, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get needleType => $composableBuilder(
    column: $table.needleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get needleSize => $composableBuilder(
    column: $table.needleSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lotNumber => $composableBuilder(
    column: $table.lotNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDb, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get needleType => $composableBuilder(
    column: $table.needleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get needleSize => $composableBuilder(
    column: $table.needleSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lotNumber => $composableBuilder(
    column: $table.lotNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDb, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get needleType => $composableBuilder(
    column: $table.needleType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get needleSize => $composableBuilder(
    column: $table.needleSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lotNumber =>
      $composableBuilder(column: $table.lotNumber, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, BaseReferences<_$AppDb, $ProjectsTable, Project>),
          Project,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDb db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> needleType = const Value.absent(),
                Value<String?> needleSize = const Value.absent(),
                Value<String?> lotNumber = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                category: category,
                needleType: needleType,
                needleSize: needleSize,
                lotNumber: lotNumber,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
                Value<String?> needleType = const Value.absent(),
                Value<String?> needleSize = const Value.absent(),
                Value<String?> lotNumber = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                category: category,
                needleType: needleType,
                needleSize: needleSize,
                lotNumber: lotNumber,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, BaseReferences<_$AppDb, $ProjectsTable, Project>),
      Project,
      PrefetchHooks Function()
    >;
typedef $$WorkSessionsTableCreateCompanionBuilder =
    WorkSessionsCompanion Function({
      Value<int> id,
      required int projectId,
      required int startedAt,
      Value<int?> stoppedAt,
      Value<int> elapsedMs,
      Value<int?> lastStartedAt,
      Value<String?> label,
      Value<String?> memo,
      required int createdAt,
      Value<int?> updatedAt,
      Value<SessionStatus> status,
    });
typedef $$WorkSessionsTableUpdateCompanionBuilder =
    WorkSessionsCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<int> startedAt,
      Value<int?> stoppedAt,
      Value<int> elapsedMs,
      Value<int?> lastStartedAt,
      Value<String?> label,
      Value<String?> memo,
      Value<int> createdAt,
      Value<int?> updatedAt,
      Value<SessionStatus> status,
    });

class $$WorkSessionsTableFilterComposer
    extends Composer<_$AppDb, $WorkSessionsTable> {
  $$WorkSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stoppedAt => $composableBuilder(
    column: $table.stoppedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedMs => $composableBuilder(
    column: $table.elapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastStartedAt => $composableBuilder(
    column: $table.lastStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$WorkSessionsTableOrderingComposer
    extends Composer<_$AppDb, $WorkSessionsTable> {
  $$WorkSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stoppedAt => $composableBuilder(
    column: $table.stoppedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedMs => $composableBuilder(
    column: $table.elapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastStartedAt => $composableBuilder(
    column: $table.lastStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkSessionsTableAnnotationComposer
    extends Composer<_$AppDb, $WorkSessionsTable> {
  $$WorkSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get stoppedAt =>
      $composableBuilder(column: $table.stoppedAt, builder: (column) => column);

  GeneratedColumn<int> get elapsedMs =>
      $composableBuilder(column: $table.elapsedMs, builder: (column) => column);

  GeneratedColumn<int> get lastStartedAt => $composableBuilder(
    column: $table.lastStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$WorkSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $WorkSessionsTable,
          WorkSession,
          $$WorkSessionsTableFilterComposer,
          $$WorkSessionsTableOrderingComposer,
          $$WorkSessionsTableAnnotationComposer,
          $$WorkSessionsTableCreateCompanionBuilder,
          $$WorkSessionsTableUpdateCompanionBuilder,
          (
            WorkSession,
            BaseReferences<_$AppDb, $WorkSessionsTable, WorkSession>,
          ),
          WorkSession,
          PrefetchHooks Function()
        > {
  $$WorkSessionsTableTableManager(_$AppDb db, $WorkSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> stoppedAt = const Value.absent(),
                Value<int> elapsedMs = const Value.absent(),
                Value<int?> lastStartedAt = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
              }) => WorkSessionsCompanion(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                stoppedAt: stoppedAt,
                elapsedMs: elapsedMs,
                lastStartedAt: lastStartedAt,
                label: label,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required int startedAt,
                Value<int?> stoppedAt = const Value.absent(),
                Value<int> elapsedMs = const Value.absent(),
                Value<int?> lastStartedAt = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                required int createdAt,
                Value<int?> updatedAt = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
              }) => WorkSessionsCompanion.insert(
                id: id,
                projectId: projectId,
                startedAt: startedAt,
                stoppedAt: stoppedAt,
                elapsedMs: elapsedMs,
                lastStartedAt: lastStartedAt,
                label: label,
                memo: memo,
                createdAt: createdAt,
                updatedAt: updatedAt,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $WorkSessionsTable,
      WorkSession,
      $$WorkSessionsTableFilterComposer,
      $$WorkSessionsTableOrderingComposer,
      $$WorkSessionsTableAnnotationComposer,
      $$WorkSessionsTableCreateCompanionBuilder,
      $$WorkSessionsTableUpdateCompanionBuilder,
      (WorkSession, BaseReferences<_$AppDb, $WorkSessionsTable, WorkSession>),
      WorkSession,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$WorkSessionsTableTableManager get workSessions =>
      $$WorkSessionsTableTableManager(_db, _db.workSessions);
}
