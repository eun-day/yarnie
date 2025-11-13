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
  static const VerificationMeta _currentPartIdMeta = const VerificationMeta(
    'currentPartId',
  );
  @override
  late final GeneratedColumn<int> currentPartId = GeneratedColumn<int>(
    'current_part_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagIdsMeta = const VerificationMeta('tagIds');
  @override
  late final GeneratedColumn<String> tagIds = GeneratedColumn<String>(
    'tag_ids',
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
    needleType,
    needleSize,
    lotNumber,
    memo,
    currentPartId,
    imagePath,
    tagIds,
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
    if (data.containsKey('current_part_id')) {
      context.handle(
        _currentPartIdMeta,
        currentPartId.isAcceptableOrUnknown(
          data['current_part_id']!,
          _currentPartIdMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('tag_ids')) {
      context.handle(
        _tagIdsMeta,
        tagIds.isAcceptableOrUnknown(data['tag_ids']!, _tagIdsMeta),
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
      currentPartId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_part_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      tagIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_ids'],
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
  final String? needleType;
  final String? needleSize;
  final String? lotNumber;
  final String? memo;
  final int? currentPartId;
  final String? imagePath;
  final String? tagIds;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Project({
    required this.id,
    required this.name,
    this.needleType,
    this.needleSize,
    this.lotNumber,
    this.memo,
    this.currentPartId,
    this.imagePath,
    this.tagIds,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
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
    if (!nullToAbsent || currentPartId != null) {
      map['current_part_id'] = Variable<int>(currentPartId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || tagIds != null) {
      map['tag_ids'] = Variable<String>(tagIds);
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
      currentPartId: currentPartId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentPartId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      tagIds: tagIds == null && nullToAbsent
          ? const Value.absent()
          : Value(tagIds),
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
      needleType: serializer.fromJson<String?>(json['needleType']),
      needleSize: serializer.fromJson<String?>(json['needleSize']),
      lotNumber: serializer.fromJson<String?>(json['lotNumber']),
      memo: serializer.fromJson<String?>(json['memo']),
      currentPartId: serializer.fromJson<int?>(json['currentPartId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      tagIds: serializer.fromJson<String?>(json['tagIds']),
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
      'needleType': serializer.toJson<String?>(needleType),
      'needleSize': serializer.toJson<String?>(needleSize),
      'lotNumber': serializer.toJson<String?>(lotNumber),
      'memo': serializer.toJson<String?>(memo),
      'currentPartId': serializer.toJson<int?>(currentPartId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'tagIds': serializer.toJson<String?>(tagIds),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Project copyWith({
    int? id,
    String? name,
    Value<String?> needleType = const Value.absent(),
    Value<String?> needleSize = const Value.absent(),
    Value<String?> lotNumber = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<int?> currentPartId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<String?> tagIds = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    needleType: needleType.present ? needleType.value : this.needleType,
    needleSize: needleSize.present ? needleSize.value : this.needleSize,
    lotNumber: lotNumber.present ? lotNumber.value : this.lotNumber,
    memo: memo.present ? memo.value : this.memo,
    currentPartId: currentPartId.present
        ? currentPartId.value
        : this.currentPartId,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    tagIds: tagIds.present ? tagIds.value : this.tagIds,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      needleType: data.needleType.present
          ? data.needleType.value
          : this.needleType,
      needleSize: data.needleSize.present
          ? data.needleSize.value
          : this.needleSize,
      lotNumber: data.lotNumber.present ? data.lotNumber.value : this.lotNumber,
      memo: data.memo.present ? data.memo.value : this.memo,
      currentPartId: data.currentPartId.present
          ? data.currentPartId.value
          : this.currentPartId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      tagIds: data.tagIds.present ? data.tagIds.value : this.tagIds,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('needleType: $needleType, ')
          ..write('needleSize: $needleSize, ')
          ..write('lotNumber: $lotNumber, ')
          ..write('memo: $memo, ')
          ..write('currentPartId: $currentPartId, ')
          ..write('imagePath: $imagePath, ')
          ..write('tagIds: $tagIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    needleType,
    needleSize,
    lotNumber,
    memo,
    currentPartId,
    imagePath,
    tagIds,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.needleType == this.needleType &&
          other.needleSize == this.needleSize &&
          other.lotNumber == this.lotNumber &&
          other.memo == this.memo &&
          other.currentPartId == this.currentPartId &&
          other.imagePath == this.imagePath &&
          other.tagIds == this.tagIds &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> needleType;
  final Value<String?> needleSize;
  final Value<String?> lotNumber;
  final Value<String?> memo;
  final Value<int?> currentPartId;
  final Value<String?> imagePath;
  final Value<String?> tagIds;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.needleType = const Value.absent(),
    this.needleSize = const Value.absent(),
    this.lotNumber = const Value.absent(),
    this.memo = const Value.absent(),
    this.currentPartId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.tagIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.needleType = const Value.absent(),
    this.needleSize = const Value.absent(),
    this.lotNumber = const Value.absent(),
    this.memo = const Value.absent(),
    this.currentPartId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.tagIds = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? needleType,
    Expression<String>? needleSize,
    Expression<String>? lotNumber,
    Expression<String>? memo,
    Expression<int>? currentPartId,
    Expression<String>? imagePath,
    Expression<String>? tagIds,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (needleType != null) 'needle_type': needleType,
      if (needleSize != null) 'needle_size': needleSize,
      if (lotNumber != null) 'lot_number': lotNumber,
      if (memo != null) 'memo': memo,
      if (currentPartId != null) 'current_part_id': currentPartId,
      if (imagePath != null) 'image_path': imagePath,
      if (tagIds != null) 'tag_ids': tagIds,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? needleType,
    Value<String?>? needleSize,
    Value<String?>? lotNumber,
    Value<String?>? memo,
    Value<int?>? currentPartId,
    Value<String?>? imagePath,
    Value<String?>? tagIds,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      needleType: needleType ?? this.needleType,
      needleSize: needleSize ?? this.needleSize,
      lotNumber: lotNumber ?? this.lotNumber,
      memo: memo ?? this.memo,
      currentPartId: currentPartId ?? this.currentPartId,
      imagePath: imagePath ?? this.imagePath,
      tagIds: tagIds ?? this.tagIds,
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
    if (currentPartId.present) {
      map['current_part_id'] = Variable<int>(currentPartId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (tagIds.present) {
      map['tag_ids'] = Variable<String>(tagIds.value);
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
          ..write('needleType: $needleType, ')
          ..write('needleSize: $needleSize, ')
          ..write('lotNumber: $lotNumber, ')
          ..write('memo: $memo, ')
          ..write('currentPartId: $currentPartId, ')
          ..write('imagePath: $imagePath, ')
          ..write('tagIds: $tagIds, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PartsTable extends Parts with TableInfo<$PartsTable, Part> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartsTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE CASCADE',
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
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buddyCounterOrderMeta = const VerificationMeta(
    'buddyCounterOrder',
  );
  @override
  late final GeneratedColumn<String> buddyCounterOrder =
      GeneratedColumn<String>(
        'buddy_counter_order',
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
    projectId,
    name,
    orderIndex,
    buddyCounterOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Part> instance, {
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('buddy_counter_order')) {
      context.handle(
        _buddyCounterOrderMeta,
        buddyCounterOrder.isAcceptableOrUnknown(
          data['buddy_counter_order']!,
          _buddyCounterOrderMeta,
        ),
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
  Part map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Part(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      buddyCounterOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buddy_counter_order'],
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
  $PartsTable createAlias(String alias) {
    return $PartsTable(attachedDatabase, alias);
  }
}

class Part extends DataClass implements Insertable<Part> {
  final int id;
  final int projectId;
  final String name;
  final int orderIndex;
  final String? buddyCounterOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Part({
    required this.id,
    required this.projectId,
    required this.name,
    required this.orderIndex,
    this.buddyCounterOrder,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    map['name'] = Variable<String>(name);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || buddyCounterOrder != null) {
      map['buddy_counter_order'] = Variable<String>(buddyCounterOrder);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PartsCompanion toCompanion(bool nullToAbsent) {
    return PartsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      orderIndex: Value(orderIndex),
      buddyCounterOrder: buddyCounterOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(buddyCounterOrder),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Part.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Part(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      buddyCounterOrder: serializer.fromJson<String?>(
        json['buddyCounterOrder'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'name': serializer.toJson<String>(name),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'buddyCounterOrder': serializer.toJson<String?>(buddyCounterOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Part copyWith({
    int? id,
    int? projectId,
    String? name,
    int? orderIndex,
    Value<String?> buddyCounterOrder = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Part(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    orderIndex: orderIndex ?? this.orderIndex,
    buddyCounterOrder: buddyCounterOrder.present
        ? buddyCounterOrder.value
        : this.buddyCounterOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Part copyWithCompanion(PartsCompanion data) {
    return Part(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      buddyCounterOrder: data.buddyCounterOrder.present
          ? data.buddyCounterOrder.value
          : this.buddyCounterOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Part(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('buddyCounterOrder: $buddyCounterOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    orderIndex,
    buddyCounterOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Part &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.orderIndex == this.orderIndex &&
          other.buddyCounterOrder == this.buddyCounterOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartsCompanion extends UpdateCompanion<Part> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String> name;
  final Value<int> orderIndex;
  final Value<String?> buddyCounterOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PartsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.buddyCounterOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PartsCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    required String name,
    required int orderIndex,
    this.buddyCounterOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : projectId = Value(projectId),
       name = Value(name),
       orderIndex = Value(orderIndex);
  static Insertable<Part> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? name,
    Expression<int>? orderIndex,
    Expression<String>? buddyCounterOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (orderIndex != null) 'order_index': orderIndex,
      if (buddyCounterOrder != null) 'buddy_counter_order': buddyCounterOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PartsCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String>? name,
    Value<int>? orderIndex,
    Value<String?>? buddyCounterOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return PartsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      buddyCounterOrder: buddyCounterOrder ?? this.buddyCounterOrder,
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
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (buddyCounterOrder.present) {
      map['buddy_counter_order'] = Variable<String>(buddyCounterOrder.value);
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
    return (StringBuffer('PartsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('buddyCounterOrder: $buddyCounterOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MainCountersTable extends MainCounters
    with TableInfo<$MainCountersTable, MainCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MainCountersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<int> currentValue = GeneratedColumn<int>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    partId,
    currentValue,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'main_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<MainCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
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
  MainCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MainCounter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_value'],
      )!,
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
  $MainCountersTable createAlias(String alias) {
    return $MainCountersTable(attachedDatabase, alias);
  }
}

class MainCounter extends DataClass implements Insertable<MainCounter> {
  final int id;
  final int partId;
  final int currentValue;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const MainCounter({
    required this.id,
    required this.partId,
    required this.currentValue,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['current_value'] = Variable<int>(currentValue);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  MainCountersCompanion toCompanion(bool nullToAbsent) {
    return MainCountersCompanion(
      id: Value(id),
      partId: Value(partId),
      currentValue: Value(currentValue),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory MainCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MainCounter(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      currentValue: serializer.fromJson<int>(json['currentValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'currentValue': serializer.toJson<int>(currentValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  MainCounter copyWith({
    int? id,
    int? partId,
    int? currentValue,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => MainCounter(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    currentValue: currentValue ?? this.currentValue,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  MainCounter copyWithCompanion(MainCountersCompanion data) {
    return MainCounter(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MainCounter(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('currentValue: $currentValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, partId, currentValue, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MainCounter &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.currentValue == this.currentValue &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MainCountersCompanion extends UpdateCompanion<MainCounter> {
  final Value<int> id;
  final Value<int> partId;
  final Value<int> currentValue;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const MainCountersCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MainCountersCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    this.currentValue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : partId = Value(partId);
  static Insertable<MainCounter> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<int>? currentValue,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (currentValue != null) 'current_value': currentValue,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MainCountersCompanion copyWith({
    Value<int>? id,
    Value<int>? partId,
    Value<int>? currentValue,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return MainCountersCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      currentValue: currentValue ?? this.currentValue,
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
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<int>(currentValue.value);
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
    return (StringBuffer('MainCountersCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('currentValue: $currentValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StitchCountersTable extends StitchCounters
    with TableInfo<$StitchCountersTable, StitchCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StitchCountersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id) ON DELETE CASCADE',
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
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<int> currentValue = GeneratedColumn<int>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _countByMeta = const VerificationMeta(
    'countBy',
  );
  @override
  late final GeneratedColumn<int> countBy = GeneratedColumn<int>(
    'count_by',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    partId,
    name,
    currentValue,
    countBy,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stitch_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<StitchCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    }
    if (data.containsKey('count_by')) {
      context.handle(
        _countByMeta,
        countBy.isAcceptableOrUnknown(data['count_by']!, _countByMeta),
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
  StitchCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StitchCounter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_value'],
      )!,
      countBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count_by'],
      )!,
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
  $StitchCountersTable createAlias(String alias) {
    return $StitchCountersTable(attachedDatabase, alias);
  }
}

class StitchCounter extends DataClass implements Insertable<StitchCounter> {
  final int id;
  final int partId;
  final String name;
  final int currentValue;
  final int countBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const StitchCounter({
    required this.id,
    required this.partId,
    required this.name,
    required this.currentValue,
    required this.countBy,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['name'] = Variable<String>(name);
    map['current_value'] = Variable<int>(currentValue);
    map['count_by'] = Variable<int>(countBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  StitchCountersCompanion toCompanion(bool nullToAbsent) {
    return StitchCountersCompanion(
      id: Value(id),
      partId: Value(partId),
      name: Value(name),
      currentValue: Value(currentValue),
      countBy: Value(countBy),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory StitchCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StitchCounter(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      name: serializer.fromJson<String>(json['name']),
      currentValue: serializer.fromJson<int>(json['currentValue']),
      countBy: serializer.fromJson<int>(json['countBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'name': serializer.toJson<String>(name),
      'currentValue': serializer.toJson<int>(currentValue),
      'countBy': serializer.toJson<int>(countBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  StitchCounter copyWith({
    int? id,
    int? partId,
    String? name,
    int? currentValue,
    int? countBy,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => StitchCounter(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    name: name ?? this.name,
    currentValue: currentValue ?? this.currentValue,
    countBy: countBy ?? this.countBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  StitchCounter copyWithCompanion(StitchCountersCompanion data) {
    return StitchCounter(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      name: data.name.present ? data.name.value : this.name,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      countBy: data.countBy.present ? data.countBy.value : this.countBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StitchCounter(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('name: $name, ')
          ..write('currentValue: $currentValue, ')
          ..write('countBy: $countBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partId,
    name,
    currentValue,
    countBy,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StitchCounter &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.name == this.name &&
          other.currentValue == this.currentValue &&
          other.countBy == this.countBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StitchCountersCompanion extends UpdateCompanion<StitchCounter> {
  final Value<int> id;
  final Value<int> partId;
  final Value<String> name;
  final Value<int> currentValue;
  final Value<int> countBy;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const StitchCountersCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.name = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.countBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StitchCountersCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required String name,
    this.currentValue = const Value.absent(),
    this.countBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : partId = Value(partId),
       name = Value(name);
  static Insertable<StitchCounter> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<String>? name,
    Expression<int>? currentValue,
    Expression<int>? countBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (name != null) 'name': name,
      if (currentValue != null) 'current_value': currentValue,
      if (countBy != null) 'count_by': countBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StitchCountersCompanion copyWith({
    Value<int>? id,
    Value<int>? partId,
    Value<String>? name,
    Value<int>? currentValue,
    Value<int>? countBy,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return StitchCountersCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      name: name ?? this.name,
      currentValue: currentValue ?? this.currentValue,
      countBy: countBy ?? this.countBy,
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
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<int>(currentValue.value);
    }
    if (countBy.present) {
      map['count_by'] = Variable<int>(countBy.value);
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
    return (StringBuffer('StitchCountersCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('name: $name, ')
          ..write('currentValue: $currentValue, ')
          ..write('countBy: $countBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SectionCountersTable extends SectionCounters
    with TableInfo<$SectionCountersTable, SectionCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionCountersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id) ON DELETE CASCADE',
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
  static const VerificationMeta _specJsonMeta = const VerificationMeta(
    'specJson',
  );
  @override
  late final GeneratedColumn<String> specJson = GeneratedColumn<String>(
    'spec_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LinkState, String> linkState =
      GeneratedColumn<String>(
        'link_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('linked'),
      ).withConverter<LinkState>($SectionCountersTable.$converterlinkState);
  static const VerificationMeta _frozenMainAtMeta = const VerificationMeta(
    'frozenMainAt',
  );
  @override
  late final GeneratedColumn<int> frozenMainAt = GeneratedColumn<int>(
    'frozen_main_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    partId,
    name,
    specJson,
    linkState,
    frozenMainAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'section_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('spec_json')) {
      context.handle(
        _specJsonMeta,
        specJson.isAcceptableOrUnknown(data['spec_json']!, _specJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_specJsonMeta);
    }
    if (data.containsKey('frozen_main_at')) {
      context.handle(
        _frozenMainAtMeta,
        frozenMainAt.isAcceptableOrUnknown(
          data['frozen_main_at']!,
          _frozenMainAtMeta,
        ),
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
  SectionCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionCounter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      specJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spec_json'],
      )!,
      linkState: $SectionCountersTable.$converterlinkState.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}link_state'],
        )!,
      ),
      frozenMainAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frozen_main_at'],
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
  $SectionCountersTable createAlias(String alias) {
    return $SectionCountersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LinkState, String, String> $converterlinkState =
      const EnumNameConverter<LinkState>(LinkState.values);
}

class SectionCounter extends DataClass implements Insertable<SectionCounter> {
  final int id;
  final int partId;
  final String name;
  final String specJson;
  final LinkState linkState;
  final int? frozenMainAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const SectionCounter({
    required this.id,
    required this.partId,
    required this.name,
    required this.specJson,
    required this.linkState,
    this.frozenMainAt,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['name'] = Variable<String>(name);
    map['spec_json'] = Variable<String>(specJson);
    {
      map['link_state'] = Variable<String>(
        $SectionCountersTable.$converterlinkState.toSql(linkState),
      );
    }
    if (!nullToAbsent || frozenMainAt != null) {
      map['frozen_main_at'] = Variable<int>(frozenMainAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SectionCountersCompanion toCompanion(bool nullToAbsent) {
    return SectionCountersCompanion(
      id: Value(id),
      partId: Value(partId),
      name: Value(name),
      specJson: Value(specJson),
      linkState: Value(linkState),
      frozenMainAt: frozenMainAt == null && nullToAbsent
          ? const Value.absent()
          : Value(frozenMainAt),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory SectionCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionCounter(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      name: serializer.fromJson<String>(json['name']),
      specJson: serializer.fromJson<String>(json['specJson']),
      linkState: $SectionCountersTable.$converterlinkState.fromJson(
        serializer.fromJson<String>(json['linkState']),
      ),
      frozenMainAt: serializer.fromJson<int?>(json['frozenMainAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'name': serializer.toJson<String>(name),
      'specJson': serializer.toJson<String>(specJson),
      'linkState': serializer.toJson<String>(
        $SectionCountersTable.$converterlinkState.toJson(linkState),
      ),
      'frozenMainAt': serializer.toJson<int?>(frozenMainAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  SectionCounter copyWith({
    int? id,
    int? partId,
    String? name,
    String? specJson,
    LinkState? linkState,
    Value<int?> frozenMainAt = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => SectionCounter(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    name: name ?? this.name,
    specJson: specJson ?? this.specJson,
    linkState: linkState ?? this.linkState,
    frozenMainAt: frozenMainAt.present ? frozenMainAt.value : this.frozenMainAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  SectionCounter copyWithCompanion(SectionCountersCompanion data) {
    return SectionCounter(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      name: data.name.present ? data.name.value : this.name,
      specJson: data.specJson.present ? data.specJson.value : this.specJson,
      linkState: data.linkState.present ? data.linkState.value : this.linkState,
      frozenMainAt: data.frozenMainAt.present
          ? data.frozenMainAt.value
          : this.frozenMainAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionCounter(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('name: $name, ')
          ..write('specJson: $specJson, ')
          ..write('linkState: $linkState, ')
          ..write('frozenMainAt: $frozenMainAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partId,
    name,
    specJson,
    linkState,
    frozenMainAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionCounter &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.name == this.name &&
          other.specJson == this.specJson &&
          other.linkState == this.linkState &&
          other.frozenMainAt == this.frozenMainAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SectionCountersCompanion extends UpdateCompanion<SectionCounter> {
  final Value<int> id;
  final Value<int> partId;
  final Value<String> name;
  final Value<String> specJson;
  final Value<LinkState> linkState;
  final Value<int?> frozenMainAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const SectionCountersCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.name = const Value.absent(),
    this.specJson = const Value.absent(),
    this.linkState = const Value.absent(),
    this.frozenMainAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SectionCountersCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required String name,
    required String specJson,
    this.linkState = const Value.absent(),
    this.frozenMainAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : partId = Value(partId),
       name = Value(name),
       specJson = Value(specJson);
  static Insertable<SectionCounter> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<String>? name,
    Expression<String>? specJson,
    Expression<String>? linkState,
    Expression<int>? frozenMainAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (name != null) 'name': name,
      if (specJson != null) 'spec_json': specJson,
      if (linkState != null) 'link_state': linkState,
      if (frozenMainAt != null) 'frozen_main_at': frozenMainAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SectionCountersCompanion copyWith({
    Value<int>? id,
    Value<int>? partId,
    Value<String>? name,
    Value<String>? specJson,
    Value<LinkState>? linkState,
    Value<int?>? frozenMainAt,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return SectionCountersCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      name: name ?? this.name,
      specJson: specJson ?? this.specJson,
      linkState: linkState ?? this.linkState,
      frozenMainAt: frozenMainAt ?? this.frozenMainAt,
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
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (specJson.present) {
      map['spec_json'] = Variable<String>(specJson.value);
    }
    if (linkState.present) {
      map['link_state'] = Variable<String>(
        $SectionCountersTable.$converterlinkState.toSql(linkState.value),
      );
    }
    if (frozenMainAt.present) {
      map['frozen_main_at'] = Variable<int>(frozenMainAt.value);
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
    return (StringBuffer('SectionCountersCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('name: $name, ')
          ..write('specJson: $specJson, ')
          ..write('linkState: $linkState, ')
          ..write('frozenMainAt: $frozenMainAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SectionRunsTable extends SectionRuns
    with TableInfo<$SectionRunsTable, SectionRun> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionRunsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sectionCounterIdMeta = const VerificationMeta(
    'sectionCounterId',
  );
  @override
  late final GeneratedColumn<int> sectionCounterId = GeneratedColumn<int>(
    'section_counter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES section_counters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  @override
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
    'ord',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startRowMeta = const VerificationMeta(
    'startRow',
  );
  @override
  late final GeneratedColumn<int> startRow = GeneratedColumn<int>(
    'start_row',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowsTotalMeta = const VerificationMeta(
    'rowsTotal',
  );
  @override
  late final GeneratedColumn<int> rowsTotal = GeneratedColumn<int>(
    'rows_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  @override
  late final GeneratedColumnWithTypeConverter<RunState, String> state =
      GeneratedColumn<String>(
        'state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('scheduled'),
      ).withConverter<RunState>($SectionRunsTable.$converterstate);
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sectionCounterId,
    ord,
    startRow,
    rowsTotal,
    label,
    state,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'section_runs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionRun> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('section_counter_id')) {
      context.handle(
        _sectionCounterIdMeta,
        sectionCounterId.isAcceptableOrUnknown(
          data['section_counter_id']!,
          _sectionCounterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sectionCounterIdMeta);
    }
    if (data.containsKey('ord')) {
      context.handle(
        _ordMeta,
        ord.isAcceptableOrUnknown(data['ord']!, _ordMeta),
      );
    } else if (isInserting) {
      context.missing(_ordMeta);
    }
    if (data.containsKey('start_row')) {
      context.handle(
        _startRowMeta,
        startRow.isAcceptableOrUnknown(data['start_row']!, _startRowMeta),
      );
    } else if (isInserting) {
      context.missing(_startRowMeta);
    }
    if (data.containsKey('rows_total')) {
      context.handle(
        _rowsTotalMeta,
        rowsTotal.isAcceptableOrUnknown(data['rows_total']!, _rowsTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_rowsTotalMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SectionRun map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionRun(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sectionCounterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}section_counter_id'],
      )!,
      ord: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ord'],
      )!,
      startRow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_row'],
      )!,
      rowsTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rows_total'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      state: $SectionRunsTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SectionRunsTable createAlias(String alias) {
    return $SectionRunsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RunState, String, String> $converterstate =
      const EnumNameConverter<RunState>(RunState.values);
}

class SectionRun extends DataClass implements Insertable<SectionRun> {
  final int id;
  final int sectionCounterId;
  final int ord;
  final int startRow;
  final int rowsTotal;
  final String? label;
  final RunState state;
  final DateTime createdAt;
  const SectionRun({
    required this.id,
    required this.sectionCounterId,
    required this.ord,
    required this.startRow,
    required this.rowsTotal,
    this.label,
    required this.state,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['section_counter_id'] = Variable<int>(sectionCounterId);
    map['ord'] = Variable<int>(ord);
    map['start_row'] = Variable<int>(startRow);
    map['rows_total'] = Variable<int>(rowsTotal);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    {
      map['state'] = Variable<String>(
        $SectionRunsTable.$converterstate.toSql(state),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SectionRunsCompanion toCompanion(bool nullToAbsent) {
    return SectionRunsCompanion(
      id: Value(id),
      sectionCounterId: Value(sectionCounterId),
      ord: Value(ord),
      startRow: Value(startRow),
      rowsTotal: Value(rowsTotal),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      state: Value(state),
      createdAt: Value(createdAt),
    );
  }

  factory SectionRun.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionRun(
      id: serializer.fromJson<int>(json['id']),
      sectionCounterId: serializer.fromJson<int>(json['sectionCounterId']),
      ord: serializer.fromJson<int>(json['ord']),
      startRow: serializer.fromJson<int>(json['startRow']),
      rowsTotal: serializer.fromJson<int>(json['rowsTotal']),
      label: serializer.fromJson<String?>(json['label']),
      state: $SectionRunsTable.$converterstate.fromJson(
        serializer.fromJson<String>(json['state']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sectionCounterId': serializer.toJson<int>(sectionCounterId),
      'ord': serializer.toJson<int>(ord),
      'startRow': serializer.toJson<int>(startRow),
      'rowsTotal': serializer.toJson<int>(rowsTotal),
      'label': serializer.toJson<String?>(label),
      'state': serializer.toJson<String>(
        $SectionRunsTable.$converterstate.toJson(state),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SectionRun copyWith({
    int? id,
    int? sectionCounterId,
    int? ord,
    int? startRow,
    int? rowsTotal,
    Value<String?> label = const Value.absent(),
    RunState? state,
    DateTime? createdAt,
  }) => SectionRun(
    id: id ?? this.id,
    sectionCounterId: sectionCounterId ?? this.sectionCounterId,
    ord: ord ?? this.ord,
    startRow: startRow ?? this.startRow,
    rowsTotal: rowsTotal ?? this.rowsTotal,
    label: label.present ? label.value : this.label,
    state: state ?? this.state,
    createdAt: createdAt ?? this.createdAt,
  );
  SectionRun copyWithCompanion(SectionRunsCompanion data) {
    return SectionRun(
      id: data.id.present ? data.id.value : this.id,
      sectionCounterId: data.sectionCounterId.present
          ? data.sectionCounterId.value
          : this.sectionCounterId,
      ord: data.ord.present ? data.ord.value : this.ord,
      startRow: data.startRow.present ? data.startRow.value : this.startRow,
      rowsTotal: data.rowsTotal.present ? data.rowsTotal.value : this.rowsTotal,
      label: data.label.present ? data.label.value : this.label,
      state: data.state.present ? data.state.value : this.state,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionRun(')
          ..write('id: $id, ')
          ..write('sectionCounterId: $sectionCounterId, ')
          ..write('ord: $ord, ')
          ..write('startRow: $startRow, ')
          ..write('rowsTotal: $rowsTotal, ')
          ..write('label: $label, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sectionCounterId,
    ord,
    startRow,
    rowsTotal,
    label,
    state,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionRun &&
          other.id == this.id &&
          other.sectionCounterId == this.sectionCounterId &&
          other.ord == this.ord &&
          other.startRow == this.startRow &&
          other.rowsTotal == this.rowsTotal &&
          other.label == this.label &&
          other.state == this.state &&
          other.createdAt == this.createdAt);
}

class SectionRunsCompanion extends UpdateCompanion<SectionRun> {
  final Value<int> id;
  final Value<int> sectionCounterId;
  final Value<int> ord;
  final Value<int> startRow;
  final Value<int> rowsTotal;
  final Value<String?> label;
  final Value<RunState> state;
  final Value<DateTime> createdAt;
  const SectionRunsCompanion({
    this.id = const Value.absent(),
    this.sectionCounterId = const Value.absent(),
    this.ord = const Value.absent(),
    this.startRow = const Value.absent(),
    this.rowsTotal = const Value.absent(),
    this.label = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SectionRunsCompanion.insert({
    this.id = const Value.absent(),
    required int sectionCounterId,
    required int ord,
    required int startRow,
    required int rowsTotal,
    this.label = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sectionCounterId = Value(sectionCounterId),
       ord = Value(ord),
       startRow = Value(startRow),
       rowsTotal = Value(rowsTotal);
  static Insertable<SectionRun> custom({
    Expression<int>? id,
    Expression<int>? sectionCounterId,
    Expression<int>? ord,
    Expression<int>? startRow,
    Expression<int>? rowsTotal,
    Expression<String>? label,
    Expression<String>? state,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sectionCounterId != null) 'section_counter_id': sectionCounterId,
      if (ord != null) 'ord': ord,
      if (startRow != null) 'start_row': startRow,
      if (rowsTotal != null) 'rows_total': rowsTotal,
      if (label != null) 'label': label,
      if (state != null) 'state': state,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SectionRunsCompanion copyWith({
    Value<int>? id,
    Value<int>? sectionCounterId,
    Value<int>? ord,
    Value<int>? startRow,
    Value<int>? rowsTotal,
    Value<String?>? label,
    Value<RunState>? state,
    Value<DateTime>? createdAt,
  }) {
    return SectionRunsCompanion(
      id: id ?? this.id,
      sectionCounterId: sectionCounterId ?? this.sectionCounterId,
      ord: ord ?? this.ord,
      startRow: startRow ?? this.startRow,
      rowsTotal: rowsTotal ?? this.rowsTotal,
      label: label ?? this.label,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sectionCounterId.present) {
      map['section_counter_id'] = Variable<int>(sectionCounterId.value);
    }
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    if (startRow.present) {
      map['start_row'] = Variable<int>(startRow.value);
    }
    if (rowsTotal.present) {
      map['rows_total'] = Variable<int>(rowsTotal.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $SectionRunsTable.$converterstate.toSql(state.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionRunsCompanion(')
          ..write('id: $id, ')
          ..write('sectionCounterId: $sectionCounterId, ')
          ..write('ord: $ord, ')
          ..write('startRow: $startRow, ')
          ..write('rowsTotal: $rowsTotal, ')
          ..write('label: $label, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalDurationSecondsMeta =
      const VerificationMeta('totalDurationSeconds');
  @override
  late final GeneratedColumn<int> totalDurationSeconds = GeneratedColumn<int>(
    'total_duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus2, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(SessionStatus2.running.index),
      ).withConverter<SessionStatus2>($SessionsTable.$converterstatus);
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
    partId,
    startedAt,
    totalDurationSeconds,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('total_duration_seconds')) {
      context.handle(
        _totalDurationSecondsMeta,
        totalDurationSeconds.isAcceptableOrUnknown(
          data['total_duration_seconds']!,
          _totalDurationSecondsMeta,
        ),
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
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      totalDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_duration_seconds'],
      )!,
      status: $SessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
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
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SessionStatus2, int, int> $converterstatus =
      const EnumIndexConverter<SessionStatus2>(SessionStatus2.values);
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int partId;
  final DateTime startedAt;
  final int totalDurationSeconds;
  final SessionStatus2 status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Session({
    required this.id,
    required this.partId,
    required this.startedAt,
    required this.totalDurationSeconds,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['total_duration_seconds'] = Variable<int>(totalDurationSeconds);
    {
      map['status'] = Variable<int>(
        $SessionsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      partId: Value(partId),
      startedAt: Value(startedAt),
      totalDurationSeconds: Value(totalDurationSeconds),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      totalDurationSeconds: serializer.fromJson<int>(
        json['totalDurationSeconds'],
      ),
      status: $SessionsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'totalDurationSeconds': serializer.toJson<int>(totalDurationSeconds),
      'status': serializer.toJson<int>(
        $SessionsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Session copyWith({
    int? id,
    int? partId,
    DateTime? startedAt,
    int? totalDurationSeconds,
    SessionStatus2? status,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    startedAt: startedAt ?? this.startedAt,
    totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      totalDurationSeconds: data.totalDurationSeconds.present
          ? data.totalDurationSeconds.value
          : this.totalDurationSeconds,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('startedAt: $startedAt, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    partId,
    startedAt,
    totalDurationSeconds,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.startedAt == this.startedAt &&
          other.totalDurationSeconds == this.totalDurationSeconds &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> partId;
  final Value<DateTime> startedAt;
  final Value<int> totalDurationSeconds;
  final Value<SessionStatus2> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.totalDurationSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required DateTime startedAt,
    this.totalDurationSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : partId = Value(partId),
       startedAt = Value(startedAt);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<DateTime>? startedAt,
    Expression<int>? totalDurationSeconds,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (startedAt != null) 'started_at': startedAt,
      if (totalDurationSeconds != null)
        'total_duration_seconds': totalDurationSeconds,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? partId,
    Value<DateTime>? startedAt,
    Value<int>? totalDurationSeconds,
    Value<SessionStatus2>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      startedAt: startedAt ?? this.startedAt,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      status: status ?? this.status,
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
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (totalDurationSeconds.present) {
      map['total_duration_seconds'] = Variable<int>(totalDurationSeconds.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $SessionsTable.$converterstatus.toSql(status.value),
      );
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
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('startedAt: $startedAt, ')
          ..write('totalDurationSeconds: $totalDurationSeconds, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SessionSegmentsTable extends SessionSegments
    with TableInfo<$SessionSegmentsTable, SessionSegment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionSegmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startCountMeta = const VerificationMeta(
    'startCount',
  );
  @override
  late final GeneratedColumn<int> startCount = GeneratedColumn<int>(
    'start_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endCountMeta = const VerificationMeta(
    'endCount',
  );
  @override
  late final GeneratedColumn<int> endCount = GeneratedColumn<int>(
    'end_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SegmentReason?, String> reason =
      GeneratedColumn<String>(
        'reason',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<SegmentReason?>($SessionSegmentsTable.$converterreasonn);
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    partId,
    startedAt,
    endedAt,
    durationSeconds,
    startCount,
    endCount,
    reason,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_segments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionSegment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('start_count')) {
      context.handle(
        _startCountMeta,
        startCount.isAcceptableOrUnknown(data['start_count']!, _startCountMeta),
      );
    }
    if (data.containsKey('end_count')) {
      context.handle(
        _endCountMeta,
        endCount.isAcceptableOrUnknown(data['end_count']!, _endCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionSegment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionSegment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      startCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_count'],
      ),
      endCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_count'],
      ),
      reason: $SessionSegmentsTable.$converterreasonn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}reason'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SessionSegmentsTable createAlias(String alias) {
    return $SessionSegmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SegmentReason, String, String> $converterreason =
      const EnumNameConverter<SegmentReason>(SegmentReason.values);
  static JsonTypeConverter2<SegmentReason?, String?, String?>
  $converterreasonn = JsonTypeConverter2.asNullable($converterreason);
}

class SessionSegment extends DataClass implements Insertable<SessionSegment> {
  final int id;
  final int sessionId;
  final int partId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final int? startCount;
  final int? endCount;
  final SegmentReason? reason;
  final DateTime createdAt;
  const SessionSegment({
    required this.id,
    required this.sessionId,
    required this.partId,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.startCount,
    this.endCount,
    this.reason,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['part_id'] = Variable<int>(partId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || startCount != null) {
      map['start_count'] = Variable<int>(startCount);
    }
    if (!nullToAbsent || endCount != null) {
      map['end_count'] = Variable<int>(endCount);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(
        $SessionSegmentsTable.$converterreasonn.toSql(reason),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SessionSegmentsCompanion toCompanion(bool nullToAbsent) {
    return SessionSegmentsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      partId: Value(partId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      startCount: startCount == null && nullToAbsent
          ? const Value.absent()
          : Value(startCount),
      endCount: endCount == null && nullToAbsent
          ? const Value.absent()
          : Value(endCount),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory SessionSegment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionSegment(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      partId: serializer.fromJson<int>(json['partId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      startCount: serializer.fromJson<int?>(json['startCount']),
      endCount: serializer.fromJson<int?>(json['endCount']),
      reason: $SessionSegmentsTable.$converterreasonn.fromJson(
        serializer.fromJson<String?>(json['reason']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'partId': serializer.toJson<int>(partId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'startCount': serializer.toJson<int?>(startCount),
      'endCount': serializer.toJson<int?>(endCount),
      'reason': serializer.toJson<String?>(
        $SessionSegmentsTable.$converterreasonn.toJson(reason),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SessionSegment copyWith({
    int? id,
    int? sessionId,
    int? partId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<int?> startCount = const Value.absent(),
    Value<int?> endCount = const Value.absent(),
    Value<SegmentReason?> reason = const Value.absent(),
    DateTime? createdAt,
  }) => SessionSegment(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    partId: partId ?? this.partId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    startCount: startCount.present ? startCount.value : this.startCount,
    endCount: endCount.present ? endCount.value : this.endCount,
    reason: reason.present ? reason.value : this.reason,
    createdAt: createdAt ?? this.createdAt,
  );
  SessionSegment copyWithCompanion(SessionSegmentsCompanion data) {
    return SessionSegment(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      partId: data.partId.present ? data.partId.value : this.partId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      startCount: data.startCount.present
          ? data.startCount.value
          : this.startCount,
      endCount: data.endCount.present ? data.endCount.value : this.endCount,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionSegment(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('partId: $partId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('startCount: $startCount, ')
          ..write('endCount: $endCount, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    partId,
    startedAt,
    endedAt,
    durationSeconds,
    startCount,
    endCount,
    reason,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionSegment &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.partId == this.partId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.startCount == this.startCount &&
          other.endCount == this.endCount &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class SessionSegmentsCompanion extends UpdateCompanion<SessionSegment> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<int> partId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int?> durationSeconds;
  final Value<int?> startCount;
  final Value<int?> endCount;
  final Value<SegmentReason?> reason;
  final Value<DateTime> createdAt;
  const SessionSegmentsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.partId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.startCount = const Value.absent(),
    this.endCount = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SessionSegmentsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required int partId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.startCount = const Value.absent(),
    this.endCount = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       partId = Value(partId),
       startedAt = Value(startedAt);
  static Insertable<SessionSegment> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<int>? partId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<int>? startCount,
    Expression<int>? endCount,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (partId != null) 'part_id': partId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (startCount != null) 'start_count': startCount,
      if (endCount != null) 'end_count': endCount,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SessionSegmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<int>? partId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int?>? durationSeconds,
    Value<int?>? startCount,
    Value<int?>? endCount,
    Value<SegmentReason?>? reason,
    Value<DateTime>? createdAt,
  }) {
    return SessionSegmentsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      partId: partId ?? this.partId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      startCount: startCount ?? this.startCount,
      endCount: endCount ?? this.endCount,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (startCount.present) {
      map['start_count'] = Variable<int>(startCount.value);
    }
    if (endCount.present) {
      map['end_count'] = Variable<int>(endCount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(
        $SessionSegmentsTable.$converterreasonn.toSql(reason.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionSegmentsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('partId: $partId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('startCount: $startCount, ')
          ..write('endCount: $endCount, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PartNotesTable extends PartNotes
    with TableInfo<$PartNotesTable, PartNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  @override
  late final GeneratedColumn<int> partId = GeneratedColumn<int>(
    'part_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    partId,
    content,
    isPinned,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'part_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    } else if (isInserting) {
      context.missing(_partIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
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
  PartNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}part_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
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
  $PartNotesTable createAlias(String alias) {
    return $PartNotesTable(attachedDatabase, alias);
  }
}

class PartNote extends DataClass implements Insertable<PartNote> {
  final int id;
  final int partId;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const PartNote({
    required this.id,
    required this.partId,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['part_id'] = Variable<int>(partId);
    map['content'] = Variable<String>(content);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PartNotesCompanion toCompanion(bool nullToAbsent) {
    return PartNotesCompanion(
      id: Value(id),
      partId: Value(partId),
      content: Value(content),
      isPinned: Value(isPinned),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PartNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartNote(
      id: serializer.fromJson<int>(json['id']),
      partId: serializer.fromJson<int>(json['partId']),
      content: serializer.fromJson<String>(json['content']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'partId': serializer.toJson<int>(partId),
      'content': serializer.toJson<String>(content),
      'isPinned': serializer.toJson<bool>(isPinned),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PartNote copyWith({
    int? id,
    int? partId,
    String? content,
    bool? isPinned,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => PartNote(
    id: id ?? this.id,
    partId: partId ?? this.partId,
    content: content ?? this.content,
    isPinned: isPinned ?? this.isPinned,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  PartNote copyWithCompanion(PartNotesCompanion data) {
    return PartNote(
      id: data.id.present ? data.id.value : this.id,
      partId: data.partId.present ? data.partId.value : this.partId,
      content: data.content.present ? data.content.value : this.content,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartNote(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('content: $content, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, partId, content, isPinned, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartNote &&
          other.id == this.id &&
          other.partId == this.partId &&
          other.content == this.content &&
          other.isPinned == this.isPinned &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PartNotesCompanion extends UpdateCompanion<PartNote> {
  final Value<int> id;
  final Value<int> partId;
  final Value<String> content;
  final Value<bool> isPinned;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PartNotesCompanion({
    this.id = const Value.absent(),
    this.partId = const Value.absent(),
    this.content = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PartNotesCompanion.insert({
    this.id = const Value.absent(),
    required int partId,
    required String content,
    this.isPinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : partId = Value(partId),
       content = Value(content);
  static Insertable<PartNote> custom({
    Expression<int>? id,
    Expression<int>? partId,
    Expression<String>? content,
    Expression<bool>? isPinned,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (partId != null) 'part_id': partId,
      if (content != null) 'content': content,
      if (isPinned != null) 'is_pinned': isPinned,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PartNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? partId,
    Value<String>? content,
    Value<bool>? isPinned,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return PartNotesCompanion(
      id: id ?? this.id,
      partId: partId ?? this.partId,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
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
    if (partId.present) {
      map['part_id'] = Variable<int>(partId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
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
    return (StringBuffer('PartNotesCompanion(')
          ..write('id: $id, ')
          ..write('partId: $partId, ')
          ..write('content: $content, ')
          ..write('isPinned: $isPinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, name, color, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
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
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
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
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
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
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final int color;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
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
      'color': serializer.toJson<int>(color),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Tag copyWith({
    int? id,
    String? name,
    int? color,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int color,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       color = Value(color);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? color,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
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
    if (color.present) {
      map['color'] = Variable<int>(color.value);
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
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
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

class $ProjectCountersTable extends ProjectCounters
    with TableInfo<$ProjectCountersTable, ProjectCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mainCounterMeta = const VerificationMeta(
    'mainCounter',
  );
  @override
  late final GeneratedColumn<int> mainCounter = GeneratedColumn<int>(
    'main_counter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _mainCountByMeta = const VerificationMeta(
    'mainCountBy',
  );
  @override
  late final GeneratedColumn<int> mainCountBy = GeneratedColumn<int>(
    'main_count_by',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _subCounterMeta = const VerificationMeta(
    'subCounter',
  );
  @override
  late final GeneratedColumn<int> subCounter = GeneratedColumn<int>(
    'sub_counter',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subCountByMeta = const VerificationMeta(
    'subCountBy',
  );
  @override
  late final GeneratedColumn<int> subCountBy = GeneratedColumn<int>(
    'sub_count_by',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _hasSubCounterMeta = const VerificationMeta(
    'hasSubCounter',
  );
  @override
  late final GeneratedColumn<bool> hasSubCounter = GeneratedColumn<bool>(
    'has_sub_counter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_sub_counter" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    projectId,
    mainCounter,
    mainCountBy,
    subCounter,
    subCountBy,
    hasSubCounter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('main_counter')) {
      context.handle(
        _mainCounterMeta,
        mainCounter.isAcceptableOrUnknown(
          data['main_counter']!,
          _mainCounterMeta,
        ),
      );
    }
    if (data.containsKey('main_count_by')) {
      context.handle(
        _mainCountByMeta,
        mainCountBy.isAcceptableOrUnknown(
          data['main_count_by']!,
          _mainCountByMeta,
        ),
      );
    }
    if (data.containsKey('sub_counter')) {
      context.handle(
        _subCounterMeta,
        subCounter.isAcceptableOrUnknown(data['sub_counter']!, _subCounterMeta),
      );
    }
    if (data.containsKey('sub_count_by')) {
      context.handle(
        _subCountByMeta,
        subCountBy.isAcceptableOrUnknown(
          data['sub_count_by']!,
          _subCountByMeta,
        ),
      );
    }
    if (data.containsKey('has_sub_counter')) {
      context.handle(
        _hasSubCounterMeta,
        hasSubCounter.isAcceptableOrUnknown(
          data['has_sub_counter']!,
          _hasSubCounterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {projectId};
  @override
  ProjectCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectCounter(
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      mainCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}main_counter'],
      )!,
      mainCountBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}main_count_by'],
      )!,
      subCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sub_counter'],
      ),
      subCountBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sub_count_by'],
      )!,
      hasSubCounter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_sub_counter'],
      )!,
    );
  }

  @override
  $ProjectCountersTable createAlias(String alias) {
    return $ProjectCountersTable(attachedDatabase, alias);
  }
}

class ProjectCounter extends DataClass implements Insertable<ProjectCounter> {
  final int projectId;
  final int mainCounter;
  final int mainCountBy;
  final int? subCounter;
  final int subCountBy;
  final bool hasSubCounter;
  const ProjectCounter({
    required this.projectId,
    required this.mainCounter,
    required this.mainCountBy,
    this.subCounter,
    required this.subCountBy,
    required this.hasSubCounter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['project_id'] = Variable<int>(projectId);
    map['main_counter'] = Variable<int>(mainCounter);
    map['main_count_by'] = Variable<int>(mainCountBy);
    if (!nullToAbsent || subCounter != null) {
      map['sub_counter'] = Variable<int>(subCounter);
    }
    map['sub_count_by'] = Variable<int>(subCountBy);
    map['has_sub_counter'] = Variable<bool>(hasSubCounter);
    return map;
  }

  ProjectCountersCompanion toCompanion(bool nullToAbsent) {
    return ProjectCountersCompanion(
      projectId: Value(projectId),
      mainCounter: Value(mainCounter),
      mainCountBy: Value(mainCountBy),
      subCounter: subCounter == null && nullToAbsent
          ? const Value.absent()
          : Value(subCounter),
      subCountBy: Value(subCountBy),
      hasSubCounter: Value(hasSubCounter),
    );
  }

  factory ProjectCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectCounter(
      projectId: serializer.fromJson<int>(json['projectId']),
      mainCounter: serializer.fromJson<int>(json['mainCounter']),
      mainCountBy: serializer.fromJson<int>(json['mainCountBy']),
      subCounter: serializer.fromJson<int?>(json['subCounter']),
      subCountBy: serializer.fromJson<int>(json['subCountBy']),
      hasSubCounter: serializer.fromJson<bool>(json['hasSubCounter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'projectId': serializer.toJson<int>(projectId),
      'mainCounter': serializer.toJson<int>(mainCounter),
      'mainCountBy': serializer.toJson<int>(mainCountBy),
      'subCounter': serializer.toJson<int?>(subCounter),
      'subCountBy': serializer.toJson<int>(subCountBy),
      'hasSubCounter': serializer.toJson<bool>(hasSubCounter),
    };
  }

  ProjectCounter copyWith({
    int? projectId,
    int? mainCounter,
    int? mainCountBy,
    Value<int?> subCounter = const Value.absent(),
    int? subCountBy,
    bool? hasSubCounter,
  }) => ProjectCounter(
    projectId: projectId ?? this.projectId,
    mainCounter: mainCounter ?? this.mainCounter,
    mainCountBy: mainCountBy ?? this.mainCountBy,
    subCounter: subCounter.present ? subCounter.value : this.subCounter,
    subCountBy: subCountBy ?? this.subCountBy,
    hasSubCounter: hasSubCounter ?? this.hasSubCounter,
  );
  ProjectCounter copyWithCompanion(ProjectCountersCompanion data) {
    return ProjectCounter(
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      mainCounter: data.mainCounter.present
          ? data.mainCounter.value
          : this.mainCounter,
      mainCountBy: data.mainCountBy.present
          ? data.mainCountBy.value
          : this.mainCountBy,
      subCounter: data.subCounter.present
          ? data.subCounter.value
          : this.subCounter,
      subCountBy: data.subCountBy.present
          ? data.subCountBy.value
          : this.subCountBy,
      hasSubCounter: data.hasSubCounter.present
          ? data.hasSubCounter.value
          : this.hasSubCounter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectCounter(')
          ..write('projectId: $projectId, ')
          ..write('mainCounter: $mainCounter, ')
          ..write('mainCountBy: $mainCountBy, ')
          ..write('subCounter: $subCounter, ')
          ..write('subCountBy: $subCountBy, ')
          ..write('hasSubCounter: $hasSubCounter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    projectId,
    mainCounter,
    mainCountBy,
    subCounter,
    subCountBy,
    hasSubCounter,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectCounter &&
          other.projectId == this.projectId &&
          other.mainCounter == this.mainCounter &&
          other.mainCountBy == this.mainCountBy &&
          other.subCounter == this.subCounter &&
          other.subCountBy == this.subCountBy &&
          other.hasSubCounter == this.hasSubCounter);
}

class ProjectCountersCompanion extends UpdateCompanion<ProjectCounter> {
  final Value<int> projectId;
  final Value<int> mainCounter;
  final Value<int> mainCountBy;
  final Value<int?> subCounter;
  final Value<int> subCountBy;
  final Value<bool> hasSubCounter;
  const ProjectCountersCompanion({
    this.projectId = const Value.absent(),
    this.mainCounter = const Value.absent(),
    this.mainCountBy = const Value.absent(),
    this.subCounter = const Value.absent(),
    this.subCountBy = const Value.absent(),
    this.hasSubCounter = const Value.absent(),
  });
  ProjectCountersCompanion.insert({
    this.projectId = const Value.absent(),
    this.mainCounter = const Value.absent(),
    this.mainCountBy = const Value.absent(),
    this.subCounter = const Value.absent(),
    this.subCountBy = const Value.absent(),
    this.hasSubCounter = const Value.absent(),
  });
  static Insertable<ProjectCounter> custom({
    Expression<int>? projectId,
    Expression<int>? mainCounter,
    Expression<int>? mainCountBy,
    Expression<int>? subCounter,
    Expression<int>? subCountBy,
    Expression<bool>? hasSubCounter,
  }) {
    return RawValuesInsertable({
      if (projectId != null) 'project_id': projectId,
      if (mainCounter != null) 'main_counter': mainCounter,
      if (mainCountBy != null) 'main_count_by': mainCountBy,
      if (subCounter != null) 'sub_counter': subCounter,
      if (subCountBy != null) 'sub_count_by': subCountBy,
      if (hasSubCounter != null) 'has_sub_counter': hasSubCounter,
    });
  }

  ProjectCountersCompanion copyWith({
    Value<int>? projectId,
    Value<int>? mainCounter,
    Value<int>? mainCountBy,
    Value<int?>? subCounter,
    Value<int>? subCountBy,
    Value<bool>? hasSubCounter,
  }) {
    return ProjectCountersCompanion(
      projectId: projectId ?? this.projectId,
      mainCounter: mainCounter ?? this.mainCounter,
      mainCountBy: mainCountBy ?? this.mainCountBy,
      subCounter: subCounter ?? this.subCounter,
      subCountBy: subCountBy ?? this.subCountBy,
      hasSubCounter: hasSubCounter ?? this.hasSubCounter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (mainCounter.present) {
      map['main_counter'] = Variable<int>(mainCounter.value);
    }
    if (mainCountBy.present) {
      map['main_count_by'] = Variable<int>(mainCountBy.value);
    }
    if (subCounter.present) {
      map['sub_counter'] = Variable<int>(subCounter.value);
    }
    if (subCountBy.present) {
      map['sub_count_by'] = Variable<int>(subCountBy.value);
    }
    if (hasSubCounter.present) {
      map['has_sub_counter'] = Variable<bool>(hasSubCounter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectCountersCompanion(')
          ..write('projectId: $projectId, ')
          ..write('mainCounter: $mainCounter, ')
          ..write('mainCountBy: $mainCountBy, ')
          ..write('subCounter: $subCounter, ')
          ..write('subCountBy: $subCountBy, ')
          ..write('hasSubCounter: $hasSubCounter')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $PartsTable parts = $PartsTable(this);
  late final $MainCountersTable mainCounters = $MainCountersTable(this);
  late final $StitchCountersTable stitchCounters = $StitchCountersTable(this);
  late final $SectionCountersTable sectionCounters = $SectionCountersTable(
    this,
  );
  late final $SectionRunsTable sectionRuns = $SectionRunsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionSegmentsTable sessionSegments = $SessionSegmentsTable(
    this,
  );
  late final $PartNotesTable partNotes = $PartNotesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $WorkSessionsTable workSessions = $WorkSessionsTable(this);
  late final $ProjectCountersTable projectCounters = $ProjectCountersTable(
    this,
  );
  late final Index partsProjectOrder = Index(
    'parts_project_order',
    'CREATE INDEX parts_project_order ON parts (project_id, order_index)',
  );
  late final Index mainCountersPartId = Index(
    'main_counters_part_id',
    'CREATE INDEX main_counters_part_id ON main_counters (part_id)',
  );
  late final Index stitchCountersPartId = Index(
    'stitch_counters_part_id',
    'CREATE INDEX stitch_counters_part_id ON stitch_counters (part_id)',
  );
  late final Index sectionCountersPartId = Index(
    'section_counters_part_id',
    'CREATE INDEX section_counters_part_id ON section_counters (part_id)',
  );
  late final Index sectionCountersPartLink = Index(
    'section_counters_part_link',
    'CREATE INDEX section_counters_part_link ON section_counters (part_id, link_state)',
  );
  late final Index sectionRunsCounterOrd = Index(
    'section_runs_counter_ord',
    'CREATE INDEX section_runs_counter_ord ON section_runs (section_counter_id, ord)',
  );
  late final Index sectionRunsCounterState = Index(
    'section_runs_counter_state',
    'CREATE INDEX section_runs_counter_state ON section_runs (section_counter_id, state)',
  );
  late final Index sessionsPartId = Index(
    'sessions_part_id',
    'CREATE INDEX sessions_part_id ON sessions (part_id)',
  );
  late final Index sessionsStartedAt = Index(
    'sessions_started_at',
    'CREATE INDEX sessions_started_at ON sessions (started_at)',
  );
  late final Index sessionSegmentsSessionId = Index(
    'session_segments_session_id',
    'CREATE INDEX session_segments_session_id ON session_segments (session_id)',
  );
  late final Index sessionSegmentsPartStarted = Index(
    'session_segments_part_started',
    'CREATE INDEX session_segments_part_started ON session_segments (part_id, started_at)',
  );
  late final Index sessionSegmentsStartedAt = Index(
    'session_segments_started_at',
    'CREATE INDEX session_segments_started_at ON session_segments (started_at)',
  );
  late final Index partNotesPartPinnedCreated = Index(
    'part_notes_part_pinned_created',
    'CREATE INDEX part_notes_part_pinned_created ON part_notes (part_id, is_pinned, created_at)',
  );
  late final Index tagsName = Index(
    'tags_name',
    'CREATE UNIQUE INDEX tags_name ON tags (name)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    parts,
    mainCounters,
    stitchCounters,
    sectionCounters,
    sectionRuns,
    sessions,
    sessionSegments,
    partNotes,
    tags,
    workSessions,
    projectCounters,
    partsProjectOrder,
    mainCountersPartId,
    stitchCountersPartId,
    sectionCountersPartId,
    sectionCountersPartLink,
    sectionRunsCounterOrd,
    sectionRunsCounterState,
    sessionsPartId,
    sessionsStartedAt,
    sessionSegmentsSessionId,
    sessionSegmentsPartStarted,
    sessionSegmentsStartedAt,
    partNotesPartPinnedCreated,
    tagsName,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('parts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('main_counters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('stitch_counters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('section_counters', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'section_counters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('section_runs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_segments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_segments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'parts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('part_notes', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> needleType,
      Value<String?> needleSize,
      Value<String?> lotNumber,
      Value<String?> memo,
      Value<int?> currentPartId,
      Value<String?> imagePath,
      Value<String?> tagIds,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> needleType,
      Value<String?> needleSize,
      Value<String?> lotNumber,
      Value<String?> memo,
      Value<int?> currentPartId,
      Value<String?> imagePath,
      Value<String?> tagIds,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDb, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PartsTable, List<Part>> _partsRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.parts,
    aliasName: $_aliasNameGenerator(db.projects.id, db.parts.projectId),
  );

  $$PartsTableProcessedTableManager get partsRefs {
    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get currentPartId => $composableBuilder(
    column: $table.currentPartId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagIds => $composableBuilder(
    column: $table.tagIds,
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

  Expression<bool> partsRefs(
    Expression<bool> Function($$PartsTableFilterComposer f) f,
  ) {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get currentPartId => $composableBuilder(
    column: $table.currentPartId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagIds => $composableBuilder(
    column: $table.tagIds,
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

  GeneratedColumn<int> get currentPartId => $composableBuilder(
    column: $table.currentPartId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get tagIds =>
      $composableBuilder(column: $table.tagIds, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> partsRefs<T extends Object>(
    Expression<T> Function($$PartsTableAnnotationComposer a) f,
  ) {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool partsRefs})
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
                Value<String?> needleType = const Value.absent(),
                Value<String?> needleSize = const Value.absent(),
                Value<String?> lotNumber = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int?> currentPartId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> tagIds = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                needleType: needleType,
                needleSize: needleSize,
                lotNumber: lotNumber,
                memo: memo,
                currentPartId: currentPartId,
                imagePath: imagePath,
                tagIds: tagIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> needleType = const Value.absent(),
                Value<String?> needleSize = const Value.absent(),
                Value<String?> lotNumber = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int?> currentPartId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String?> tagIds = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                needleType: needleType,
                needleSize: needleSize,
                lotNumber: lotNumber,
                memo: memo,
                currentPartId: currentPartId,
                imagePath: imagePath,
                tagIds: tagIds,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (partsRefs) db.parts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (partsRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable, Part>(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._partsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProjectsTableReferences(db, table, p0).partsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool partsRefs})
    >;
typedef $$PartsTableCreateCompanionBuilder =
    PartsCompanion Function({
      Value<int> id,
      required int projectId,
      required String name,
      required int orderIndex,
      Value<String?> buddyCounterOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$PartsTableUpdateCompanionBuilder =
    PartsCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<String> name,
      Value<int> orderIndex,
      Value<String?> buddyCounterOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$PartsTableReferences
    extends BaseReferences<_$AppDb, $PartsTable, Part> {
  $$PartsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDb db) => db.projects.createAlias(
    $_aliasNameGenerator(db.parts.projectId, db.projects.id),
  );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MainCountersTable, List<MainCounter>>
  _mainCountersRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.mainCounters,
    aliasName: $_aliasNameGenerator(db.parts.id, db.mainCounters.partId),
  );

  $$MainCountersTableProcessedTableManager get mainCountersRefs {
    final manager = $$MainCountersTableTableManager(
      $_db,
      $_db.mainCounters,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mainCountersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StitchCountersTable, List<StitchCounter>>
  _stitchCountersRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.stitchCounters,
    aliasName: $_aliasNameGenerator(db.parts.id, db.stitchCounters.partId),
  );

  $$StitchCountersTableProcessedTableManager get stitchCountersRefs {
    final manager = $$StitchCountersTableTableManager(
      $_db,
      $_db.stitchCounters,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_stitchCountersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SectionCountersTable, List<SectionCounter>>
  _sectionCountersRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.sectionCounters,
    aliasName: $_aliasNameGenerator(db.parts.id, db.sectionCounters.partId),
  );

  $$SectionCountersTableProcessedTableManager get sectionCountersRefs {
    final manager = $$SectionCountersTableTableManager(
      $_db,
      $_db.sectionCounters,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sectionCountersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: $_aliasNameGenerator(db.parts.id, db.sessions.partId),
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionSegmentsTable, List<SessionSegment>>
  _sessionSegmentsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.sessionSegments,
    aliasName: $_aliasNameGenerator(db.parts.id, db.sessionSegments.partId),
  );

  $$SessionSegmentsTableProcessedTableManager get sessionSegmentsRefs {
    final manager = $$SessionSegmentsTableTableManager(
      $_db,
      $_db.sessionSegments,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionSegmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartNotesTable, List<PartNote>>
  _partNotesRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.partNotes,
    aliasName: $_aliasNameGenerator(db.parts.id, db.partNotes.partId),
  );

  $$PartNotesTableProcessedTableManager get partNotesRefs {
    final manager = $$PartNotesTableTableManager(
      $_db,
      $_db.partNotes,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_partNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PartsTableFilterComposer extends Composer<_$AppDb, $PartsTable> {
  $$PartsTableFilterComposer({
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

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buddyCounterOrder => $composableBuilder(
    column: $table.buddyCounterOrder,
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

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mainCountersRefs(
    Expression<bool> Function($$MainCountersTableFilterComposer f) f,
  ) {
    final $$MainCountersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mainCounters,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MainCountersTableFilterComposer(
            $db: $db,
            $table: $db.mainCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stitchCountersRefs(
    Expression<bool> Function($$StitchCountersTableFilterComposer f) f,
  ) {
    final $$StitchCountersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stitchCounters,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StitchCountersTableFilterComposer(
            $db: $db,
            $table: $db.stitchCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sectionCountersRefs(
    Expression<bool> Function($$SectionCountersTableFilterComposer f) f,
  ) {
    final $$SectionCountersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectionCounters,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionCountersTableFilterComposer(
            $db: $db,
            $table: $db.sectionCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionSegmentsRefs(
    Expression<bool> Function($$SessionSegmentsTableFilterComposer f) f,
  ) {
    final $$SessionSegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionSegments,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionSegmentsTableFilterComposer(
            $db: $db,
            $table: $db.sessionSegments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partNotesRefs(
    Expression<bool> Function($$PartNotesTableFilterComposer f) f,
  ) {
    final $$PartNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partNotes,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartNotesTableFilterComposer(
            $db: $db,
            $table: $db.partNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartsTableOrderingComposer extends Composer<_$AppDb, $PartsTable> {
  $$PartsTableOrderingComposer({
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

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buddyCounterOrder => $composableBuilder(
    column: $table.buddyCounterOrder,
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

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartsTableAnnotationComposer extends Composer<_$AppDb, $PartsTable> {
  $$PartsTableAnnotationComposer({
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

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get buddyCounterOrder => $composableBuilder(
    column: $table.buddyCounterOrder,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mainCountersRefs<T extends Object>(
    Expression<T> Function($$MainCountersTableAnnotationComposer a) f,
  ) {
    final $$MainCountersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mainCounters,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MainCountersTableAnnotationComposer(
            $db: $db,
            $table: $db.mainCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stitchCountersRefs<T extends Object>(
    Expression<T> Function($$StitchCountersTableAnnotationComposer a) f,
  ) {
    final $$StitchCountersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stitchCounters,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StitchCountersTableAnnotationComposer(
            $db: $db,
            $table: $db.stitchCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sectionCountersRefs<T extends Object>(
    Expression<T> Function($$SectionCountersTableAnnotationComposer a) f,
  ) {
    final $$SectionCountersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectionCounters,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionCountersTableAnnotationComposer(
            $db: $db,
            $table: $db.sectionCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionSegmentsRefs<T extends Object>(
    Expression<T> Function($$SessionSegmentsTableAnnotationComposer a) f,
  ) {
    final $$SessionSegmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionSegments,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionSegmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionSegments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partNotesRefs<T extends Object>(
    Expression<T> Function($$PartNotesTableAnnotationComposer a) f,
  ) {
    final $$PartNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.partNotes,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.partNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PartsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $PartsTable,
          Part,
          $$PartsTableFilterComposer,
          $$PartsTableOrderingComposer,
          $$PartsTableAnnotationComposer,
          $$PartsTableCreateCompanionBuilder,
          $$PartsTableUpdateCompanionBuilder,
          (Part, $$PartsTableReferences),
          Part,
          PrefetchHooks Function({
            bool projectId,
            bool mainCountersRefs,
            bool stitchCountersRefs,
            bool sectionCountersRefs,
            bool sessionsRefs,
            bool sessionSegmentsRefs,
            bool partNotesRefs,
          })
        > {
  $$PartsTableTableManager(_$AppDb db, $PartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String?> buddyCounterOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PartsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                orderIndex: orderIndex,
                buddyCounterOrder: buddyCounterOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                required String name,
                required int orderIndex,
                Value<String?> buddyCounterOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PartsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                orderIndex: orderIndex,
                buddyCounterOrder: buddyCounterOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PartsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                mainCountersRefs = false,
                stitchCountersRefs = false,
                sectionCountersRefs = false,
                sessionsRefs = false,
                sessionSegmentsRefs = false,
                partNotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mainCountersRefs) db.mainCounters,
                    if (stitchCountersRefs) db.stitchCounters,
                    if (sectionCountersRefs) db.sectionCounters,
                    if (sessionsRefs) db.sessions,
                    if (sessionSegmentsRefs) db.sessionSegments,
                    if (partNotesRefs) db.partNotes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$PartsTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$PartsTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mainCountersRefs)
                        await $_getPrefetchedData<
                          Part,
                          $PartsTable,
                          MainCounter
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._mainCountersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).mainCountersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stitchCountersRefs)
                        await $_getPrefetchedData<
                          Part,
                          $PartsTable,
                          StitchCounter
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._stitchCountersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).stitchCountersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sectionCountersRefs)
                        await $_getPrefetchedData<
                          Part,
                          $PartsTable,
                          SectionCounter
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._sectionCountersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).sectionCountersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<Part, $PartsTable, Session>(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionSegmentsRefs)
                        await $_getPrefetchedData<
                          Part,
                          $PartsTable,
                          SessionSegment
                        >(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._sessionSegmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionSegmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (partNotesRefs)
                        await $_getPrefetchedData<Part, $PartsTable, PartNote>(
                          currentTable: table,
                          referencedTable: $$PartsTableReferences
                              ._partNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PartsTableReferences(
                                db,
                                table,
                                p0,
                              ).partNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.partId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $PartsTable,
      Part,
      $$PartsTableFilterComposer,
      $$PartsTableOrderingComposer,
      $$PartsTableAnnotationComposer,
      $$PartsTableCreateCompanionBuilder,
      $$PartsTableUpdateCompanionBuilder,
      (Part, $$PartsTableReferences),
      Part,
      PrefetchHooks Function({
        bool projectId,
        bool mainCountersRefs,
        bool stitchCountersRefs,
        bool sectionCountersRefs,
        bool sessionsRefs,
        bool sessionSegmentsRefs,
        bool partNotesRefs,
      })
    >;
typedef $$MainCountersTableCreateCompanionBuilder =
    MainCountersCompanion Function({
      Value<int> id,
      required int partId,
      Value<int> currentValue,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$MainCountersTableUpdateCompanionBuilder =
    MainCountersCompanion Function({
      Value<int> id,
      Value<int> partId,
      Value<int> currentValue,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$MainCountersTableReferences
    extends BaseReferences<_$AppDb, $MainCountersTable, MainCounter> {
  $$MainCountersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartsTable _partIdTable(_$AppDb db) => db.parts.createAlias(
    $_aliasNameGenerator(db.mainCounters.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MainCountersTableFilterComposer
    extends Composer<_$AppDb, $MainCountersTable> {
  $$MainCountersTableFilterComposer({
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

  ColumnFilters<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
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

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MainCountersTableOrderingComposer
    extends Composer<_$AppDb, $MainCountersTable> {
  $$MainCountersTableOrderingComposer({
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

  ColumnOrderings<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
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

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MainCountersTableAnnotationComposer
    extends Composer<_$AppDb, $MainCountersTable> {
  $$MainCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MainCountersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MainCountersTable,
          MainCounter,
          $$MainCountersTableFilterComposer,
          $$MainCountersTableOrderingComposer,
          $$MainCountersTableAnnotationComposer,
          $$MainCountersTableCreateCompanionBuilder,
          $$MainCountersTableUpdateCompanionBuilder,
          (MainCounter, $$MainCountersTableReferences),
          MainCounter,
          PrefetchHooks Function({bool partId})
        > {
  $$MainCountersTableTableManager(_$AppDb db, $MainCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MainCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MainCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MainCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<int> currentValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => MainCountersCompanion(
                id: id,
                partId: partId,
                currentValue: currentValue,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partId,
                Value<int> currentValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => MainCountersCompanion.insert(
                id: id,
                partId: partId,
                currentValue: currentValue,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MainCountersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$MainCountersTableReferences
                                    ._partIdTable(db),
                                referencedColumn: $$MainCountersTableReferences
                                    ._partIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MainCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MainCountersTable,
      MainCounter,
      $$MainCountersTableFilterComposer,
      $$MainCountersTableOrderingComposer,
      $$MainCountersTableAnnotationComposer,
      $$MainCountersTableCreateCompanionBuilder,
      $$MainCountersTableUpdateCompanionBuilder,
      (MainCounter, $$MainCountersTableReferences),
      MainCounter,
      PrefetchHooks Function({bool partId})
    >;
typedef $$StitchCountersTableCreateCompanionBuilder =
    StitchCountersCompanion Function({
      Value<int> id,
      required int partId,
      required String name,
      Value<int> currentValue,
      Value<int> countBy,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$StitchCountersTableUpdateCompanionBuilder =
    StitchCountersCompanion Function({
      Value<int> id,
      Value<int> partId,
      Value<String> name,
      Value<int> currentValue,
      Value<int> countBy,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$StitchCountersTableReferences
    extends BaseReferences<_$AppDb, $StitchCountersTable, StitchCounter> {
  $$StitchCountersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDb db) => db.parts.createAlias(
    $_aliasNameGenerator(db.stitchCounters.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StitchCountersTableFilterComposer
    extends Composer<_$AppDb, $StitchCountersTable> {
  $$StitchCountersTableFilterComposer({
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

  ColumnFilters<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countBy => $composableBuilder(
    column: $table.countBy,
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

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StitchCountersTableOrderingComposer
    extends Composer<_$AppDb, $StitchCountersTable> {
  $$StitchCountersTableOrderingComposer({
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

  ColumnOrderings<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countBy => $composableBuilder(
    column: $table.countBy,
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

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StitchCountersTableAnnotationComposer
    extends Composer<_$AppDb, $StitchCountersTable> {
  $$StitchCountersTableAnnotationComposer({
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

  GeneratedColumn<int> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countBy =>
      $composableBuilder(column: $table.countBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StitchCountersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $StitchCountersTable,
          StitchCounter,
          $$StitchCountersTableFilterComposer,
          $$StitchCountersTableOrderingComposer,
          $$StitchCountersTableAnnotationComposer,
          $$StitchCountersTableCreateCompanionBuilder,
          $$StitchCountersTableUpdateCompanionBuilder,
          (StitchCounter, $$StitchCountersTableReferences),
          StitchCounter,
          PrefetchHooks Function({bool partId})
        > {
  $$StitchCountersTableTableManager(_$AppDb db, $StitchCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StitchCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StitchCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StitchCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> currentValue = const Value.absent(),
                Value<int> countBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => StitchCountersCompanion(
                id: id,
                partId: partId,
                name: name,
                currentValue: currentValue,
                countBy: countBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partId,
                required String name,
                Value<int> currentValue = const Value.absent(),
                Value<int> countBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => StitchCountersCompanion.insert(
                id: id,
                partId: partId,
                name: name,
                currentValue: currentValue,
                countBy: countBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StitchCountersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$StitchCountersTableReferences
                                    ._partIdTable(db),
                                referencedColumn:
                                    $$StitchCountersTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StitchCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $StitchCountersTable,
      StitchCounter,
      $$StitchCountersTableFilterComposer,
      $$StitchCountersTableOrderingComposer,
      $$StitchCountersTableAnnotationComposer,
      $$StitchCountersTableCreateCompanionBuilder,
      $$StitchCountersTableUpdateCompanionBuilder,
      (StitchCounter, $$StitchCountersTableReferences),
      StitchCounter,
      PrefetchHooks Function({bool partId})
    >;
typedef $$SectionCountersTableCreateCompanionBuilder =
    SectionCountersCompanion Function({
      Value<int> id,
      required int partId,
      required String name,
      required String specJson,
      Value<LinkState> linkState,
      Value<int?> frozenMainAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$SectionCountersTableUpdateCompanionBuilder =
    SectionCountersCompanion Function({
      Value<int> id,
      Value<int> partId,
      Value<String> name,
      Value<String> specJson,
      Value<LinkState> linkState,
      Value<int?> frozenMainAt,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$SectionCountersTableReferences
    extends BaseReferences<_$AppDb, $SectionCountersTable, SectionCounter> {
  $$SectionCountersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PartsTable _partIdTable(_$AppDb db) => db.parts.createAlias(
    $_aliasNameGenerator(db.sectionCounters.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SectionRunsTable, List<SectionRun>>
  _sectionRunsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.sectionRuns,
    aliasName: $_aliasNameGenerator(
      db.sectionCounters.id,
      db.sectionRuns.sectionCounterId,
    ),
  );

  $$SectionRunsTableProcessedTableManager get sectionRunsRefs {
    final manager = $$SectionRunsTableTableManager(
      $_db,
      $_db.sectionRuns,
    ).filter((f) => f.sectionCounterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sectionRunsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SectionCountersTableFilterComposer
    extends Composer<_$AppDb, $SectionCountersTable> {
  $$SectionCountersTableFilterComposer({
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

  ColumnFilters<String> get specJson => $composableBuilder(
    column: $table.specJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LinkState, LinkState, String> get linkState =>
      $composableBuilder(
        column: $table.linkState,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get frozenMainAt => $composableBuilder(
    column: $table.frozenMainAt,
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

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sectionRunsRefs(
    Expression<bool> Function($$SectionRunsTableFilterComposer f) f,
  ) {
    final $$SectionRunsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectionRuns,
      getReferencedColumn: (t) => t.sectionCounterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionRunsTableFilterComposer(
            $db: $db,
            $table: $db.sectionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectionCountersTableOrderingComposer
    extends Composer<_$AppDb, $SectionCountersTable> {
  $$SectionCountersTableOrderingComposer({
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

  ColumnOrderings<String> get specJson => $composableBuilder(
    column: $table.specJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkState => $composableBuilder(
    column: $table.linkState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frozenMainAt => $composableBuilder(
    column: $table.frozenMainAt,
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

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionCountersTableAnnotationComposer
    extends Composer<_$AppDb, $SectionCountersTable> {
  $$SectionCountersTableAnnotationComposer({
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

  GeneratedColumn<String> get specJson =>
      $composableBuilder(column: $table.specJson, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LinkState, String> get linkState =>
      $composableBuilder(column: $table.linkState, builder: (column) => column);

  GeneratedColumn<int> get frozenMainAt => $composableBuilder(
    column: $table.frozenMainAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sectionRunsRefs<T extends Object>(
    Expression<T> Function($$SectionRunsTableAnnotationComposer a) f,
  ) {
    final $$SectionRunsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sectionRuns,
      getReferencedColumn: (t) => t.sectionCounterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionRunsTableAnnotationComposer(
            $db: $db,
            $table: $db.sectionRuns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SectionCountersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SectionCountersTable,
          SectionCounter,
          $$SectionCountersTableFilterComposer,
          $$SectionCountersTableOrderingComposer,
          $$SectionCountersTableAnnotationComposer,
          $$SectionCountersTableCreateCompanionBuilder,
          $$SectionCountersTableUpdateCompanionBuilder,
          (SectionCounter, $$SectionCountersTableReferences),
          SectionCounter,
          PrefetchHooks Function({bool partId, bool sectionRunsRefs})
        > {
  $$SectionCountersTableTableManager(_$AppDb db, $SectionCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> specJson = const Value.absent(),
                Value<LinkState> linkState = const Value.absent(),
                Value<int?> frozenMainAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SectionCountersCompanion(
                id: id,
                partId: partId,
                name: name,
                specJson: specJson,
                linkState: linkState,
                frozenMainAt: frozenMainAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partId,
                required String name,
                required String specJson,
                Value<LinkState> linkState = const Value.absent(),
                Value<int?> frozenMainAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SectionCountersCompanion.insert(
                id: id,
                partId: partId,
                name: name,
                specJson: specJson,
                linkState: linkState,
                frozenMainAt: frozenMainAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SectionCountersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false, sectionRunsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sectionRunsRefs) db.sectionRuns],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable:
                                    $$SectionCountersTableReferences
                                        ._partIdTable(db),
                                referencedColumn:
                                    $$SectionCountersTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sectionRunsRefs)
                    await $_getPrefetchedData<
                      SectionCounter,
                      $SectionCountersTable,
                      SectionRun
                    >(
                      currentTable: table,
                      referencedTable: $$SectionCountersTableReferences
                          ._sectionRunsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SectionCountersTableReferences(
                            db,
                            table,
                            p0,
                          ).sectionRunsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.sectionCounterId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SectionCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SectionCountersTable,
      SectionCounter,
      $$SectionCountersTableFilterComposer,
      $$SectionCountersTableOrderingComposer,
      $$SectionCountersTableAnnotationComposer,
      $$SectionCountersTableCreateCompanionBuilder,
      $$SectionCountersTableUpdateCompanionBuilder,
      (SectionCounter, $$SectionCountersTableReferences),
      SectionCounter,
      PrefetchHooks Function({bool partId, bool sectionRunsRefs})
    >;
typedef $$SectionRunsTableCreateCompanionBuilder =
    SectionRunsCompanion Function({
      Value<int> id,
      required int sectionCounterId,
      required int ord,
      required int startRow,
      required int rowsTotal,
      Value<String?> label,
      Value<RunState> state,
      Value<DateTime> createdAt,
    });
typedef $$SectionRunsTableUpdateCompanionBuilder =
    SectionRunsCompanion Function({
      Value<int> id,
      Value<int> sectionCounterId,
      Value<int> ord,
      Value<int> startRow,
      Value<int> rowsTotal,
      Value<String?> label,
      Value<RunState> state,
      Value<DateTime> createdAt,
    });

final class $$SectionRunsTableReferences
    extends BaseReferences<_$AppDb, $SectionRunsTable, SectionRun> {
  $$SectionRunsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SectionCountersTable _sectionCounterIdTable(_$AppDb db) =>
      db.sectionCounters.createAlias(
        $_aliasNameGenerator(
          db.sectionRuns.sectionCounterId,
          db.sectionCounters.id,
        ),
      );

  $$SectionCountersTableProcessedTableManager get sectionCounterId {
    final $_column = $_itemColumn<int>('section_counter_id')!;

    final manager = $$SectionCountersTableTableManager(
      $_db,
      $_db.sectionCounters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sectionCounterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SectionRunsTableFilterComposer
    extends Composer<_$AppDb, $SectionRunsTable> {
  $$SectionRunsTableFilterComposer({
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

  ColumnFilters<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startRow => $composableBuilder(
    column: $table.startRow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rowsTotal => $composableBuilder(
    column: $table.rowsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RunState, RunState, String> get state =>
      $composableBuilder(
        column: $table.state,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SectionCountersTableFilterComposer get sectionCounterId {
    final $$SectionCountersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionCounterId,
      referencedTable: $db.sectionCounters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionCountersTableFilterComposer(
            $db: $db,
            $table: $db.sectionCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionRunsTableOrderingComposer
    extends Composer<_$AppDb, $SectionRunsTable> {
  $$SectionRunsTableOrderingComposer({
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

  ColumnOrderings<int> get ord => $composableBuilder(
    column: $table.ord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startRow => $composableBuilder(
    column: $table.startRow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rowsTotal => $composableBuilder(
    column: $table.rowsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SectionCountersTableOrderingComposer get sectionCounterId {
    final $$SectionCountersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionCounterId,
      referencedTable: $db.sectionCounters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionCountersTableOrderingComposer(
            $db: $db,
            $table: $db.sectionCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionRunsTableAnnotationComposer
    extends Composer<_$AppDb, $SectionRunsTable> {
  $$SectionRunsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ord =>
      $composableBuilder(column: $table.ord, builder: (column) => column);

  GeneratedColumn<int> get startRow =>
      $composableBuilder(column: $table.startRow, builder: (column) => column);

  GeneratedColumn<int> get rowsTotal =>
      $composableBuilder(column: $table.rowsTotal, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RunState, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SectionCountersTableAnnotationComposer get sectionCounterId {
    final $$SectionCountersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sectionCounterId,
      referencedTable: $db.sectionCounters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SectionCountersTableAnnotationComposer(
            $db: $db,
            $table: $db.sectionCounters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SectionRunsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SectionRunsTable,
          SectionRun,
          $$SectionRunsTableFilterComposer,
          $$SectionRunsTableOrderingComposer,
          $$SectionRunsTableAnnotationComposer,
          $$SectionRunsTableCreateCompanionBuilder,
          $$SectionRunsTableUpdateCompanionBuilder,
          (SectionRun, $$SectionRunsTableReferences),
          SectionRun,
          PrefetchHooks Function({bool sectionCounterId})
        > {
  $$SectionRunsTableTableManager(_$AppDb db, $SectionRunsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionRunsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionRunsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionRunsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sectionCounterId = const Value.absent(),
                Value<int> ord = const Value.absent(),
                Value<int> startRow = const Value.absent(),
                Value<int> rowsTotal = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<RunState> state = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SectionRunsCompanion(
                id: id,
                sectionCounterId: sectionCounterId,
                ord: ord,
                startRow: startRow,
                rowsTotal: rowsTotal,
                label: label,
                state: state,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sectionCounterId,
                required int ord,
                required int startRow,
                required int rowsTotal,
                Value<String?> label = const Value.absent(),
                Value<RunState> state = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SectionRunsCompanion.insert(
                id: id,
                sectionCounterId: sectionCounterId,
                ord: ord,
                startRow: startRow,
                rowsTotal: rowsTotal,
                label: label,
                state: state,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SectionRunsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sectionCounterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sectionCounterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sectionCounterId,
                                referencedTable: $$SectionRunsTableReferences
                                    ._sectionCounterIdTable(db),
                                referencedColumn: $$SectionRunsTableReferences
                                    ._sectionCounterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SectionRunsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SectionRunsTable,
      SectionRun,
      $$SectionRunsTableFilterComposer,
      $$SectionRunsTableOrderingComposer,
      $$SectionRunsTableAnnotationComposer,
      $$SectionRunsTableCreateCompanionBuilder,
      $$SectionRunsTableUpdateCompanionBuilder,
      (SectionRun, $$SectionRunsTableReferences),
      SectionRun,
      PrefetchHooks Function({bool sectionCounterId})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required int partId,
      required DateTime startedAt,
      Value<int> totalDurationSeconds,
      Value<SessionStatus2> status,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<int> partId,
      Value<DateTime> startedAt,
      Value<int> totalDurationSeconds,
      Value<SessionStatus2> status,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDb, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartsTable _partIdTable(_$AppDb db) => db.parts.createAlias(
    $_aliasNameGenerator(db.sessions.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionSegmentsTable, List<SessionSegment>>
  _sessionSegmentsRefsTable(_$AppDb db) => MultiTypedResultKey.fromTable(
    db.sessionSegments,
    aliasName: $_aliasNameGenerator(
      db.sessions.id,
      db.sessionSegments.sessionId,
    ),
  );

  $$SessionSegmentsTableProcessedTableManager get sessionSegmentsRefs {
    final manager = $$SessionSegmentsTableTableManager(
      $_db,
      $_db.sessionSegments,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionSegmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer extends Composer<_$AppDb, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus2, SessionStatus2, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionSegmentsRefs(
    Expression<bool> Function($$SessionSegmentsTableFilterComposer f) f,
  ) {
    final $$SessionSegmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionSegments,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionSegmentsTableFilterComposer(
            $db: $db,
            $table: $db.sessionSegments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDb, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
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

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDb, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get totalDurationSeconds => $composableBuilder(
    column: $table.totalDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SessionStatus2, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionSegmentsRefs<T extends Object>(
    Expression<T> Function($$SessionSegmentsTableAnnotationComposer a) f,
  ) {
    final $$SessionSegmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionSegments,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionSegmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionSegments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool partId, bool sessionSegmentsRefs})
        > {
  $$SessionsTableTableManager(_$AppDb db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<SessionStatus2> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                partId: partId,
                startedAt: startedAt,
                totalDurationSeconds: totalDurationSeconds,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partId,
                required DateTime startedAt,
                Value<int> totalDurationSeconds = const Value.absent(),
                Value<SessionStatus2> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                partId: partId,
                startedAt: startedAt,
                totalDurationSeconds: totalDurationSeconds,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({partId = false, sessionSegmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionSegmentsRefs) db.sessionSegments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (partId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.partId,
                                    referencedTable: $$SessionsTableReferences
                                        ._partIdTable(db),
                                    referencedColumn: $$SessionsTableReferences
                                        ._partIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionSegmentsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          SessionSegment
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._sessionSegmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionSegmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool partId, bool sessionSegmentsRefs})
    >;
typedef $$SessionSegmentsTableCreateCompanionBuilder =
    SessionSegmentsCompanion Function({
      Value<int> id,
      required int sessionId,
      required int partId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<int?> startCount,
      Value<int?> endCount,
      Value<SegmentReason?> reason,
      Value<DateTime> createdAt,
    });
typedef $$SessionSegmentsTableUpdateCompanionBuilder =
    SessionSegmentsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<int> partId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int?> durationSeconds,
      Value<int?> startCount,
      Value<int?> endCount,
      Value<SegmentReason?> reason,
      Value<DateTime> createdAt,
    });

final class $$SessionSegmentsTableReferences
    extends BaseReferences<_$AppDb, $SessionSegmentsTable, SessionSegment> {
  $$SessionSegmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDb db) => db.sessions.createAlias(
    $_aliasNameGenerator(db.sessionSegments.sessionId, db.sessions.id),
  );

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PartsTable _partIdTable(_$AppDb db) => db.parts.createAlias(
    $_aliasNameGenerator(db.sessionSegments.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionSegmentsTableFilterComposer
    extends Composer<_$AppDb, $SessionSegmentsTable> {
  $$SessionSegmentsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startCount => $composableBuilder(
    column: $table.startCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endCount => $composableBuilder(
    column: $table.endCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SegmentReason?, SegmentReason, String>
  get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionSegmentsTableOrderingComposer
    extends Composer<_$AppDb, $SessionSegmentsTable> {
  $$SessionSegmentsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startCount => $composableBuilder(
    column: $table.startCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endCount => $composableBuilder(
    column: $table.endCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionSegmentsTableAnnotationComposer
    extends Composer<_$AppDb, $SessionSegmentsTable> {
  $$SessionSegmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startCount => $composableBuilder(
    column: $table.startCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endCount =>
      $composableBuilder(column: $table.endCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SegmentReason?, String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionSegmentsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SessionSegmentsTable,
          SessionSegment,
          $$SessionSegmentsTableFilterComposer,
          $$SessionSegmentsTableOrderingComposer,
          $$SessionSegmentsTableAnnotationComposer,
          $$SessionSegmentsTableCreateCompanionBuilder,
          $$SessionSegmentsTableUpdateCompanionBuilder,
          (SessionSegment, $$SessionSegmentsTableReferences),
          SessionSegment,
          PrefetchHooks Function({bool sessionId, bool partId})
        > {
  $$SessionSegmentsTableTableManager(_$AppDb db, $SessionSegmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionSegmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionSegmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionSegmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int?> startCount = const Value.absent(),
                Value<int?> endCount = const Value.absent(),
                Value<SegmentReason?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionSegmentsCompanion(
                id: id,
                sessionId: sessionId,
                partId: partId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                startCount: startCount,
                endCount: endCount,
                reason: reason,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required int partId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int?> startCount = const Value.absent(),
                Value<int?> endCount = const Value.absent(),
                Value<SegmentReason?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SessionSegmentsCompanion.insert(
                id: id,
                sessionId: sessionId,
                partId: partId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                startCount: startCount,
                endCount: endCount,
                reason: reason,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionSegmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$SessionSegmentsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$SessionSegmentsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable:
                                    $$SessionSegmentsTableReferences
                                        ._partIdTable(db),
                                referencedColumn:
                                    $$SessionSegmentsTableReferences
                                        ._partIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionSegmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SessionSegmentsTable,
      SessionSegment,
      $$SessionSegmentsTableFilterComposer,
      $$SessionSegmentsTableOrderingComposer,
      $$SessionSegmentsTableAnnotationComposer,
      $$SessionSegmentsTableCreateCompanionBuilder,
      $$SessionSegmentsTableUpdateCompanionBuilder,
      (SessionSegment, $$SessionSegmentsTableReferences),
      SessionSegment,
      PrefetchHooks Function({bool sessionId, bool partId})
    >;
typedef $$PartNotesTableCreateCompanionBuilder =
    PartNotesCompanion Function({
      Value<int> id,
      required int partId,
      required String content,
      Value<bool> isPinned,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$PartNotesTableUpdateCompanionBuilder =
    PartNotesCompanion Function({
      Value<int> id,
      Value<int> partId,
      Value<String> content,
      Value<bool> isPinned,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

final class $$PartNotesTableReferences
    extends BaseReferences<_$AppDb, $PartNotesTable, PartNote> {
  $$PartNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PartsTable _partIdTable(_$AppDb db) => db.parts.createAlias(
    $_aliasNameGenerator(db.partNotes.partId, db.parts.id),
  );

  $$PartsTableProcessedTableManager get partId {
    final $_column = $_itemColumn<int>('part_id')!;

    final manager = $$PartsTableTableManager(
      $_db,
      $_db.parts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartNotesTableFilterComposer
    extends Composer<_$AppDb, $PartNotesTable> {
  $$PartNotesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
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

  $$PartsTableFilterComposer get partId {
    final $$PartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableFilterComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartNotesTableOrderingComposer
    extends Composer<_$AppDb, $PartNotesTable> {
  $$PartNotesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
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

  $$PartsTableOrderingComposer get partId {
    final $$PartsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableOrderingComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartNotesTableAnnotationComposer
    extends Composer<_$AppDb, $PartNotesTable> {
  $$PartNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PartsTableAnnotationComposer get partId {
    final $$PartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.parts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartsTableAnnotationComposer(
            $db: $db,
            $table: $db.parts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartNotesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $PartNotesTable,
          PartNote,
          $$PartNotesTableFilterComposer,
          $$PartNotesTableOrderingComposer,
          $$PartNotesTableAnnotationComposer,
          $$PartNotesTableCreateCompanionBuilder,
          $$PartNotesTableUpdateCompanionBuilder,
          (PartNote, $$PartNotesTableReferences),
          PartNote,
          PrefetchHooks Function({bool partId})
        > {
  $$PartNotesTableTableManager(_$AppDb db, $PartNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> partId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PartNotesCompanion(
                id: id,
                partId: partId,
                content: content,
                isPinned: isPinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int partId,
                required String content,
                Value<bool> isPinned = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PartNotesCompanion.insert(
                id: id,
                partId: partId,
                content: content,
                isPinned: isPinned,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({partId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (partId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.partId,
                                referencedTable: $$PartNotesTableReferences
                                    ._partIdTable(db),
                                referencedColumn: $$PartNotesTableReferences
                                    ._partIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PartNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $PartNotesTable,
      PartNote,
      $$PartNotesTableFilterComposer,
      $$PartNotesTableOrderingComposer,
      $$PartNotesTableAnnotationComposer,
      $$PartNotesTableCreateCompanionBuilder,
      $$PartNotesTableUpdateCompanionBuilder,
      (PartNote, $$PartNotesTableReferences),
      PartNote,
      PrefetchHooks Function({bool partId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      required String name,
      required int color,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDb, $TagsTable> {
  $$TagsTableFilterComposer({
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

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
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

class $$TagsTableOrderingComposer extends Composer<_$AppDb, $TagsTable> {
  $$TagsTableOrderingComposer({
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

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
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

class $$TagsTableAnnotationComposer extends Composer<_$AppDb, $TagsTable> {
  $$TagsTableAnnotationComposer({
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

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDb, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDb db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                color: color,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int color,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                color: color,
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

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDb, $TagsTable, Tag>),
      Tag,
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
typedef $$ProjectCountersTableCreateCompanionBuilder =
    ProjectCountersCompanion Function({
      Value<int> projectId,
      Value<int> mainCounter,
      Value<int> mainCountBy,
      Value<int?> subCounter,
      Value<int> subCountBy,
      Value<bool> hasSubCounter,
    });
typedef $$ProjectCountersTableUpdateCompanionBuilder =
    ProjectCountersCompanion Function({
      Value<int> projectId,
      Value<int> mainCounter,
      Value<int> mainCountBy,
      Value<int?> subCounter,
      Value<int> subCountBy,
      Value<bool> hasSubCounter,
    });

class $$ProjectCountersTableFilterComposer
    extends Composer<_$AppDb, $ProjectCountersTable> {
  $$ProjectCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mainCounter => $composableBuilder(
    column: $table.mainCounter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mainCountBy => $composableBuilder(
    column: $table.mainCountBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subCounter => $composableBuilder(
    column: $table.subCounter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subCountBy => $composableBuilder(
    column: $table.subCountBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSubCounter => $composableBuilder(
    column: $table.hasSubCounter,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectCountersTableOrderingComposer
    extends Composer<_$AppDb, $ProjectCountersTable> {
  $$ProjectCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mainCounter => $composableBuilder(
    column: $table.mainCounter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mainCountBy => $composableBuilder(
    column: $table.mainCountBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subCounter => $composableBuilder(
    column: $table.subCounter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subCountBy => $composableBuilder(
    column: $table.subCountBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSubCounter => $composableBuilder(
    column: $table.hasSubCounter,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectCountersTableAnnotationComposer
    extends Composer<_$AppDb, $ProjectCountersTable> {
  $$ProjectCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<int> get mainCounter => $composableBuilder(
    column: $table.mainCounter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mainCountBy => $composableBuilder(
    column: $table.mainCountBy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subCounter => $composableBuilder(
    column: $table.subCounter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subCountBy => $composableBuilder(
    column: $table.subCountBy,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSubCounter => $composableBuilder(
    column: $table.hasSubCounter,
    builder: (column) => column,
  );
}

class $$ProjectCountersTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ProjectCountersTable,
          ProjectCounter,
          $$ProjectCountersTableFilterComposer,
          $$ProjectCountersTableOrderingComposer,
          $$ProjectCountersTableAnnotationComposer,
          $$ProjectCountersTableCreateCompanionBuilder,
          $$ProjectCountersTableUpdateCompanionBuilder,
          (
            ProjectCounter,
            BaseReferences<_$AppDb, $ProjectCountersTable, ProjectCounter>,
          ),
          ProjectCounter,
          PrefetchHooks Function()
        > {
  $$ProjectCountersTableTableManager(_$AppDb db, $ProjectCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> projectId = const Value.absent(),
                Value<int> mainCounter = const Value.absent(),
                Value<int> mainCountBy = const Value.absent(),
                Value<int?> subCounter = const Value.absent(),
                Value<int> subCountBy = const Value.absent(),
                Value<bool> hasSubCounter = const Value.absent(),
              }) => ProjectCountersCompanion(
                projectId: projectId,
                mainCounter: mainCounter,
                mainCountBy: mainCountBy,
                subCounter: subCounter,
                subCountBy: subCountBy,
                hasSubCounter: hasSubCounter,
              ),
          createCompanionCallback:
              ({
                Value<int> projectId = const Value.absent(),
                Value<int> mainCounter = const Value.absent(),
                Value<int> mainCountBy = const Value.absent(),
                Value<int?> subCounter = const Value.absent(),
                Value<int> subCountBy = const Value.absent(),
                Value<bool> hasSubCounter = const Value.absent(),
              }) => ProjectCountersCompanion.insert(
                projectId: projectId,
                mainCounter: mainCounter,
                mainCountBy: mainCountBy,
                subCounter: subCounter,
                subCountBy: subCountBy,
                hasSubCounter: hasSubCounter,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ProjectCountersTable,
      ProjectCounter,
      $$ProjectCountersTableFilterComposer,
      $$ProjectCountersTableOrderingComposer,
      $$ProjectCountersTableAnnotationComposer,
      $$ProjectCountersTableCreateCompanionBuilder,
      $$ProjectCountersTableUpdateCompanionBuilder,
      (
        ProjectCounter,
        BaseReferences<_$AppDb, $ProjectCountersTable, ProjectCounter>,
      ),
      ProjectCounter,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$PartsTableTableManager get parts =>
      $$PartsTableTableManager(_db, _db.parts);
  $$MainCountersTableTableManager get mainCounters =>
      $$MainCountersTableTableManager(_db, _db.mainCounters);
  $$StitchCountersTableTableManager get stitchCounters =>
      $$StitchCountersTableTableManager(_db, _db.stitchCounters);
  $$SectionCountersTableTableManager get sectionCounters =>
      $$SectionCountersTableTableManager(_db, _db.sectionCounters);
  $$SectionRunsTableTableManager get sectionRuns =>
      $$SectionRunsTableTableManager(_db, _db.sectionRuns);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionSegmentsTableTableManager get sessionSegments =>
      $$SessionSegmentsTableTableManager(_db, _db.sessionSegments);
  $$PartNotesTableTableManager get partNotes =>
      $$PartNotesTableTableManager(_db, _db.partNotes);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$WorkSessionsTableTableManager get workSessions =>
      $$WorkSessionsTableTableManager(_db, _db.workSessions);
  $$ProjectCountersTableTableManager get projectCounters =>
      $$ProjectCountersTableTableManager(_db, _db.projectCounters);
}
