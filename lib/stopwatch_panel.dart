import 'dart:io' show Platform;
import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/features/projects/end_session_result.dart';
import 'package:yarnie/widget/labelpill.dart';
import 'package:yarnie/wrapper/session_stopwatch.dart';
import 'package:yarnie/model/session_status.dart';

/// 스톱워치 패널(Scaffold 없음) — 화면 어디든 끼워 넣기용
class StopwatchPanel extends StatefulWidget {
  final List<String> initialLabels;
  final int projectId;

  const StopwatchPanel({
    super.key,
    this.initialLabels = const ['소매', '몸통', '목둘레'],
    required this.projectId
  });
  @override
  State<StopwatchPanel> createState() => _StopwatchPanelState();
}

class _StopwatchPanelState extends State<StopwatchPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 라벨
  late List<String> labels = [...widget.initialLabels];
  String? currentLabel = null; // null => 미분류

  // 타이머
  final SessionStopwatch _sw = SessionStopwatch();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  // 랩
  final List<_Lap> _laps = [];
  Duration _lastLapAt = Duration.zero;

  bool _busy = false;
  bool _lapBusy = false;
  late final Stream<List<WorkSession>> _stream;

  @override
  void initState() {
    super.initState();
    if (labels.isNotEmpty) currentLabel = labels.first;
    _stream = appDb.watchCompletedSessions(widget.projectId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFromDB());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    if (_sw.isRunning) return;

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final active = await appDb.getActiveSession(widget.projectId);

    if (active == null) {
      // NO → 새 세션 생성 ⇒ RUNNING
      await appDb.startSession(projectId: widget.projectId, nowMs: nowMs);
    } else {
      // 이어하기/새로 시작 선택
      final resume = await _askResumeOrNew();
      if (resume == true) {
        // 이어하기: 상태별 처리
        if (active.status == SessionStatus.paused) {
        await appDb.resumeSession(projectId: widget.projectId, nowMs: nowMs);
        }
        // running이면 DB 호출 불필요
      } else {
        // 새로 시작: 기존 미종료 세션 정리 후 새 세션
        await appDb.stopSession(projectId: widget.projectId, nowMs: nowMs);
        await appDb.startSession(projectId: widget.projectId, nowMs: nowMs);
      }
    }

  // ⬇️ 화면에 보이는 값(_elapsed) 그대로부터 카운트 시작
  _sw.start(initialElapsed: _elapsed.inMilliseconds);

    // UI 틱 시작
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => setState(() => _elapsed = _sw.elapsed),
    );

    setState(() {}); // 버튼 상태 갱신
  }

  // 간단 확인 다이얼로그
  Future<bool?> _askResumeOrNew() async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('진행 중 세션'),
        content: const Text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('새로 시작')),
          TextButton(onPressed: () => Navigator.pop(ctx, true),  child: const Text('이어하기')),
        ],
      ),
    );
  }

  Future<void> _pause() async {
    if (!_sw.isRunning) return;

    final nowMs = DateTime.now().millisecondsSinceEpoch;

    // 1) DB에 세션 상태 반영
    await appDb.pauseSession(projectId: widget.projectId, nowMs: nowMs);

    // 2) 래퍼 스톱워치 멈춤
    _sw.pause();

    // 3) UI 틱 중단
    _ticker?.cancel();

    // 4) 화면 상태 갱신
    setState(() {
      _elapsed = _sw.elapsed; // Duration 타입
    });
  }

  Future<void> _resetSession() async {
    await appDb.discardActiveSession(projectId: widget.projectId);
    await _refreshFromDB(); // DB 기준으로 누적 시간 복원
  }

  Future<void> _refreshFromDB() async {
    // 1) 종료된 세션 합계 (stopped만)
    final totalDone = await appDb.totalElapsedMs(projectId: widget.projectId);

    // 2) 현재 활성 세션 (running/paused)
    final active = await appDb.getActiveSession(widget.projectId);

    int viewMs = totalDone;

    if (active != null) {
      final base = active.elapsedMs;

      // 진행 중이면 lastStartedAt부터 지금까지 더해줌
      final add = (active.status == SessionStatus.running && active.lastStartedAt != null)
          ? (DateTime.now().millisecondsSinceEpoch - active.lastStartedAt!).clamp(0, 1 << 30)
          : 0;

      viewMs += base + add;
    }

    // 3) UI 갱신
    setState(() {
      _elapsed = Duration(milliseconds: viewMs);
    });
  }

  bool get _canSaveLap => _sw.elapsed > _lastLapAt;

  Future<void> _saveLapFlow() async {
    if (_lapBusy) return; // 재진입 방지
    _lapBusy = true;
    try {
      // 1) now 고정 + 달리는 중이면 먼저 일시정지
      final freezeNow = _sw.elapsed;
      if (_sw.isRunning) _pause(); // _pause는 _elapsed를 갱신함

      final segment = freezeNow - _lastLapAt;
      if (segment <= Duration.zero) return; // 0초 랩 방지

      // 시트 호출
      final res = await showEndSessionSheet(
        context: context,
        segment: segment,
        initialLabel: currentLabel,
        onPickLabel: (initial) => _openLabelPicker(initial: initial),
      );
      if (!mounted || res == null || res.confirmed != true) return;
      
      // 3) DB: 세션 종료 & 라벨/메모 동시 저장
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      await appDb.stopSession(
        projectId: widget.projectId,               // ← 너의 현재 프로젝트 ID
        nowMs: nowMs,
        label: res.label,                    // 전달 시 업데이트, null이면 유지
        memo: (res.memo?.isEmpty ?? true) ? null : res.memo,    // 전달 시 업데이트, null이면 유지
      );

    await _refreshFromDB();

    // 4) 로컬 상태 정리 (UI 반영)
    _lastLapAt = freezeNow;
    setState(() {});
  } finally {
    _lapBusy = false;
  }
}

// iOS/Android 공용 라벨 선택기: 선택한 라벨(String?)을 리턴
Future<String?> _openLabelPicker({String? initial}) async {
  if (Platform.isIOS) {
    // iOS: Cupertino 스타일 (modal_bottom_sheet 사용)
    return showCupertinoModalBottomSheet<String>(
      context: context,
      expand: false,
      backgroundColor: CupertinoColors.systemBackground,
      builder: (ctx) {
        final bottomPad = MediaQuery.of(ctx).viewInsets.bottom;
        return SafeArea(
          top: false,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 14,
              color: CupertinoColors.label,        // ← 기본 라벨 컬러 강제
              decoration: TextDecoration.none,     // ← 밑줄 제거
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 상단 제목 + 라벨 관리 버튼
                  Row(
                    children: [
                      const Text(
                        '라벨 선택',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.pencil),
                        onPressed: () async {
                          final updated = await _openLabelManager(ctx, labels);
                          if (updated != null) {
                            setState(() => labels = updated);
                            if (currentLabel != null &&
                                !labels.contains(currentLabel)) {
                              currentLabel = labels.isNotEmpty ? labels.first : null;
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CupertinoScrollbar(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8, runSpacing: 8,
                        children: [
                          for (final l in labels)
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              borderRadius: BorderRadius.circular(20),
                              color: (initial == l)
                                  ? CupertinoColors.activeBlue
                                  : CupertinoColors.systemGrey6,
                              onPressed: () => Navigator.pop(ctx, l),
                              child: Text(
                                l,
                                style: TextStyle(
                                  color: (initial == l)
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                                  fontSize: 16, fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            borderRadius: BorderRadius.circular(20),
                            color: (initial == null)
                                ? CupertinoColors.activeBlue
                                : CupertinoColors.systemGrey6,
                            onPressed: () => Navigator.pop(ctx, null),
                            child: Text(
                              '미분류',
                              style: TextStyle(
                                color: (initial == null)
                                    ? CupertinoColors.white
                                    : CupertinoColors.black,
                                fontSize: 16, fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        );
      },
    );
  } else {
    // Android: Material 바텀시트 + ChoiceChip
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final bottomPad = MediaQuery.of(ctx).viewInsets.bottom +
            MediaQuery.of(ctx).viewPadding.bottom;
        return SafeArea(
          top: true, left: true, right: true, bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 제목 + 라벨 관리 버튼
                Row(
                  children: [
                    const Text(
                      '라벨 선택',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: '라벨 관리',
                      onPressed: () async {
                        final updated = await _openLabelManager(ctx, labels);
                        if (updated != null) {
                          setState(() => labels = updated);
                          if (currentLabel != null &&
                              !labels.contains(currentLabel)) {
                            currentLabel = labels.isNotEmpty ? labels.first : null;
                          }
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [
                    for (final l in labels)
                      ChoiceChip(
                        label: Text(l),
                        selected: initial == l,
                        onSelected: (_) => Navigator.pop(ctx, l),
                      ),
                    ChoiceChip(
                      label: const Text('미분류'),
                      selected: initial == null,
                      onSelected: (_) => Navigator.pop(ctx, null),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


  Future<List<String>?> _openLabelManager(
    BuildContext ctx,
    List<String> initial,
  ) async {
    final temp = [...initial];
    final controller = TextEditingController();
    return showModalBottomSheet<List<String>>(
      context: ctx,
      isScrollControlled: true,
      builder: (ctx2) {
        final mq = MediaQuery.of(ctx2);
        final bottomPad = mq.viewInsets.bottom + mq.viewPadding.bottom;

        return SafeArea(
          top: true,
          left: true,
          right: true,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
            child: StatefulBuilder(
              builder: (_, setSB) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '라벨 관리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final l in temp)
                        Chip(
                          label: Text(l),
                          onDeleted: () => setSB(() => temp.remove(l)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: '라벨 추가',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (v) {
                            final t = v.trim();
                            if (t.isNotEmpty && !temp.contains(t)) {
                              setSB(() => temp.add(t));
                            }
                            controller.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final t = controller.text.trim();
                          if (t.isNotEmpty && !temp.contains(t)) {
                            setSB(() => temp.add(t));
                          }
                          controller.clear();
                        },
                        child: const Text('추가'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx2, null),
                        child: const Text('취소'),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx2, temp),
                        child: const Text('저장'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        // ── 타이머 카드(라벨 + 시간) ───────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: _TimerCard(
            timeText: fmt(_elapsed),
            labelText: currentLabel ?? '미분류',
            onTapLabel: () async {
              final picked = await _openLabelPicker(initial: currentLabel);
              if (picked != null || picked == null) {
                setState(() => currentLabel = picked);
              }
            },
          ),
        ),

        // 컨트롤 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(_sw.isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_sw.isRunning ? '일시정지' : '시작'),
                  onPressed: _busy
                    ? null
                    : () async {
                        _busy = true;
                        try {
                          if (_sw.isRunning) {
                            await _pause();   
                          } else {
                            await _start();   // active 체크→ 이어/새로 로직 포함
                          }
                          setState(() {});    // 아이콘/라벨 갱신
                        } finally {
                          _busy = false;
                        }
                      },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.flag),
                  label: const Text('랩'),
                  onPressed: _canSaveLap ? _saveLapFlow : null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: '세션 초기화',
                onPressed: _resetSession,
                icon: const Icon(Icons.refresh),
              ),
            ],
          )
        ),
        // 종료된 세션 리스트
        Expanded(
          child: StreamBuilder<List<WorkSession>>(
            stream: _stream,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snap.data ?? const [];
              if (items.isEmpty) {
                return const Center(child: Text('완료된 세션이 없습니다'));
              }

              // 최신순 정렬 가정: 표시용 Lap 번호를 1부터 증가로 매김
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = items[i];

                  // 표시용 값들
                  final lapNo = i + 1;
                  final segment = Duration(milliseconds: s.elapsedMs); // 세션 소요시간
                  final started = DateTime.fromMillisecondsSinceEpoch(s.startedAt);
                  final stopped = (s.stoppedAt != null)
                      ? DateTime.fromMillisecondsSinceEpoch(s.stoppedAt!)
                      : null;

                  return ListTile(
                    dense: true,
                    leading: Text('Lap $lapNo'),
                    title: Text(fmt(segment)), // hh:mm:ss
                    subtitle: Text([
                      if ((s.label ?? '').isNotEmpty) '라벨: ${s.label}',
                      if (stopped != null) '기간: ${ymdHm(started)} ~ ${ymdHm(stopped)}',
                      '누적: ${fmt(segment)}',
                      if ((s.memo ?? '').isNotEmpty) '메모: ${s.memo}',
                    ].join(' • ')),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 카드 위젯: 상단 중앙 라벨 + 중앙 큰 시간
class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.timeText,
    required this.labelText,
    required this.onTapLabel,
  });

  final String timeText;
  final String labelText;
  final VoidCallback onTapLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = Platform.isIOS;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.6),
        ),
        boxShadow: kElevationToShadow[1],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 라벨 (상단 중앙)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: LabelPill(
              text: labelText,
              onTap: onTapLabel,
              isIOS: isIOS,
            ),
          ),
          // 큰 시간
          Expanded(
            child: Center(
              child: Text(
                timeText,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()], // ← 숫자 폭 고정
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lap {
  final int index;
  final Duration timeFromStart;
  final Duration segment;
  final String label;
  final String? note;
  _Lap({
    required this.index,
    required this.timeFromStart,
    required this.segment,
    required this.label,
    this.note,
  });
}
