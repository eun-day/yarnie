import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/common/label_picker_helper.dart';
import 'package:yarnie/db/di.dart';

/// 세션 로그 타일 위젯
class SessionLogTile extends StatefulWidget {
  final int sessionId; // DB의 세션 ID 추가
  final int logNo;
  final Duration duration;
  final String? label;
  final String? memo;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEditLabel;
  final VoidCallback? onEditMemo;

  const SessionLogTile({
    super.key,
    required this.sessionId,
    required this.logNo,
    required this.duration,
    this.label,
    this.memo,
    this.onViewDetails,
    this.onEditLabel,
    this.onEditMemo,
  });

  @override
  State<SessionLogTile> createState() => _SessionLogTileState();
}

class _SessionLogTileState extends State<SessionLogTile> {
  bool _isExpanded = false;

  // 기본 라벨 목록 (stopwatch_panel과 동일하게)
  static const List<String> _defaultLabels = ['소매', '몸통', '목둘레'];

  Future<void> _showMemoEditor(BuildContext context) async {
    final TextEditingController controller = TextEditingController(
      text: widget.memo ?? '', // 기존 메모가 있으면 불러오기
    );

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 제목
                  Text(
                    'log ${widget.logNo} 메모 편집',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // 메모 입력 필드
                  TextField(
                    controller: controller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: '메모를 입력하세요...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),

                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, null),
                          child: const Text('취소'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final memo = controller.text.trim();
                            Navigator.pop(context, memo.isEmpty ? '' : memo);
                          },
                          child: const Text('저장'),
                        ),
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

    // 결과 처리
    if (result != null) {
      final newMemo = result.isEmpty ? null : result;

      // 기존 메모와 다른 경우만 DB 업데이트
      if (newMemo != widget.memo) {
        await _updateSessionMemo(newMemo);
      }
    }
    // result가 null인 경우는 취소이므로 아무것도 하지 않음
  }

  Future<void> _updateSessionMemo(String? newMemo) async {
    try {
      // 메모만 업데이트 (라벨은 건드리지 않음)
      await appDb.updateSessionMemo(
        sessionId: widget.sessionId,
        memo: newMemo,
        nowMs: DateTime.now().millisecondsSinceEpoch,
      );

      // 성공 피드백
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newMemo == null ? '메모가 제거되었습니다' : '메모가 저장되었습니다'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메모 업데이트 실패: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _showLabelSelector(BuildContext context) async {
    List<String> currentLabels = [..._defaultLabels];

    final selectedLabel = await LabelPickerHelper.openLabelPicker(
      context: context,
      labels: currentLabels,
      initial: widget.label,
      onLabelsUpdated: (updatedLabels) {
        // 라벨 목록이 업데이트되면 로컬 상태 갱신
        currentLabels = updatedLabels;
      },
    );

    // 라벨 선택기에서 실제로 선택이 이루어진 경우만 DB 업데이트
    if (selectedLabel != null) {
      // 빈 문자열은 "미분류"를 의미하므로 null로 변환
      final newLabel = selectedLabel.isEmpty ? null : selectedLabel;

      // 기존 라벨과 다른 경우만 DB 업데이트
      if (newLabel != widget.label) {
        await _updateSessionLabel(newLabel);
      }
    }
    // selectedLabel이 null인 경우는 취소이므로 아무것도 하지 않음
  }

  Future<void> _updateSessionLabel(String? newLabel) async {
    try {
      // 라벨만 업데이트 (메모는 건드리지 않음)
      await appDb.updateSessionLabel(
        sessionId: widget.sessionId,
        label: newLabel,
        nowMs: DateTime.now().millisecondsSinceEpoch,
      );

      // 성공 피드백 (선택사항)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newLabel == null ? '라벨이 제거되었습니다' : '라벨이 "$newLabel"로 변경되었습니다',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('라벨 업데이트 실패: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showIOSActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onViewDetails != null) {
                widget.onViewDetails!();
              } else {
                debugPrint('View Details tapped');
              }
            },
            child: Text(
              'View log ${widget.logNo} Details',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onEditLabel != null) {
                widget.onEditLabel!();
              } else {
                _showLabelSelector(context);
              }
            },
            child: const Text('Edit Label', style: TextStyle(fontSize: 16)),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onEditMemo != null) {
                widget.onEditMemo!();
              } else {
                _showMemoEditor(context);
              }
            },
            child: const Text('Edit Memo', style: TextStyle(fontSize: 16)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  void _showAndroidContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text('View log ${widget.logNo} Details'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onViewDetails != null) {
                  widget.onViewDetails!();
                } else {
                  debugPrint('View Details tapped');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Edit Label'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onEditLabel != null) {
                  widget.onEditLabel!();
                } else {
                  _showLabelSelector(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Edit Memo'),
              onTap: () {
                Navigator.pop(context);
                if (widget.onEditMemo != null) {
                  widget.onEditMemo!();
                } else {
                  _showMemoEditor(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMemo = widget.memo?.isNotEmpty == true;

    final content = Container(
      width: double.infinity, // 전체 너비 사용
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 첫 번째 줄: log 번호, 세션 소요시간, 라벨 태그
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  'log ${widget.logNo}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      fmt(widget.duration),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.label?.isNotEmpty == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.label!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // 두 번째 줄: 메모 (있을 때만 표시)
          if (hasMemo) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: _buildMemoSection(theme),
            ),
          ],
        ],
      ),
    );

    // 플랫폼별 GestureDetector 사용
    return GestureDetector(
      onLongPress: () {
        if (Platform.isIOS) {
          _showIOSActionSheet(context);
        } else {
          _showAndroidContextMenu(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }

  List<TextSpan> _getTruncatedTextSpans(
    String memo,
    List<String> lines,
    ThemeData theme,
  ) {
    const int maxCharsPerLine = 35; // 영어 기준
    const String moreText = '.. ';

    if (lines.length > 2) {
      // 3줄 이상인 경우: 첫 2줄을 기준으로 처리
      final firstLine = lines[0];
      final secondLine = lines[1];

      if (secondLine.length + moreText.length + 2 <= maxCharsPerLine) {
        // 둘째 줄에 ".. 더보기"를 붙일 공간이 있는 경우
        return [
          TextSpan(
            text: '$firstLine\n$secondLine$moreText',
            style: theme.textTheme.bodySmall,
          ),
          TextSpan(
            text: '더보기',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ];
      } else {
        // 둘째 줄이 꽉 찬 경우: 둘째 줄을 잘라서 ".. 더보기" 공간 확보
        final truncatedSecondLine = secondLine.substring(
          0,
          maxCharsPerLine - moreText.length - 2,
        );
        return [
          TextSpan(
            text: '$firstLine\n$truncatedSecondLine$moreText',
            style: theme.textTheme.bodySmall,
          ),
          TextSpan(
            text: '더보기',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ];
      }
    } else if (lines.length == 2) {
      // 정확히 2줄인 경우
      final firstLine = lines[0];
      final secondLine = lines[1];

      final truncatedSecondLine = secondLine.substring(
        0,
        maxCharsPerLine - moreText.length - 2,
      );
      return [
        TextSpan(
          text: '$firstLine\n$truncatedSecondLine$moreText',
          style: theme.textTheme.bodySmall,
        ),
        TextSpan(
          text: '더보기',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ];
    } else {
      // 1줄이지만 긴 경우
      final truncateLength = maxCharsPerLine * 2 - moreText.length - 2;
      return [
        TextSpan(
          text: '${memo.substring(0, truncateLength)}$moreText',
          style: theme.textTheme.bodySmall,
        ),
        TextSpan(
          text: '더보기',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ];
    }
  }

  Widget _buildMemoSection(ThemeData theme) {
    final memo = widget.memo!;

    // 줄바꿈을 고려한 truncate 판단
    final lines = memo.split('\n');
    const int maxCharsPerLine = 35; // 영어 기준

    bool needsTruncate = false;
    if (lines.length > 2) {
      // 3줄 이상이면 무조건 truncate
      needsTruncate = true;
    } else if (lines.length == 2) {
      // 2줄인 경우: 둘째 줄이 한 줄을 넘으면 truncate
      needsTruncate = lines[1].length > maxCharsPerLine;
    } else {
      // 1줄인 경우: 2줄 분량을 넘으면 truncate
      needsTruncate = memo.length > maxCharsPerLine * 2;
    }

    final shouldTruncate = needsTruncate && !_isExpanded;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepPurple.withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: Colors.deepPurple.withValues(alpha: 0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핀 아이콘
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 6),
            child: Icon(
              Icons.push_pin,
              size: 12,
              color: Colors.deepPurple.withValues(alpha: 0.6),
            ),
          ),
          // 메모 내용
          Expanded(
            child: GestureDetector(
              onTap: needsTruncate
                  ? () => setState(() => _isExpanded = !_isExpanded)
                  : null,
              behavior: HitTestBehavior.translucent,
              child: _isExpanded
                  ? Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: memo,
                            style: theme.textTheme.bodySmall,
                          ),
                          if (needsTruncate)
                            TextSpan(
                              text: ' 접기',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    )
                  : Text.rich(
                      TextSpan(
                        children: shouldTruncate
                            ? _getTruncatedTextSpans(memo, lines, theme)
                            : [
                                TextSpan(
                                  text: memo,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                      ),
                      maxLines: shouldTruncate ? 2 : null,
                      overflow: TextOverflow.clip,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
