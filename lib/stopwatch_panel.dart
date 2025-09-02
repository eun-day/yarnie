import 'dart:io' show Platform;
import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 스톱워치 패널(Scaffold 없음) — 화면 어디든 끼워 넣기용
class StopwatchPanel extends StatefulWidget {
  final List<String> initialLabels;
  const StopwatchPanel({
    super.key,
    this.initialLabels = const ['소매', '몸통', '목둘레'],
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
  final Stopwatch _sw = Stopwatch();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

  // 랩
  final List<_Lap> _laps = [];
  Duration _lastLapAt = Duration.zero;

  @override
  void initState() {
    super.initState();
    if (labels.isNotEmpty) currentLabel = labels.first;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _start() {
    if (_sw.isRunning) return;
    _sw.start();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => setState(() => _elapsed = _sw.elapsed),
    );
  }

  void _pause() {
    if (!_sw.isRunning) return;
    _sw.stop();
    _ticker?.cancel();
    setState(() => _elapsed = _sw.elapsed);
  }

  void _resetSession() {
    _sw.reset();
    _ticker?.cancel();
    setState(() {
      _elapsed = Duration.zero;
      _laps.clear();
      _lastLapAt = Duration.zero;
    });
  }

bool get _canSaveLap =>
    _sw.elapsedMilliseconds > _lastLapAt.inMilliseconds;

void _saveLap() {
  // 1) 달리는 중이면 먼저 멈춤( _elapsed 업데이트 포함 )
  if (_sw.isRunning) {
    _pause(); // _sw.stop() + _ticker cancel + setState(_elapsed)
  }

  // 2) 일시정지 상태에서 now 기준으로 구간 계산
  final now = _sw.elapsed;
  final segment = now - _lastLapAt;

  if (segment <= Duration.zero) {
    // 저장할 시간이 없으면 무시
    return;
  }

  _laps.insert(
    0,
    _Lap(
      index: _laps.length + 1,
      timeFromStart: now,
      segment: segment,
      label: currentLabel ?? '미분류',
    ),
  );

  // 3) 기준점(now) 업데이트. 상태는 '일시정지' 유지
  _lastLapAt = now;
  setState(() {});
}

String _fmt(Duration d) {
  final h = d.inHours.toString().padLeft(2, '0');
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

  Future<void> _openLabelPicker() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        final bottomPad = mq.viewInsets.bottom + mq.viewPadding.bottom;

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
                            currentLabel =
                                labels.isNotEmpty ? labels.first : null;
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
                        selected: currentLabel == l,
                        onSelected: (_) {
                          setState(() => currentLabel = l);
                          Navigator.pop(ctx);
                        },
                      ),
                    ChoiceChip(
                      label: const Text('미분류'),
                      selected: currentLabel == null,
                      onSelected: (_) {
                        setState(() => currentLabel = null);
                        Navigator.pop(ctx);
                      },
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
            timeText: _fmt(_elapsed),
            labelText: currentLabel ?? '미분류',
            onTapLabel: _openLabelPicker,
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
                  onPressed: () => setState(() => _sw.isRunning ? _pause() : _start()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.flag),
                  label: const Text('랩'),
                  onPressed: _canSaveLap ? _saveLap : null, // ← 달리든 멈추든 가능, 0초 방지
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

        // 랩 리스트
        Expanded(
          child: _laps.isEmpty
              ? const Center(child: Text('랩 기록이 없습니다'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _laps.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final lap = _laps[i];
                    return ListTile(
                      dense: true,
                      leading: Text('Lap ${lap.index}'),
                      title: Text(_fmt(lap.segment)),
                      subtitle: Text(
                        '라벨: ${lap.label} • 누적: ${_fmt(lap.timeFromStart)}',
                      ),
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
            child: _LabelPill(
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


class _LabelPill extends StatelessWidget {
  const _LabelPill({
    required this.text,
    required this.onTap,
    required this.isIOS,
  });

  final String text;
  final VoidCallback onTap;
  final bool isIOS;

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        borderRadius: BorderRadius.circular(20),
        color: CupertinoColors.systemGrey6,
        onPressed: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 26), // 칩 높이 느낌
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(CupertinoIcons.chevron_down,
                  size: 16, color: CupertinoColors.black),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
              Theme.of(context).colorScheme.surface,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.expand_more, size: 18),
            ],
          ),
        ),
      );
    }
  }
}

class _Lap {
  final int index;
  final Duration timeFromStart;
  final Duration segment;
  final String label;
  _Lap({
    required this.index,
    required this.timeFromStart,
    required this.segment,
    required this.label,
  });
}
