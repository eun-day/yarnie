import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 서브 카운터를 표시하는 위젯
/// "- [ 숫자 ] +" 형태의 간소한 UI로 구성됩니다.
class SubCounterItem extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const SubCounterItem({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 삭제 버튼
          _buildDeleteButton(context),

          // 카운터 영역 "- [ 숫자 ] +"
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCounterButton(
                  context,
                  icon: Platform.isIOS ? CupertinoIcons.minus : Icons.remove,
                  onPressed: onDecrement,
                ),

                const SizedBox(width: 16),

                // 카운터 값 표시
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                _buildCounterButton(
                  context,
                  icon: Platform.isIOS ? CupertinoIcons.plus : Icons.add,
                  onPressed: onIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 카운터 증감 버튼을 생성합니다.
  Widget _buildCounterButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    if (Platform.isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.all(8),
        minSize: 44,
        onPressed: onPressed,
        child: Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 24,
        color: Theme.of(context).colorScheme.primary,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primaryContainer.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  /// 삭제 버튼을 생성합니다.
  Widget _buildDeleteButton(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.all(4),
        minSize: 32,
        onPressed: onDelete,
        child: Icon(
          CupertinoIcons.xmark_circle_fill,
          size: 20,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      return IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.close),
        iconSize: 20,
        color: Theme.of(context).colorScheme.error,
        style: IconButton.styleFrom(
          minimumSize: const Size(32, 32),
          padding: const EdgeInsets.all(4),
        ),
      );
    }
  }
}
