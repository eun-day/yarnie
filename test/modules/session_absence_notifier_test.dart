import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yarnie/core/providers/locale_provider.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/modules/projects/application/session_absence_event.dart';
import 'package:yarnie/modules/projects/application/session_absence_notifier.dart';
import '../helpers/test_helpers.dart';

void main() {
  late AppDb db;
  late SharedPreferences prefs;
  late ProviderContainer container;
  late int partId;
  late int sessionId;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = createTestDb();
    container = ProviderContainer(overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDbProvider.overrideWithValue(db),
    ]);

    final projectId = await createTestProject(db);
    partId = await db.createPart(projectId: projectId, name: 'Part');
    sessionId = await db.createSession(partId: partId, currentMainValue: 1);
    // 30분 전에 시작한 세션
    final segment = await db.getCurrentSegment(sessionId);
    await (db.update(db.sessionSegments)..where((t) => t.id.equals(segment!.id)))
        .write(SessionSegmentsCompanion(
      startedAt: Value(DateTime.now().subtract(const Duration(minutes: 30))),
    ));
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  SessionAbsenceNotifier notifier() => container.read(sessionAbsenceProvider.notifier);

  Future<void> leftAppAgo(Duration ago) async {
    await notifier().onEvent(const AppWentToBackground());
    // 백그라운드로 간 시각을 과거로 당긴다
    final key = prefs.getKeys().single;
    await prefs.setInt(key, DateTime.now().subtract(ago).millisecondsSinceEpoch);
  }

  test('3분 이하로 떠났다 돌아오면 묻지 않고 그대로 반영한다', () async {
    await leftAppAgo(const Duration(minutes: 2));

    await notifier().onEvent(const AppReturnedToForeground());

    expect(container.read(sessionAbsenceProvider).pendingAbsence, isNull);
    expect(prefs.getKeys(), isEmpty);
    expect((await db.getSession(partId))!.status, SessionStatus2.running);
  });

  test('3분 넘게 떠났다 돌아오면 이탈 시간을 묻는다', () async {
    await leftAppAgo(const Duration(minutes: 10));

    await notifier().onEvent(const AppReturnedToForeground());

    final pending = container.read(sessionAbsenceProvider).pendingAbsence;
    expect(pending, isNotNull);
    expect(pending!.inMinutes, 10);
  });

  test('반영하지 않으면 앱을 떠난 시각에 세션을 멈춘다', () async {
    await leftAppAgo(const Duration(minutes: 10));
    await notifier().onEvent(const AppReturnedToForeground());

    await notifier().onEvent(const AbsenceResolved(false));

    final session = (await db.getSession(partId))!;
    expect(session.status, SessionStatus2.paused);
    expect(session.totalDurationSeconds, closeTo(20 * 60, 2)); // 30분 중 떠나기 전 20분만
    expect(container.read(sessionAbsenceProvider).pendingAbsence, isNull);
    expect(prefs.getKeys(), isEmpty);
  });

  test('반영하면 세션은 그대로 진행된다', () async {
    await leftAppAgo(const Duration(minutes: 10));
    await notifier().onEvent(const AppReturnedToForeground());

    await notifier().onEvent(const AbsenceResolved(true));

    expect((await db.getSession(partId))!.status, SessionStatus2.running);
    expect(container.read(sessionAbsenceProvider).pendingAbsence, isNull);
  });

  test('진행 중인 세션이 없으면 묻지 않는다', () async {
    await db.pauseRunningSession(partId);
    await leftAppAgo(const Duration(minutes: 10));

    await notifier().onEvent(const AppReturnedToForeground());

    expect(container.read(sessionAbsenceProvider).pendingAbsence, isNull);
    expect(prefs.getKeys(), isEmpty);
  });
}
