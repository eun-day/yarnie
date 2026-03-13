import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../db/app_db.dart';
import 'colored_tag_chip.dart'; // Tag를 표시하기 위한 기존 위젯이라고 가정

class ProjectListTile extends StatelessWidget {
  final Project project;
  final List<Tag> tags;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProjectListTile({
    super.key,
    required this.project,
    required this.tags,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags();

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.65),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 썸네일
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: project.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          project.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: const Color(0xFFD9D9D9)),
                        ),
                      )
                    : Container(color: const Color(0xFFD9D9D9)),
              ),
              const SizedBox(width: 16),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5,
                        letterSpacing: -0.31,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Date
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(context, project.createdAt),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                height: 1.42,
                                letterSpacing: -0.15,
                              ),
                            ),
                          ],
                        ),
                        // Gap between Date and Tags
                        if (projectTags.isNotEmpty) ...[
                          const SizedBox(width: 9),
                          // Tags
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: projectTags.map((tag) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 4.0),
                                    child: ColoredTagChip(
                                      key: ValueKey(tag.id),
                                      tag: tag,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Tag> _getProjectTags() {
    if (project.tagIds == null || project.tagIds!.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(project.tagIds!);
      if (decoded is! List) return [];
      final tagIds = decoded
          .map((e) => int.tryParse(e.toString()) ?? -1)
          .toSet();
      return tags.where((tag) => tagIds.contains(tag.id)).toList();
    } catch (_) {
      return [];
    }
  }

  String _formatDate(BuildContext context, DateTime date) {
    final local = date.toLocal();
    return AppLocalizations.of(context)!
        .dateDisplay(local.year, local.month, local.day);
  }
}
