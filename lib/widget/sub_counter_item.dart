import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yarnie/widget/count_by_selector.dart';

/// 서브 카운터를 표시하는 위젯
/// "- [ 숫자 ] +" 형태의 간소한 UI로 구성됩니다.
class SubCounterItem extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;
  final VoidCallback onReset;
  final int countByValue;
  final ValueChanged<int> onCountByChanged;

  const SubCounterItem({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
    required this.onReset,
    required this.countByValue,
    required this.onCountByChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // iOS: CountBySelector를 카운터 영역 내부 우측으로 이동
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12), // 오른쪽 패딩 추가
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            _buildDeleteButton(context),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCounterButton(
                    context,
                    icon: CupertinoIcons.minus,
                    onPressed: onDecrement,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onLongPress: onReset,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
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
                  ),
                  const SizedBox(width: 16),
                  _buildCounterButton(
                    context,
                    icon: CupertinoIcons.plus,
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ),
            CountBySelector(
              currentValue: countByValue,
              onChanged: onCountByChanged,
              size: CountBySelectorSize.small,
              labelStyle: CountByLabelStyle.full,
              chipStyle: CountByChipStyle.filled,
            ),
          ],
        ),
      );
    } else {
      // Android: 스와이프-삭제 UI
      return Dismissible(
        key: ValueKey('subcounter-item-$value'), // More specific key
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
            boxShadow: kElevationToShadow[1],
          ),
          child: Row(
            children: [
              IconButton.filledTonal(
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
              ),
              GestureDetector(
                onLongPress: onReset,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    '$value',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: CountBySelector(
                  currentValue: countByValue,
                  onChanged: onCountByChanged,
                  size: CountBySelectorSize.small,
                  labelStyle: CountByLabelStyle.full,
                  chipStyle: CountByChipStyle.filled,
                ),
              ),
            ],
          ),
        ),
      );
    }
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
          ).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
        onPressed: onDelete,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          child: Icon(
            CupertinoIcons.xmark_circle_fill,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
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
