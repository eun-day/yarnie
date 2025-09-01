import 'dart:io' show Platform;
import 'dart:async';
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

  void _lap() {
    final now = _sw.elapsed;
    final segment = now - _lastLapAt;
    _laps.insert(
      0,
      _Lap(
        index: _laps.length + 1,
        timeFromStart: now,
        segment: segment,
        label: currentLabel ?? '미분류',
      ),
    );
    _lastLapAt = now;
    setState(() {});
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final cs = (d.inMilliseconds.remainder(1000) / 10)
        .floor()
        .toString()
        .padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s.$cs';
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
                            if (t.isNotEmpty && !temp.contains(t))
                              setSB(() => temp.add(t));
                            controller.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final t = controller.text.trim();
                          if (t.isNotEmpty && !temp.contains(t))
                            setSB(() => temp.add(t));
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
    const chipHeight = 40.0;
    return Column(
      children: [
        // // 라벨: 가로 스크롤 + 더보기
        // SizedBox(
        //   height: chipHeight + 16,
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: ListView.separated(
        //           padding: const EdgeInsets.symmetric(
        //             horizontal: 12,
        //             vertical: 8,
        //           ),
        //           scrollDirection: Axis.horizontal,
        //           itemBuilder: (_, i) {
        //             if (i < labels.length) {
        //               final l = labels[i];
        //               return ChoiceChip(
        //                 label: Text(l),
        //                 selected: currentLabel == l,
        //                 onSelected: (_) => setState(() => currentLabel = l),
        //               );
        //             } else {
        //               return ActionChip(
        //                 label: const Text('더보기'),
        //                 avatar: const Icon(Icons.expand_more),
        //                 onPressed: _openLabelPicker,
        //               );
        //             }
        //           },
        //           separatorBuilder: (_, __) => const SizedBox(width: 8),
        //           itemCount: labels.length + 1,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        buildLabelBar(
          labels: labels,
          currentLabel: currentLabel,
          onChanged: (v) => setState(() => currentLabel = v),
          onMore: _openLabelPicker,
          height: chipHeight + 16,
        ),
        const Divider(height: 1),

        // 큰 타이머
        Expanded(
          child: Center(
            child: Text(
              _fmt(_elapsed),
              style: const TextStyle(
                fontSize: 64,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
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
                  onPressed: () =>
                      setState(() => _sw.isRunning ? _pause() : _start()),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.flag),
                  label: const Text('랩'),
                  onPressed: _sw.isRunning ? _lap : null,
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

  Widget buildLabelBar({
    required List<String> labels,
    required String? currentLabel,
    required ValueChanged<String?> onChanged,
    required VoidCallback onMore,
    double height = 56, // chipHeight + 여백
  }) {
    final isIOS = Platform.isIOS;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: labels.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                if (i < labels.length) {
                  final l = labels[i];
                  final selected = currentLabel == l;
                  return _buildLabelChip(
                    label: l,
                    selected: selected,
                    onTap: () => onChanged(l),
                    isIOS: isIOS,
                  );
                } else {
                  return _buildMoreButton(isIOS: isIOS, onTap: onMore);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool isIOS,
  }) {
    if (isIOS) {
      // iOS: 사각에 가까운 얕은 라운드(세그먼트 느낌)
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? CupertinoColors.activeBlue
                : CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: selected ? CupertinoColors.white : CupertinoColors.black,
              fontSize: 14,
            ),
            child: Text(label),
          ),
        ),
      );
    } else {
      // Android(Material): 칩 스타일, 약간 둥글게
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (_) => onTap(),
      );
    }
  }

  Widget _buildMoreButton({required bool isIOS, required VoidCallback onTap}) {
    if (isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minSize: 32,
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(6),
        onPressed: onTap,
        child: Row(
          children: const [
            Text('더보기', style: TextStyle(color: CupertinoColors.black)),
            SizedBox(width: 4),
            Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: CupertinoColors.black,
            ),
          ],
        ),
      );
    } else {
      return ActionChip(
        label: const Text('더보기'),
        avatar: const Icon(Icons.expand_more),
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
