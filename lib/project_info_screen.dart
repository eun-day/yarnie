import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/new_project_screen.dart';

class ProjectInfoSheet extends StatelessWidget {
  final Project project;
  final List<Tag> allTags;

  const ProjectInfoSheet({
    super.key,
    required this.project,
    required this.allTags,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags(project, allTags);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.75,
      maxChildSize: 0.75,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                NewProjectScreen(projectId: project.id),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Image
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: project.imagePath != null
                            ? Image.file(
                                File(project.imagePath!),
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.image, size: 40),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Needle Info
                Row(
                  children: [
                    Expanded(child: _buildDetailItem(context, '사용 바늘', project.needleType ?? '-')),
                    Expanded(child: _buildDetailItem(context, '바늘 사이즈', project.needleSize ?? '-')),
                  ],
                ),
                const SizedBox(height: 16),

                // Lot Number
                _buildDetailItem(context, 'Lot 번호', project.lotNumber ?? '-'),
                const SizedBox(height: 24),

                // Tags
                _buildSection(
                  context,
                  title: '태그',
                  content: projectTags.isEmpty
                      ? const Text('지정된 태그가 없습니다.')
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: projectTags.map((tag) => ColoredTagChip(tag: tag)).toList(),
                        ),
                ),
                const SizedBox(height: 24),

                // Memo
                _buildSection(
                  context,
                  title: '메모',
                  content: Text(project.memo ?? '작성된 메모가 없습니다.'),
                ),
                const SizedBox(height: 24),

                // Dates
                Row(
                  children: [
                    Expanded(child: _buildDetailItem(context, '생성일', _formatDate(project.createdAt))),
                    Expanded(child: _buildDetailItem(context, '최근 수정일', project.updatedAt != null ? _formatDate(project.updatedAt!) : '-')),
                  ],
                ),
              ],
            ),
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
    return '${local.year}.${local.month.toString().padLeft(2, '0')}.${local.day.toString().padLeft(2, '0')}';
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}