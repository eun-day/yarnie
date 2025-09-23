import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Count By 값을 선택하기 위한 위젯
/// 메인 카운터와 서브 카운터 모두에서 사용 가능
class CountBySelector extends StatelessWidget {
  /// 현재 설정된 count by 값
  final int currentValue;

  /// count by 값이 변경될 때 호출되는 콜백
  final ValueChanged<int> onChanged;

  /// 위젯의 크기 (기본값: 중간 크기)
  final CountBySelectorSize size;

  const CountBySelector({
    super.key,
    required this.currentValue,
    required this.onChanged,
    this.size = CountBySelectorSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    // 플랫폼별 UI 분기
    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  /// iOS용 Cupertino 스타일 버튼
  Widget _buildCupertinoButton(BuildContext context) {
    return CupertinoButton(
      padding: _getPadding(),
      onPressed: () => _showCountByPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey4, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text('count by $currentValue', style: _getTextStyle(context)),
      ),
    );
  }

  /// Android/기타 플랫폼용 Material 스타일 버튼
  Widget _buildMaterialButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showCountByPicker(context),
      style: OutlinedButton.styleFrom(
        padding: _getPadding(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text('count by $currentValue', style: _getTextStyle(context)),
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
        return Container(
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
        );
      },
    );
  }

  /// Android/기타 플랫폼용 Material 피커 표시
  void _showMaterialPicker(BuildContext context) {
    int selectedValue = currentValue;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 헤더 영역
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('취소'),
                  ),
                  const Text(
                    'Count By 설정',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
              // 피커 영역
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  controller: FixedExtentScrollController(
                    initialItem: selectedValue - 1, // 1-based to 0-based
                  ),
                  onSelectedItemChanged: (int index) {
                    selectedValue = index + 1; // 0-based to 1-based
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= 10) return null;
                      final value = index + 1;
                      return Center(
                        child: Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                    childCount: 10,
                  ),
                ),
              ),
            ],
          ),
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
