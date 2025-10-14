import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/common/session_dialog_helper.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';
import 'package:yarnie/providers/counter_provider.dart';
import 'package:yarnie/widget/count_by_selector.dart';
import 'package:yarnie/widget/sub_counter_item.dart';

/// 카운터 패널 위젯
///
/// 요구사항을 모두 만족하는 완전한 카운터 기능을 제공합니다:
/// - 스톱워치 연동 표시 (요구사항 1)
/// - 메인/서브 카운터 관리 (요구사항 2, 3)
/// - 카운트 단위 설정 (요구사항 4)
/// - 카운터 증감 기능 (요구사항 5)
/// - 데이터 자동 저장/복원 (요구사항 6, 7)
/// - 플랫폼별 네이티브 UI (요구사항 8)
class CounterPanel extends ConsumerStatefulWidget {
  final int projectId;

  const CounterPanel({super.key, required this.projectId});

  @override
  ConsumerState<CounterPanel> createState() => _CounterPanelState();
}

class _CounterPanelState extends ConsumerState<CounterPanel> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 해당 프로젝트의 카운터 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(counterProvider.notifier).initializeForProject(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final swState = ref.watch(stopwatchProvider);
    final counterState = ref.watch(counterProvider);

    return SafeArea(
      bottom: true, // 하단 네비게이션 바와의 충돌 방지
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // 1. 스톱워치 표시 영역
              Container(child: _buildStopwatchIndicator(swState)),

              // 2. +/- 버튼 + 중앙 원형 숫자 + count by selector
              _buildMainCounterButtons(
                value: counterState.mainCounter,
                onReset: () => ref.read(counterProvider.notifier).resetMain(),
              ),

              // 3. Add SubCounter 버튼 (조건부)
              if (!counterState.hasSubCounter) _buildAddCounterButton(),

              // 4. 서브 카운터 영역 (조건부)
              if (counterState.hasSubCounter)
                _buildSubCounterArea(counterState),
            ],
          );
        },
      ),
    );
  }

  /// 요구사항 1.1, 1.2, 1.3: 스톱워치 연동 표시 영역
  /// 스톱워치가 실행 중일 때만 상단에 작은 스톱워치 표시
  /// 시작/일시정지 버튼으로 스톱워치 제어 가능
  Widget _buildStopwatchIndicator(StopwatchState swState) {
    return Container(
      color: Platform.isIOS
          ? CupertinoColors.systemGrey6
          : Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 플랫폼별 타이머 아이콘 (요구사항 8)
          Icon(
            Platform.isIOS ? CupertinoIcons.timer : Icons.timer_outlined,
            size: 20,
            color: Platform.isIOS ? CupertinoColors.systemBlue : null,
          ),
          const SizedBox(width: 8),
          // 스톱워치 시간 표시
          Text(
            fmt(swState.elapsed),
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const Spacer(),
          // 시작/일시정지 버튼 (플랫폼별 스타일)
          SizedBox(
            height: 32,
            child: Platform.isIOS
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (swState.isRunning) {
                        // 일시정지 로직 (기존과 동일)
                        final notifier = ref.read(stopwatchProvider.notifier);
                        notifier.pause();
                        await appDb.pauseSession(projectId: widget.projectId);
                      } else {
                        // 시작 로직 (공통 헬퍼 사용)
                        await SessionDialogHelper.startStopwatch(
                          context: context,
                          ref: ref,
                          projectId: widget.projectId,
                        );
                      }
                    },
                    child: Icon(
                      swState.isRunning
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      size: 16,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      if (swState.isRunning) {
                        // 일시정지 로직 (기존과 동일)
                        final notifier = ref.read(stopwatchProvider.notifier);
                        notifier.pause();
                        await appDb.pauseSession(projectId: widget.projectId);
                      } else {
                        // 시작 로직 (공통 헬퍼 사용)
                        await SessionDialogHelper.startStopwatch(
                          context: context,
                          ref: ref,
                          projectId: widget.projectId,
                        );
                      }
                    },
                    icon: Icon(
                      swState.isRunning ? Icons.pause : Icons.play_arrow,
                      size: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 요구사항 2.1, 5.5: Add SubCounter 버튼
  /// 서브 카운터가 없을 때만 표시되며, +/- 버튼 아래에 중앙정렬로 배치
  /// 클릭 시 서브 카운터 생성, 서브 카운터 삭제 시 다시 표시
  Widget _buildAddCounterButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Platform.isIOS
            ? CupertinoButton.filled(
                onPressed: () =>
                    ref.read(counterProvider.notifier).addSubCounter(),
                child: const Text('Add SubCounter'),
              )
            : ElevatedButton.icon(
                onPressed: () =>
                    ref.read(counterProvider.notifier).addSubCounter(),
                icon: const Icon(Icons.add),
                label: const Text('Add SubCounter'),
              ),
      ),
    );
  }

  /// 요구사항 5.1, 5.2, 5.3, 5.4: 메인 카운터 +/- 버튼 영역
  /// 메인 카운터 버튼 + 중앙 원형 숫자(오버레이) + countby selector
  Widget _buildMainCounterButtons({
    required int value,
    required VoidCallback onReset,
  }) {
    final state = ref.watch(counterProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonWidth = constraints.maxWidth / 2;
        final buttonHeight = buttonWidth * 1.5;

        return Container(
          height: buttonHeight,
          margin: const EdgeInsets.only(bottom: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 좌/우 꽉 채운 - / +
              Row(
                children: [
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: Platform.isIOS
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            color: const Color.fromARGB(255, 114, 163, 68),
                            onPressed: () => ref
                                .read(counterProvider.notifier)
                                .decrementMain(),
                            child: const Icon(
                              CupertinoIcons.minus,
                              size: 32,
                              color: CupertinoColors.white,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(114, 163, 68, 1.0),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(),
                            ),
                            onPressed: () => ref
                                .read(counterProvider.notifier)
                                .decrementMain(),
                            child: const Icon(Icons.remove, size: 32),
                          ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: Platform.isIOS
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            color: const Color.fromARGB(255, 247, 200, 102),
                            onPressed: () => ref
                                .read(counterProvider.notifier)
                                .incrementMain(),
                            child: const Icon(
                              CupertinoIcons.plus,
                              size: 32,
                              color: CupertinoColors.white,
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(247, 200, 102, 1.0),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(),
                            ),
                            onPressed: () => ref
                                .read(counterProvider.notifier)
                                .incrementMain(),
                            child: const Icon(Icons.add, size: 32),
                          ),
                  ),
                ],
              ),

              // 중앙 숫자 원 (롱탭=초기화)
              GestureDetector(
                onLongPress: () async {
                  final ok = await _confirmReset(context);
                  if (ok) onReset();
                },
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$value',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // ▶︎ + 버튼 영역 우상단 배지 = CountBySelector 자체 (size: small)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: CountBySelector(
                    currentValue: state.mainCountBy,
                    onChanged: (v) =>
                        ref.read(counterProvider.notifier).setMainCountBy(v),
                    size: CountBySelectorSize.small,
                    labelStyle: CountByLabelStyle.short,
                    chipStyle: CountByChipStyle.outlined,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 리셋 확인 다이얼로그 (플랫폼별)
  Future<bool> _confirmReset(BuildContext context) async {
    if (Platform.isIOS) {
      final res = await showCupertinoDialog<bool>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('카운터 초기화'),
          content: const Text('카운터를 0으로 초기화하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('초기화'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
      return res ?? false;
    } else {
      final res = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('카운터 초기화'),
          content: const Text('카운터를 0으로 초기화하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('초기화'),
            ),
          ],
        ),
      );
      return res ?? false;
    }
  }

  /// 요구사항 2.1, 4.1, 4.2: 서브 카운터 영역
  /// 서브 카운터가 있을 때만 표시되는 조건부 렌더링
  /// "- [ 숫자 ] +" 형태의 간소한 UI와 count by 설정 포함
  Widget _buildSubCounterArea(CounterState counterState) {
    final isIOS = Platform.isIOS;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isIOS ? CupertinoColors.systemGrey6 : Colors.grey.shade100,
        border: Border(
          top: BorderSide(
            color: isIOS ? CupertinoColors.separator : Colors.grey.shade300,
          ),
        ),
      ),
      child: SubCounterItem(
        value: counterState.subCounter ?? 0,
        onIncrement: () => ref.read(counterProvider.notifier).incrementSub(),
        onDecrement: () => ref.read(counterProvider.notifier).decrementSub(),
        onDelete: () {
          ref.read(counterProvider.notifier).removeSubCounter();
          // Android에서는 Dismissible에 의해 호출되고, iOS에서는 버튼에 의해 호출됨
          // Android의 Undo 기능을 위해 SnackBar를 표시
          if (!isIOS) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('서브 카운터를 삭제했어요'),
                action: SnackBarAction(
                  label: '되돌리기',
                  onPressed: () =>
                      ref.read(counterProvider.notifier).addSubCounter(),
                ),
              ),
            );
          }
        },
        onReset: () async {
          final ok = await _confirmReset(context);
          if (ok) ref.read(counterProvider.notifier).resetSub();
        },
        countByValue: counterState.subCountBy,
        onCountByChanged: (value) =>
            ref.read(counterProvider.notifier).setSubCountBy(value),
      ),
    );
  }
}
