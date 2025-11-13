// lib/db/connection.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Drift가 사용할 실제 SQLite 연결을 연다.
/// 앱 최초 실행 시: 앱 문서 폴더에 app.db 생성.
QueryExecutor openConnection() {
  // 앱 시작 후 실제 접근 시점에 열어서 초기 지연을 최소화
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));

    // 성능 로그가 필요하면 logStatements: true로
    return NativeDatabase(
      file,
      logStatements: false,
      setup: (db) {
        // 외래키 제약조건 활성화
        db.execute('PRAGMA foreign_keys = ON');
      },
    );

    // UI 끊김 최소화가 더 중요하면 아래 대안도 가능
    // return NativeDatabase.createInBackground(file);
  });
}

/// 테스트용 인메모리 데이터베이스 연결
QueryExecutor openTestConnection() {
  return NativeDatabase.memory(
    logStatements: false,
    setup: (db) {
      // 외래키 제약조건 활성화
      db.execute('PRAGMA foreign_keys = ON');
    },
  );
}
