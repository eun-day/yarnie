import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CountByLabelStyle { short, full }

enum CountByChipStyle { outlined, filled }

/// Count By 값을 선택하기 위한 위젯
/// 메인 카운터와 서브 카운터 모두에서 사용 가능
class CountBySelector extends StatelessWidget {
  /// 현재 설정된 count by 값
  final int currentValue;

  /// count by 값이 변경될 때 호출되는 콜백
  final ValueChanged<int> onChanged;

  /// 위젯의 크기 (기본값: 중간 크기)
  final CountBySelectorSize size;

  final CountByLabelStyle labelStyle;
  final CountByChipStyle chipStyle;

  const CountBySelector({
    super.key,
    required this.currentValue,
    required this.onChanged,
    this.size = CountBySelectorSize.small,
    this.labelStyle = CountByLabelStyle.full,
    this.chipStyle = CountByChipStyle.filled,
  });

  String _labelText(BuildContext context) {
    switch (labelStyle) {
      case CountByLabelStyle.short:
        return '+$currentValue'; // 예: +8
      case CountByLabelStyle.full:
      default:
        return 'count by $currentValue'; // 예: count by 8
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = _labelText(context);

    // 플랫폼별 UI 분기
    if (Platform.isIOS) {
      return _buildCupertinoButton(context, label);
    } else {
      return _buildMaterialButton(context, label);
    }
  }

  /// iOS용 Cupertino 스타일 버튼
  Widget _buildCupertinoButton(BuildContext context, String label) {
    final isFilled = chipStyle == CountByChipStyle.filled;

    return CupertinoButton(
      padding: _getPadding(),
      onPressed: () => _showCountByPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isFilled
              ? CupertinoColors.activeBlue
              : CupertinoColors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFilled
                ? CupertinoColors.activeBlue
                : CupertinoColors.white, // ✅ outlined=white border
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: _getTextStyle(context).copyWith(
            color: isFilled
                ? CupertinoColors.white
                : CupertinoColors.white, // ✅ outlined=white text
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Android/기타 플랫폼용 Material 스타일 버튼 (LabelPill과 동일한 스타일)
  Widget _buildMaterialButton(BuildContext context, String label) {
    final isFilled = chipStyle == CountByChipStyle.filled;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showCountByPicker(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isFilled ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFilled
                ? scheme.primary
                : Colors.white, // ✅ outlined=white border
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isFilled
                ? scheme.onPrimary
                : Colors.white, // ✅ outlined=white text
          ),
        ),
      ),
    );
  }

  /// Count By 선택 팝업 표시
  void _showCountByPicker(BuildContext context) {
    if (Platform.isIOS) {
      _showCupertinoPicker(context);
    } else {
      _showMaterialPicker(context);
    }
  }

  /// iOS용 Cupertino 피커 표시
  void _showCupertinoPicker(BuildContext context) {
    int selectedValue = currentValue;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Container(
            height: 250,
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              children: [
                // 헤더 영역
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: CupertinoColors.systemGrey4.resolveFrom(context),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('취소'),
                      ),
                      const Text(
                        'Count By 설정',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          onChanged(selectedValue);
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                ),
                // 피커 영역
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedValue - 1, // 1-based to 0-based
                    ),
                    onSelectedItemChanged: (int index) {
                      selectedValue = index + 1; // 0-based to 1-based
                    },
                    children: List.generate(10, (index) {
                      final value = index + 1;
                      return Center(
                        child: Text(
                          '$value',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMaterialPicker(BuildContext context) {
    int selectedValue = currentValue;
    final controller = FixedExtentScrollController(
      initialItem: selectedValue - 1,
    );

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final itemExtent = 50.0;
            final colorScheme = Theme.of(context).colorScheme;

            return Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('취소'),
                      ),
                      const Text(
                        'Count By 설정',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          onChanged(selectedValue);
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 피커
                  Expanded(
                    child: Stack(
                      children: [
                        // 휠
                        ListWheelScrollView.useDelegate(
                          itemExtent: itemExtent,
                          controller: controller,
                          physics: const FixedExtentScrollPhysics(),
                          perspective: 0.003, // 3D 효과 유지
                          diameterRatio: 2.0,
                          onSelectedItemChanged: (int index) {
                            setState(() => selectedValue = index + 1);
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: 10,
                            builder: (context, index) {
                              if (index < 0 || index >= 10) return null;
                              final value = index + 1;
                              final isSelected = (value == selectedValue);

                              return Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 120),
                                  style: TextStyle(
                                    fontSize: isSelected ? 24 : 22,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurface.withValues(
                                            alpha: 0.38,
                                          ),
                                  ),
                                  child: Text('$value'),
                                ),
                              );
                            },
                          ),
                        ),

                        // 중앙 선택 박스(하이라이트)
                        IgnorePointer(
                          child: Center(
                            child: Container(
                              height: itemExtent,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // 필요 없으면 투명 유지
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// 크기에 따른 패딩 반환
  EdgeInsets _getPadding() {
    switch (size) {
      case CountBySelectorSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case CountBySelectorSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case CountBySelectorSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  /// 크기에 따른 텍스트 스타일 반환
  TextStyle _getTextStyle(BuildContext context) {
    final baseStyle = Platform.isIOS
        ? CupertinoTheme.of(context).textTheme.textStyle
        : Theme.of(context).textTheme.bodyMedium;

    switch (size) {
      case CountBySelectorSize.small:
        return baseStyle?.copyWith(fontSize: 12) ??
            const TextStyle(fontSize: 12);
      case CountBySelectorSize.medium:
        return baseStyle?.copyWith(fontSize: 14) ??
            const TextStyle(fontSize: 14);
      case CountBySelectorSize.large:
        return baseStyle?.copyWith(fontSize: 16) ??
            const TextStyle(fontSize: 16);
    }
  }
}

/// Count By 선택기 위젯의 크기 옵션
enum CountBySelectorSize {
  /// 작은 크기 (서브 카운터용)
  small,

  /// 중간 크기 (기본값)
  medium,

  /// 큰 크기 (메인 카운터용)
  large,
}
