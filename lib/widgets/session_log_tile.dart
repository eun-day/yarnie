import 'package:flutter/material.dart';
import 'package:yarnie/common/time_helper.dart';

/// 세션 로그 타일 위젯
class SessionLogTile extends StatefulWidget {
  final int logNo;
  final Duration duration;
  final String? label;
  final String? memo;

  const SessionLogTile({
    super.key,
    required this.logNo,
    required this.duration,
    this.label,
    this.memo,
  });

  @override
  State<SessionLogTile> createState() => _SessionLogTileState();
}

class _SessionLogTileState extends State<SessionLogTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMemo = widget.memo?.isNotEmpty == true;

    return Padding(
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
                    color: Colors.deepPurple.withOpacity(0.7),
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
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(6),
        color: Colors.deepPurple.withOpacity(0.05),
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
              color: Colors.deepPurple.withOpacity(0.6),
            ),
          ),
          // 메모 내용
          Expanded(
            child: GestureDetector(
              onTap: needsTruncate
                  ? () => setState(() => _isExpanded = !_isExpanded)
                  : null,
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
