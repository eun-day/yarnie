import 'package:drift/drift.dart';
import 'connection.dart';

part 'app_db.g.dart';   // <- 코드 생성 파일 연결

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get needleType => text().nullable()();
  TextColumn get needleSize => text().nullable()();
  TextColumn get lotNumber => text().nullable()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [Projects])
class AppDb extends _$AppDb {
  AppDb() : super(openConnection());
  @override int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
  );

  Future<int> createProject({
    required String name,
    String? category,
    String? needleType,
    String? needleSize,
    String? lotNumber,
    String? memo,
  }) {
    return into(projects).insert(ProjectsCompanion.insert(
      name: name,
      category: Value(category),
      needleType: Value(needleType),
      needleSize: Value(needleSize),
      lotNumber: Value(lotNumber),
      memo: Value(memo),
    ));
  }

  Future<bool> updateProject(ProjectsCompanion entity) {
    final now = DateTime.now().toUtc();
    return update(projects).replace(entity.copyWith(updatedAt: Value(now)));
  }

  Stream<List<Project>> watchAll() =>
      (select(projects)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
}
