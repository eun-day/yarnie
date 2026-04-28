import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';

class BackupService {
  final AppDb _db;

  BackupService(this._db);

  /// 모든 DB 데이터 + 프로젝트 이미지를 ZIP으로 묶어 내보냅니다.
  /// 반환: 임시 디렉토리에 생성된 .zip 파일 경로
  Future<String> exportBackup() async {
    final Map<String, dynamic> backupData = {
      'metadata': {
        'version': 2,
        'exported_at': DateTime.now().toUtc().toIso8601String(),
        'app_identifier': 'com.yes.yarnie',
      },
      'data': await _fetchAllTableData(),
    };

    final String jsonString =
        const JsonEncoder.withIndent('  ').convert(backupData);

    // ZIP 아카이브 생성
    final archive = Archive();

    // 1) JSON 데이터 파일 추가
    final jsonBytes = utf8.encode(jsonString);
    archive.addFile(ArchiveFile(
      'data.json',
      jsonBytes.length,
      jsonBytes,
    ));

    // 2) 프로젝트 이미지 파일 수집 및 추가
    final docDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(p.join(docDir.path, 'project_images'));

    if (await imageDir.exists()) {
      final imageFiles = imageDir
          .listSync(recursive: true)
          .whereType<File>();
      for (final imageFile in imageFiles) {
        // 상대 경로 유지 (예: project_images/123456.jpg)
        final relativePath =
            p.relative(imageFile.path, from: docDir.path);
        final bytes = await imageFile.readAsBytes();
        archive.addFile(ArchiveFile(
          relativePath,
          bytes.length,
          bytes,
        ));
      }
    }

    // ZIP 인코딩
    final zipData = ZipEncoder().encode(archive);

    // 임시 디렉토리에 .zip 파일로 저장
    final tempDir = await getTemporaryDirectory();
    final String formattedDate =
        DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final fileName = 'yarnie_backup_$formattedDate.zip';
    final file = File(p.join(tempDir.path, fileName));

    await file.writeAsBytes(zipData);
    return file.path;
  }

  /// 백업 파일을 읽어 DB를 복원합니다.
  /// .zip 파일과 레거시 .json 파일 모두 지원합니다.
  Future<void> importBackup(String filePath) async {
    final file = File(filePath);
    final extension = p.extension(filePath).toLowerCase();

    if (extension == '.json') {
      // 레거시 JSON 형식 지원
      await _importFromJson(file);
    } else {
      // ZIP 형식 (.zip)
      await _importFromZip(file);
    }
  }

  /// 레거시 JSON 파일에서 복원 (이미지 없음)
  Future<void> _importFromJson(File file) async {
    final String jsonString = await file.readAsString();
    final Map<String, dynamic> backupData = jsonDecode(jsonString);

    if (backupData['metadata'] == null || backupData['data'] == null) {
      throw const FormatException('Invalid backup file format');
    }

    final data = backupData['data'] as Map<String, dynamic>;
    await _restoreDatabase(data);
  }

  /// ZIP 파일에서 데이터 + 이미지 복원
  Future<void> _importFromZip(File file) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // 1) data.json 찾기
    final dataFile = archive.findFile('data.json');
    if (dataFile == null) {
      throw const FormatException(
          'Invalid backup file: data.json not found');
    }

    final jsonString = utf8.decode(dataFile.content as List<int>);
    final Map<String, dynamic> backupData = jsonDecode(jsonString);

    if (backupData['metadata'] == null || backupData['data'] == null) {
      throw const FormatException('Invalid backup file format');
    }

    final data = backupData['data'] as Map<String, dynamic>;

    // 2) 기존 이미지 디렉토리 정리
    final docDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory(p.join(docDir.path, 'project_images'));
    if (await imageDir.exists()) {
      await imageDir.delete(recursive: true);
    }

    // 3) 아카이브에서 이미지 파일 복원
    for (final entry in archive) {
      if (entry.name == 'data.json') continue;
      if (!entry.isFile) continue;

      // project_images/ 로 시작하는 파일만 복원
      if (entry.name.startsWith('project_images/')) {
        final destPath = p.join(docDir.path, entry.name);
        final destFile = File(destPath);

        // 디렉토리 생성
        await destFile.parent.create(recursive: true);
        await destFile.writeAsBytes(entry.content as List<int>);
      }
    }

    // 4) DB 복원
    await _restoreDatabase(data);
  }

  /// DB 데이터 복원 (공통 로직)
  Future<void> _restoreDatabase(Map<String, dynamic> data) async {
    await _db.transaction(() async {
      // 1. 기존 데이터 삭제 (순서 주의: 외래키 제약 때문에 역순 삭제 권장)
      await _deleteAllData();

      // 2. 데이터 삽입 (순서 주의: 참조 무결성을 위해 Projects부터 삽입)
      
      // Projects
      if (data['projects'] != null) {
        for (var e in (data['projects'] as List)) {
          final item = Project.fromJson(e);
          await _db.into(_db.projects).insert(item);
        }
      }

      // Parts
      if (data['parts'] != null) {
        for (var e in (data['parts'] as List)) {
          final item = Part.fromJson(e);
          await _db.into(_db.parts).insert(item);
        }
      }

      // MainCounters
      if (data['main_counters'] != null) {
        for (var e in (data['main_counters'] as List)) {
          final item = MainCounter.fromJson(e);
          await _db.into(_db.mainCounters).insert(item);
        }
      }

      // StitchCounters
      if (data['stitch_counters'] != null) {
        for (var e in (data['stitch_counters'] as List)) {
          final item = StitchCounter.fromJson(e);
          await _db.into(_db.stitchCounters).insert(item);
        }
      }

      // SectionCounters
      if (data['section_counters'] != null) {
        for (var e in (data['section_counters'] as List)) {
          final item = SectionCounter.fromJson(e);
          await _db.into(_db.sectionCounters).insert(item);
        }
      }

      // SectionRuns
      if (data['section_runs'] != null) {
        for (var e in (data['section_runs'] as List)) {
          final item = SectionRun.fromJson(e);
          await _db.into(_db.sectionRuns).insert(item);
        }
      }

      // Sessions
      if (data['sessions'] != null) {
        for (var e in (data['sessions'] as List)) {
          final item = Session.fromJson(e);
          await _db.into(_db.sessions).insert(item);
        }
      }

      // SessionSegments
      if (data['session_segments'] != null) {
        for (var e in (data['session_segments'] as List)) {
          final item = SessionSegment.fromJson(e);
          await _db.into(_db.sessionSegments).insert(item);
        }
      }

      // PartNotes
      if (data['part_notes'] != null) {
        for (var e in (data['part_notes'] as List)) {
          final item = PartNote.fromJson(e);
          await _db.into(_db.partNotes).insert(item);
        }
      }

      // Tags
      if (data['tags'] != null) {
        for (var e in (data['tags'] as List)) {
          final item = Tag.fromJson(e);
          await _db.into(_db.tags).insert(item);
        }
      }

      // (마이그레이션용 기존 테이블)
      if (data['work_sessions'] != null) {
        for (var e in (data['work_sessions'] as List)) {
          final item = WorkSession.fromJson(e);
          await _db.into(_db.workSessions).insert(item);
        }
      }
      if (data['project_counters'] != null) {
        for (var e in (data['project_counters'] as List)) {
          final item = ProjectCounter.fromJson(e);
          await _db.into(_db.projectCounters).insert(item);
        }
      }
    });
  }

  Future<void> _deleteAllData() async {
    // 외래키 제약 때문에 하위 테이블부터 삭제
    await _db.delete(_db.sessionSegments).go();
    await _db.delete(_db.sessions).go();
    await _db.delete(_db.sectionRuns).go();
    await _db.delete(_db.sectionCounters).go();
    await _db.delete(_db.stitchCounters).go();
    await _db.delete(_db.mainCounters).go();
    await _db.delete(_db.partNotes).go();
    await _db.delete(_db.parts).go();
    await _db.delete(_db.tags).go();
    await _db.delete(_db.projects).go();
    await _db.delete(_db.workSessions).go();
    await _db.delete(_db.projectCounters).go();
  }

  /// 각 테이블의 데이터를 Map 리스트 형태로 수집합니다.
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAllTableData() async {
    final Map<String, List<Map<String, dynamic>>> allData = {};

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

    allData['work_sessions'] = (await _db.select(_db.workSessions).get()).map((e) => e.toJson()).toList();
    allData['project_counters'] = (await _db.select(_db.projectCounters).get()).map((e) => e.toJson()).toList();

    return allData;
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(appDbProvider);
  return BackupService(db);
});
