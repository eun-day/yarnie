import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/modules/projects/application/project_form_event.dart';
import 'package:yarnie/modules/projects/application/project_form_notifier.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/new_project_screen.dart';

class ProjectInfoSheet extends ConsumerStatefulWidget {
  final Project project;
  final List<Tag> allTags;

  const ProjectInfoSheet({
    super.key,
    required this.project,
    required this.allTags,
  });

  @override
  ConsumerState<ProjectInfoSheet> createState() => _ProjectInfoSheetState();
}

class _ProjectInfoSheetState extends ConsumerState<ProjectInfoSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(projectFormNotifierProvider.notifier)
          .onEvent(LoadProjectData(widget.project.id));
    });
  }

  void _refreshProject() {
    ref
        .read(projectFormNotifierProvider.notifier)
        .onEvent(LoadProjectData(widget.project.id));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectFormNotifierProvider);
    final displayProject = state.initialProject ?? widget.project;
    final displayTags = state.allAvailableTags.isNotEmpty
        ? state.allAvailableTags
        : widget.allTags;

    final projectTags = _getProjectTags(displayProject, displayTags);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(
            children: [
              // Drag Handle
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '프로젝트 정보',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.31,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '프로젝트의 상세 정보를 확인하세요',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => NewProjectScreen(
                                  projectId: displayProject.id,
                                ),
                              ),
                            )
                            .then((_) => _refreshProject());
                      },
                      child: Container(
                        height: 32,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          '수정',
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 240,
                            height: 135,
                            child: displayProject.imagePath != null
                                ? Image.file(
                                    File(displayProject.imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 40,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Project Name
                      _buildDetailItem(
                        '프로젝트 이름',
                        displayProject.name,
                        valueColor: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(height: 24),

                      // Needle Info
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              '바늘 종류',
                              displayProject.needleType?.isNotEmpty == true
                                  ? displayProject.needleType!
                                  : '-',
                              valueColor: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              '바늘 사이즈',
                              displayProject.needleSize?.isNotEmpty == true
                                  ? displayProject.needleSize!
                                  : '-',
                              valueColor: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Lot Number
                      _buildDetailItem(
                        '실 로트 번호',
                        displayProject.lotNumber?.isNotEmpty == true
                            ? displayProject.lotNumber!
                            : '-',
                        valueColor: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(height: 24),

                      // Tags
                      _buildSection(
                        title: '태그',
                        content: projectTags.isEmpty
                            ? Text(
                                '지정된 태그가 없습니다.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: projectTags
                                    .map((tag) => ColoredTagChip(tag: tag))
                                    .toList(),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // Gauge
                      Builder(
                        builder: (context) {
                          final hasGauge =
                              (displayProject.gaugeStitches?.isNotEmpty ==
                                  true) ||
                              (displayProject.gaugeRows?.isNotEmpty == true);
                          if (hasGauge) {
                            final parts = <String>[];
                            if (displayProject.gaugeStitches?.isNotEmpty ==
                                true) {
                              parts.add('${displayProject.gaugeStitches}코');
                            }
                            if (displayProject.gaugeRows?.isNotEmpty == true) {
                              parts.add('${displayProject.gaugeRows}단');
                            }
                            return _buildDetailItem(
                              '게이지',
                              '${parts.join(' / ')} (10cm x 10cm 기준)',
                              valueColor: Theme.of(context).colorScheme.onSurface,
                            );
                          } else {
                            return _buildDetailItem(
                              '게이지',
                              '게이지 정보 없음',
                              valueColor: Theme.of(context).colorScheme.onSurfaceVariant,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Memo
                      _buildDetailItem(
                        '메모',
                        displayProject.memo?.isNotEmpty == true
                            ? displayProject.memo!
                            : '메모 없음',
                        valueColor: displayProject.memo?.isNotEmpty == true
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 24),

                      // Dates (Top border)
                      Container(
                        padding: EdgeInsets.only(top: 16),
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
                              child: _buildDateItem(
                                '생성일',
                                _formatDate(displayProject.createdAt),
                              ),
                            ),
                            Expanded(
                              child: _buildDateItem(
                                '최근 수정',
                                displayProject.updatedAt != null
                                    ? _formatDate(displayProject.updatedAt!)
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
        );
      },
    );
  }

  List<Tag> _getProjectTags(Project project, List<Tag> allTags) {
    if (project.tagIds == null || project.tagIds!.isEmpty) return [];
    try {
      final tagIds = (jsonDecode(project.tagIds!) as List).cast<int>();
      return allTags.where((tag) => tagIds.contains(tag.id)).toList();
    } catch (_) {
      return [];
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}년 ${local.month}월 ${local.day}일';
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 6),
        content,
      ],
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    required Color valueColor,
  }) {
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

  Widget _buildDateItem(String label, String value) {
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
