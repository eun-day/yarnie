import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';

class BackupService {
  final AppDb _db;

  BackupService(this._db);

  /// 모든 DB 데이터 + 앱 이미지를 ZIP으로 묶어 내보냅니다.
  /// 반환: 임시 디렉토리에 생성된 .zip 파일 경로
  Future<String> exportBackup() async {
    final Map<String, dynamic> backupData = {
      'metadata': {
        'version': 2,
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'appIdentifier': 'com.yes.yarnie',
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

    // 2) 앱 이미지 파일 수집 및 추가
    final docDir = await getApplicationDocumentsDirectory();
    final imageSubDirs = ['project_images', 'stash_images'];

    for (final subDir in imageSubDirs) {
      final imageDir = Directory(p.join(docDir.path, subDir));
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
    for (final subDir in ['project_images', 'stash_images']) {
      final imageDir = Directory(p.join(docDir.path, subDir));
      if (await imageDir.exists()) {
        await imageDir.delete(recursive: true);
      }
    }

    // 3) 아카이브에서 이미지 파일 복원
    for (final entry in archive) {
      if (entry.name == 'data.json') continue;
      if (!entry.isFile) continue;

      // project_images/ 또는 stash_images/ 로 시작하는 파일만 복원
      if (entry.name.startsWith('project_images/') ||
          entry.name.startsWith('stash_images/')) {
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
      final projectsData = data['projects'];
      if (projectsData != null) {
        for (var e in (projectsData as List)) {
          final item = Project.fromJson(e);
          await _db.into(_db.projects).insert(item);
        }
      }

      // Parts
      final partsData = data['parts'];
      if (partsData != null) {
        for (var e in (partsData as List)) {
          final item = Part.fromJson(e);
          await _db.into(_db.parts).insert(item);
        }
      }

      // MainCounters
      final mainCountersData = data['mainCounters'] ?? data['main_counters'];
      if (mainCountersData != null) {
        for (var e in (mainCountersData as List)) {
          final Map<String, dynamic> map = Map<String, dynamic>.from(e as Map);
          if (map['countBy'] == null) {
            map['countBy'] = 1;
          }
          final item = MainCounter.fromJson(map);
          await _db.into(_db.mainCounters).insert(item);
        }
      }

      // StitchCounters
      final stitchCountersData = data['stitchCounters'] ?? data['stitch_counters'];
      if (stitchCountersData != null) {
        for (var e in (stitchCountersData as List)) {
          final Map<String, dynamic> map = Map<String, dynamic>.from(e as Map);
          if (map['countBy'] == null) {
            map['countBy'] = 1;
          }
          final item = StitchCounter.fromJson(map);
          await _db.into(_db.stitchCounters).insert(item);
        }
      }

      // SectionCounters
      final sectionCountersData = data['sectionCounters'] ?? data['section_counters'];
      if (sectionCountersData != null) {
        for (var e in (sectionCountersData as List)) {
          final item = SectionCounter.fromJson(e);
          await _db.into(_db.sectionCounters).insert(item);
        }
      }

      // SectionRuns
      final sectionRunsData = data['sectionRuns'] ?? data['section_runs'];
      if (sectionRunsData != null) {
        for (var e in (sectionRunsData as List)) {
          final item = SectionRun.fromJson(e);
          await _db.into(_db.sectionRuns).insert(item);
        }
      }

      // Sessions
      final sessionsData = data['sessions'];
      if (sessionsData != null) {
        for (var e in (sessionsData as List)) {
          final item = Session.fromJson(e);
          await _db.into(_db.sessions).insert(item);
        }
      }

      // SessionSegments
      final sessionSegmentsData = data['sessionSegments'] ?? data['session_segments'];
      if (sessionSegmentsData != null) {
        for (var e in (sessionSegmentsData as List)) {
          final item = SessionSegment.fromJson(e);
          await _db.into(_db.sessionSegments).insert(item);
        }
      }

      // PartNotes
      final partNotesData = data['partNotes'] ?? data['part_notes'];
      if (partNotesData != null) {
        for (var e in (partNotesData as List)) {
          final item = PartNote.fromJson(e);
          await _db.into(_db.partNotes).insert(item);
        }
      }

      // Tags
      final tagsData = data['tags'];
      if (tagsData != null) {
        for (var e in (tagsData as List)) {
          final item = Tag.fromJson(e);
          await _db.into(_db.tags).insert(item);
        }
      }

      // StashTags
      final stashTagsData = data['stashTags'] ?? data['stash_tags'];
      if (stashTagsData != null) {
        for (var e in (stashTagsData as List)) {
          final item = StashTag.fromJson(e);
          await _db.into(_db.stashTags).insert(item);
        }
      }

      // StashYarns
      final stashYarnsData = data['stashYarns'] ?? data['stash_yarns'];
      if (stashYarnsData != null) {
        for (var e in (stashYarnsData as List)) {
          final item = StashYarn.fromJson(e);
          await _db.into(_db.stashYarns).insert(item);
        }
      }

      // ProjectStashYarns (프로젝트-실 연동)
      final projectStashYarnsData = data['projectStashYarns'] ?? data['project_stash_yarns'];
      if (projectStashYarnsData != null) {
        for (var e in (projectStashYarnsData as List)) {
          final item = ProjectStashYarn.fromJson(e);
          await _db.into(_db.projectStashYarns).insert(item);
        }
      }

      // v2 이전 백업 복원 시: lotNumber / lot_number → 실 자동 생성 및 프로젝트 연동
      if (stashYarnsData == null && projectsData != null) {
        final now = DateTime.now().toUtc();
        for (var e in (projectsData as List)) {
          final map = e as Map<String, dynamic>;
          final lotNumber = (map['lotNumber'] ?? map['lot_number']) as String?;
          if (lotNumber == null || lotNumber.isEmpty) continue;

          final projectId = map['id'] as int;
          final stashYarnId = await _db.into(_db.stashYarns).insert(
            StashYarnsCompanion.insert(
              yarnName: '기존 프로젝트 실 (자동 생성)',
              brandName: const Value('이전 로트 번호 실'),
              dyeLot: Value(lotNumber),
              skeins: const Value(0.0),
              lengthUnit: const Value('yards'),
              weightUnit: const Value('grams'),
              createdAt: Value(now),
            ),
          );
          await _db.into(_db.projectStashYarns).insert(
            ProjectStashYarnsCompanion.insert(
              projectId: projectId,
              stashYarnId: stashYarnId,
            ),
          );
        }
      }

      // (마이그레이션용 기존 테이블)
      final workSessionsData = data['workSessions'] ?? data['work_sessions'];
      if (workSessionsData != null) {
        for (var e in (workSessionsData as List)) {
          final item = WorkSession.fromJson(e);
          await _db.into(_db.workSessions).insert(item);
        }
      }
      final projectCountersData = data['projectCounters'] ?? data['project_counters'];
      if (projectCountersData != null) {
        for (var e in (projectCountersData as List)) {
          final item = ProjectCounter.fromJson(e);
          await _db.into(_db.projectCounters).insert(item);
        }
      }
    });
  }

  Future<void> _deleteAllData() async {
    // 외래키 제약 때문에 하위 테이블부터 삭제
    await _db.delete(_db.projectStashYarns).go();
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
    await _db.delete(_db.stashYarns).go();
    await _db.delete(_db.stashTags).go();
    await _db.delete(_db.workSessions).go();
    await _db.delete(_db.projectCounters).go();
  }

  /// 각 테이블의 데이터를 Map 리스트 형태로 수집합니다.
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAllTableData() async {
    final Map<String, List<Map<String, dynamic>>> allData = {};

    allData['projects'] = (await _db.select(_db.projects).get()).map((e) => e.toJson()).toList();
    allData['parts'] = (await _db.select(_db.parts).get()).map((e) => e.toJson()).toList();
    allData['mainCounters'] = (await _db.select(_db.mainCounters).get()).map((e) => e.toJson()).toList();
    allData['stitchCounters'] = (await _db.select(_db.stitchCounters).get()).map((e) => e.toJson()).toList();
    allData['sectionCounters'] = (await _db.select(_db.sectionCounters).get()).map((e) => e.toJson()).toList();
    allData['sectionRuns'] = (await _db.select(_db.sectionRuns).get()).map((e) => e.toJson()).toList();
    allData['sessions'] = (await _db.select(_db.sessions).get()).map((e) => e.toJson()).toList();
    allData['sessionSegments'] = (await _db.select(_db.sessionSegments).get()).map((e) => e.toJson()).toList();
    allData['partNotes'] = (await _db.select(_db.partNotes).get()).map((e) => e.toJson()).toList();
    allData['tags'] = (await _db.select(_db.tags).get()).map((e) => e.toJson()).toList();
    allData['stashYarns'] = (await _db.select(_db.stashYarns).get()).map((e) => e.toJson()).toList();
    allData['stashTags'] = (await _db.select(_db.stashTags).get()).map((e) => e.toJson()).toList();
    allData['projectStashYarns'] = (await _db.select(_db.projectStashYarns).get()).map((e) => e.toJson()).toList();

    allData['workSessions'] = (await _db.select(_db.workSessions).get()).map((e) => e.toJson()).toList();
    allData['projectCounters'] = (await _db.select(_db.projectCounters).get()).map((e) => e.toJson()).toList();

    return allData;
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(appDbProvider);
  return BackupService(db);
});
