import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/providers/stopwatch_provider.dart';
import 'package:yarnie/model/session_status.dart';

/// 세션 관리 관련 공통 다이얼로그 및 로직을 제공하는 헬퍼 클래스
class SessionDialogHelper {
  /// 활성 세션이 있을 때 이어하기/새로 시작 선택 다이얼로그를 표시합니다.
  ///
  /// Returns:
  /// - `true`: 이어하기 선택
  /// - `false`: 새로 시작 선택
  /// - `null`: 취소 또는 다이얼로그 닫기
  static Future<bool?> askResumeOrNew(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('진행 중 세션'),
          content: const Text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('새로 시작'),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            CupertinoDialogAction(
              child: const Text('이어하기'),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        ),
      );
    } else {
      return showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('진행 중 세션'),
          content: const Text('진행 중인 세션이 있습니다. 이어서 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('새로 시작'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('이어하기'),
            ),
          ],
        ),
      );
    }
  }

  /// 스톱워치 시작 로직을 처리합니다.
  /// 활성 세션이 있으면 사용자에게 선택지를 제공하고,
  /// 없으면 새 세션을 시작합니다.
  ///
  /// [context]: 다이얼로그 표시를 위한 BuildContext
  /// [ref]: Riverpod WidgetRef
  /// [projectId]: 프로젝트 ID
  ///
  /// Returns: 성공적으로 시작되었는지 여부
  static Future<bool> startStopwatch({
    required BuildContext context,
    required WidgetRef ref,
    required int projectId,
  }) async {
    final swNotifier = ref.read(stopwatchProvider.notifier);
    if (ref.read(stopwatchProvider).isRunning) return false;

    final active = await appDb.getActiveSession(projectId);

    if (active == null) {
      // 활성 세션이 없음 → 새 세션 생성 후 시작
      await appDb.startSession(projectId: projectId);
    } else {
      // 활성 세션이 있음 → 이어하기/새로 시작 선택
      final resume = await askResumeOrNew(context);
      if (resume == null) {
        // 사용자가 취소함
        return false;
      }

      if (resume == true) {
        // 이어하기: 상태별 처리
        if (active.status == SessionStatus.paused) {
          await appDb.resumeSession(projectId: projectId);
        }
        // running이면 DB 호출 불필요
      } else {
        // 새로 시작: 기존 미종료 세션 정리 후 새 세션
        await appDb.stopSession(projectId: projectId);
        await appDb.startSession(projectId: projectId);
      }
    }

    // 스톱워치 시작
    final elapsed = await appDb.totalElapsedDuration(projectId: projectId);
    swNotifier.start(initialElapsed: elapsed);

    return true;
  }
}
