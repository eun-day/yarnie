import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/new_project_screen.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/widgets/project_image.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/core/providers/length_unit_provider.dart';
import 'package:yarnie/common/time_helper.dart';

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
    final lengthUnit = ref.watch(lengthUnitProvider);

    // 태그 ID로 실제 태그 객체 찾기
    final selectedTags = project.tagIds != null
        ? allTags
              .where((tag) => project.tagIds!.contains(tag.id.toString()))
              .toList()
        : <Tag>[];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
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
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 100,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header: Title & Close
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.projectInfo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                letterSpacing: -0.31,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.projectInfoDesc,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                letterSpacing: -0.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NewProjectScreen(projectId: project.id),
                            ),
                          );
                        },
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          child: Text(
                            l10n.edit,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image (if exists)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 240,
                              height: 135,
                              child:
                                  (project.imagePath != null &&
                                      project.imagePath!.isNotEmpty)
                                  ? ProjectImage(
                                      imagePath: project.imagePath,
                                      fit: BoxFit.cover,
                                      placeholder: Container(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest,
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 40,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                      child: Center(
                                        child: Icon(
                                          Icons.image_outlined,
                                          size: 40,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        // Project Name
                        _InfoRow(
                          label: l10n.projectName,
                          value: project.name,
                          valueColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: 24),

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
                                valueColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                              ),
                            ),
                            Expanded(
                              child: _InfoRow(
                                label: l10n.needleSize,
                                value: project.needleSize ?? '-',
                                valueColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Lot Number
                        _InfoRow(
                          label: l10n.lotNumberLabel,
                          value: project.lotNumber ?? '-',
                          valueColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: 24),

                        // Tags
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.tag,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                letterSpacing: -0.15,
                              ),
                            ),
                            const SizedBox(height: 6),
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
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Gauge
                        Builder(
                          builder: (context) {
                            final List<String> parts = [];
                            if (project.gaugeStitches != null &&
                                project.gaugeStitches!.isNotEmpty) {
                              parts.add(
                                '${project.gaugeStitches}${l10n.stitchesUnit}',
                              );
                            }
                            if (project.gaugeRows != null &&
                                project.gaugeRows!.isNotEmpty) {
                              parts.add('${project.gaugeRows}${l10n.rowsUnit}');
                            }

                            if (parts.isNotEmpty) {
                              return _InfoRow(
                                label: l10n.gauge,
                                value:
                                    '${parts.join(' / ')} ${lengthUnit == LengthUnit.cm ? l10n.gaugeStandard : l10n.gaugeStandardInch}',
                                valueColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                              );
                            } else {
                              return _InfoRow(
                                label: l10n.gauge,
                                value: l10n.noGaugeInfo,
                                valueColor: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Memo
                        _InfoRow(
                          label: l10n.memo,
                          value: project.memo ?? l10n.noMemoInfo,
                          valueColor: project.memo?.isNotEmpty == true
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 24),

                        // Dates
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 0.7,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _DateRow(
                                  label: l10n.createdAtLabel,
                                  value: formatDateDisplay(
                                    project.createdAt,
                                    l10n,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: _DateRow(
                                  label: l10n.updatedAtLabel,
                                  value: project.updatedAt != null
                                      ? formatDateDisplay(
                                          project.updatedAt!,
                                          l10n,
                                        )
                                      : '-',
                                ),
                              ),
                            ],
                          ),
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
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor,
            letterSpacing: -0.31,
          ),
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;

  const _DateRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
      ],
    );
  }
}
