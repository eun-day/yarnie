import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';

class BackupService {
  final AppDb _db;

  BackupService(this._db);

  /// 모든 DB 데이터를 JSON으로 내보내고 저장된 임시 파일 경로를 반환합니다.
  Future<String> exportBackup() async {
    final Map<String, dynamic> backupData = {
      'metadata': {
        'version': 1,
        'exported_at': DateTime.now().toUtc().toIso8601String(),
        'app_identifier': 'com.example.yarnie',
      },
      'data': await _fetchAllTableData(),
    };

    // 가독성을 위해 들여쓰기 포함 (용량이 걱정된다면 indent 제거 가능)
    final String jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
    
    // 임시 파일 생성 (공유 시트 호출용)
    final directory = await getTemporaryDirectory();
    final fileName = 'yarnie_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${directory.path}/$fileName');
    
    await file.writeAsString(jsonString);
    return file.path;
  }

  /// 각 테이블의 데이터를 Map 리스트 형태로 수집합니다.
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAllTableData() async {
    final Map<String, List<Map<String, dynamic>>> allData = {};

    // Drift 테이블 getter를 사용하여 데이터를 가져옵니다.
    allData['projects'] = (await _db.select(_db.projects).get()).map((e) => e.toJson()).toList();
    allData['parts'] = (await _db.select(_db.parts).get()).map((e) => e.toJson()).toList();
    allData['main_counters'] = (await _db.select(_db.mainCounters).get()).map((e) => e.toJson()).toList();
    allData['stitch_counters'] = (await _db.select(_db.stitchCounters).get()).map((e) => e.toJson()).toList();
    allData['section_counters'] = (await _db.select(_db.sectionCounters).get()).map((e) => e.toJson()).toList();
    allData['section_runs'] = (await _db.select(_db.sectionRuns).get()).map((e) => e.toJson()).toList();
    allData['sessions'] = (await _db.select(_db.sessions).get()).map((e) => e.toJson()).toList();
    allData['session_segments'] = (await _db.select(_db.sessionSegments).get()).map((e) => e.toJson()).toList();
    allData['part_notes'] = (await _db.select(_db.partNotes).get()).map((e) => e.toJson()).toList();
    allData['tags'] = (await _db.select(_db.tags).get()).map((e) => e.toJson()).toList();

    // 마이그레이션 관리용 기존 테이블
    allData['work_sessions'] = (await _db.select(_db.workSessions).get()).map((e) => e.toJson()).toList();
    allData['project_counters'] = (await _db.select(_db.projectCounters).get()).map((e) => e.toJson()).toList();

    return allData;
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(appDbProvider);
  return BackupService(db);
});
