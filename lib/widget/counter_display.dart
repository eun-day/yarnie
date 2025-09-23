import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 메인 카운터 숫자를 크게 표시하는 위젯
/// 터치 시 초기화 확인 다이얼로그를 표시합니다.
class CounterDisplay extends StatelessWidget {
  final int value;
  final VoidCallback onReset;

  const CounterDisplay({super.key, required this.value, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showResetDialog(context),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          value.toString(),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// 플랫폼별 초기화 확인 다이얼로그를 표시합니다.
  void _showResetDialog(BuildContext context) {
    if (Platform.isIOS) {
      _showCupertinoResetDialog(context);
    } else {
      _showMaterialResetDialog(context);
    }
  }

  /// iOS용 Cupertino 스타일 초기화 확인 다이얼로그
  void _showCupertinoResetDialog(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('카운터 초기화'),
          content: const Text('카운터를 0으로 초기화하시겠습니까?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                onReset();
              },
              child: const Text('초기화'),
            ),
          ],
        );
      },
    );
  }

  /// Android/기타 플랫폼용 Material 스타일 초기화 확인 다이얼로그
  void _showMaterialResetDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('카운터 초기화'),
          content: const Text('카운터를 0으로 초기화하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onReset();
              },
              child: const Text('초기화'),
            ),
          ],
        );
      },
    );
  }
}
