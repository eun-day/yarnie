import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/common/session_dialog_helper.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/features/projects/end_session_result.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';
import 'package:yarnie/widgets/session_log_tile.dart';
import 'package:yarnie/widgets/timer_card.dart';

/// 스톱워치 패널(Scaffold 없음) — 화면 어디든 끼워 넣기용
class StopwatchPanel extends ConsumerStatefulWidget {
  final List<String> initialLabels;
  final int projectId;

  const StopwatchPanel({
    super.key,
    this.initialLabels = const ['소매', '몸통', '목둘레'],
    required this.projectId,
  });
  @override
  ConsumerState<StopwatchPanel> createState() => _StopwatchPanelState();
}

class _StopwatchPanelState extends ConsumerState<StopwatchPanel>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 라벨
  late List<String> labels = [...widget.initialLabels];
  String? currentLabel;

  bool _busy = false;
  bool _lapBusy = false;
  late final Stream<List<WorkSession>> _stream;
  int _lastSegment = 0;

  @override
  void initState() {
    super.initState();
    currentLabel = widget.initialLabels.firstOrNull;
    _stream = appDb.watchCompletedSessions(widget.projectId);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshFromDB());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _start() async {
    await SessionDialogHelper.startStopwatch(
      context: context,
      ref: ref,
      projectId: widget.projectId,
    );
  }

  Future<int> _pause() async {
    final swNotifier = ref.read(stopwatchProvider.notifier);
    if (!ref.read(stopwatchProvider).isRunning) return -1;

    // 1) 래퍼 스톱워치 멈춤
    swNotifier.pause();

    // 2) DB에 세션 상태 반영
    final newElapsedSec = await appDb.pauseSession(projectId: widget.projectId);
    _lastSegment = newElapsedSec;

    return newElapsedSec;
  }

  Future<void> _resetSession() async {
    final swNotifier = ref.read(stopwatchProvider.notifier);
    await appDb.discardActiveSession(projectId: widget.projectId);
    swNotifier.reset();
    await _refreshFromDB(); // DB 기준으로 누적 시간 복원
  }

  Future<void> _refreshFromDB() async {
    final swNotifier = ref.read(stopwatchProvider.notifier);
    final elapsed = await appDb.totalElapsedDuration(
      projectId: widget.projectId,
    );
    swNotifier.setElapsed(elapsed);
  }

  Future<void> _saveLapFlow() async {
    if (_lapBusy) return; // 재진입 방지
    _lapBusy = true;
    try {
      // 1) now 고정 + 달리는 중이면 먼저 일시정지
      if (ref.read(stopwatchProvider).isRunning) {
        await _pause(); // _pause는 _elapsed를 갱신함 -> 타이머 실행 중에만 업데이트
      }

      if (!mounted) return;

      // 시트 호출
      final res = await showEndSessionSheet(
        context: context,
        segment: Duration(seconds: _lastSegment),
        initialLabel: currentLabel,
        onPickLabel: (initial) => _openLabelPicker(initial: initial),
      );
      if (res == null || res.confirmed != true) return;

      // 3) DB: 세션 종료 & 라벨/메모 동시 저장
      await appDb.stopSession(
        projectId: widget.projectId, // ← 너의 현재 프로젝트 ID
        label: res.label, // 전달 시 업데이트, null이면 유지
        memo: (res.memo?.isEmpty ?? true)
            ? null
            : res.memo, // 전달 시 업데이트, null이면 유지
      );

      await _refreshFromDB();

      // 4) 로컬 상태 정리 (UI 반영)
      _lastSegment = 0;
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
          return Material(
            type: MaterialType.transparency,
            child: SafeArea(
              top: false,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.pencil),
                          onPressed: () async {
                            final updated = await _openLabelManager(
                              ctx,
                              labels,
                            );
                            if (updated != null) {
                              setState(() => labels = updated);
                              if (currentLabel != null &&
                                  !labels.contains(currentLabel)) {
                                currentLabel = labels.isNotEmpty
                                    ? labels.first
                                    : null;
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
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final l in labels)
                              CupertinoButton(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
            ),
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
          final bottomPad =
              MediaQuery.of(ctx).viewInsets.bottom +
              MediaQuery.of(ctx).viewPadding.bottom;
          return SafeArea(
            top: true,
            left: true,
            right: true,
            bottom: false,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                              currentLabel = labels.isNotEmpty
                                  ? labels.first
                                  : null;
                            }
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
    final swState = ref.watch(stopwatchProvider);

    return Column(
      children: [
        // ── 타이머 카드(라벨 + 시간) ───────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TimerCard(
            timeText: fmt(swState.elapsed),
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
                  icon: Icon(
                    swState.isRunning ? Icons.pause : Icons.play_arrow,
                  ),
                  label: Text(swState.isRunning ? '일시정지' : '시작'),
                  onPressed: _busy
                      ? null
                      : () async {
                          _busy = true;
                          try {
                            if (swState.isRunning) {
                              await _pause();
                            } else {
                              await _start(); // active 체크→ 이어/새로 로직 포함
                            }
                            setState(() {}); // 아이콘/라벨 갱신
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
                  onPressed: _saveLapFlow,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: '세션 초기화',
                onPressed: _resetSession,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
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

              // 최신순 정렬된 리스트에서 역순 번호 매기기
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: items.length,
                separatorBuilder: (_, i) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = items[i];

                  // 표시용 값들 - 정순 번호 (오래된 기록이 1번)
                  final logNo = items.length - i;
                  final segment = Duration(
                    seconds: s.elapsedMs.toSec(),
                  ); // 세션 소요시간

                  return SessionLogTile(
                    logNo: logNo,
                    duration: segment,
                    label: s.label,
                    memo: s.memo,
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
