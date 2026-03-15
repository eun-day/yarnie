import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/new_project_screen.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/l10n/app_localizations.dart';

class ProjectInfoSheet extends ConsumerWidget {
  final Project project;
  final List<Tag> allTags;

  const ProjectInfoSheet({
    super.key,
    required this.project,
    required this.allTags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 태그 ID로 실제 태그 객체 찾기
    final selectedTags = project.tagIds != null
        ? allTags.where((tag) => project.tagIds!.contains(tag.id.toString())).toList()
        : <Tag>[];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E5EA),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header: Title & Close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.projectInfo,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.05,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.projectInfoDesc,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            letterSpacing: -0.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewProjectScreen(projectId: project.id),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.edit,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image (if exists)
                    if (project.imagePath != null && project.imagePath!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.file(
                              File(project.imagePath!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    // Project Name
                    _InfoRow(label: l10n.projectName, value: project.name),
                    const Divider(height: 32),

                    // Needle Info
                    Row(
                      children: [
                        Expanded(
                          child: _InfoRow(
                            label: l10n.needleType,
                            value: project.needleType == 'knitting'
                                ? l10n.knittingNeedle
                                : project.needleType == 'crochet'
                                    ? l10n.crochetNeedle
                                    : '-',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _InfoRow(
                            label: l10n.needleSize,
                            value: project.needleSize ?? '-',
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Lot Number
                    _InfoRow(label: l10n.lotNumberLabel, value: project.lotNumber ?? '-'),
                    const Divider(height: 32),

                    // Tags
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tag,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (selectedTags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: selectedTags
                                .map((tag) => ColoredTagChip(tag: tag))
                                .toList(),
                          )
                        else
                          Text(
                            l10n.noTagsAssigned,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Gauge
                    Builder(
                      builder: (context) {
                        final List<String> parts = [];
                        if (project.gaugeStitches != null && project.gaugeStitches!.isNotEmpty) {
                          parts.add('${project.gaugeStitches}${l10n.stitchesUnit}');
                        }
                        if (project.gaugeRows != null && project.gaugeRows!.isNotEmpty) {
                          parts.add('${project.gaugeRows}${l10n.rowsUnit}');
                        }

                        if (parts.isNotEmpty) {
                          return _InfoRow(
                            label: l10n.gauge,
                            value: '${parts.join(' / ')} ${l10n.gaugeStandard}',
                          );
                        } else {
                          return _InfoRow(
                            label: l10n.gauge,
                            value: l10n.noGaugeInfo,
                          );
                        }
                      },
                    ),
                    const Divider(height: 32),

                    // Memo
                    _InfoRow(
                      label: l10n.memo,
                      value: project.memo ?? l10n.noMemoInfo,
                      isMultiLine: true,
                    ),
                    const SizedBox(height: 32),

                    // Dates
                    Row(
                      children: [
                        Expanded(
                          child: _InfoRow(
                            label: l10n.createdAtLabel,
                            value: _formatDate(project.createdAt, l10n),
                            labelSize: 11,
                          ),
                        ),
                        if (project.updatedAt != null) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: _InfoRow(
                              label: l10n.updatedAtLabel,
                              value: _formatDate(project.updatedAt!, l10n),
                              labelSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final local = date.toLocal();
    return l10n.dateDisplay(local.year.toString(), local.month.toString(), local.day.toString());
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMultiLine;
  final double labelSize;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isMultiLine = false,
    this.labelSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
            height: isMultiLine ? 1.5 : 1.2,
          ),
        ),
      ],
    );
  }
}
