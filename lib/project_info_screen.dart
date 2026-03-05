import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/new_project_screen.dart';

class ProjectInfoSheet extends StatefulWidget {
  final Project project;
  final List<Tag> allTags;

  const ProjectInfoSheet({
    super.key,
    required this.project,
    required this.allTags,
  });

  @override
  State<ProjectInfoSheet> createState() => _ProjectInfoSheetState();
}

class _ProjectInfoSheetState extends State<ProjectInfoSheet> {
  late Project _project;
  late List<Tag> _allTags;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _allTags = widget.allTags;
  }

  Future<void> _refreshProject() async {
    try {
      final updated = await (appDb.select(
        appDb.projects,
      )..where((t) => t.id.equals(_project.id))).getSingleOrNull();
      final tags = await appDb.getAllTags();
      if (updated != null && mounted) {
        setState(() {
          _project = updated;
          _allTags = tags;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags(_project, _allTags);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                    color: const Color(0xFFECECF0),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
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
                          const Text(
                            '프로젝트 정보',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0A0A0A),
                              letterSpacing: -0.31,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '프로젝트의 상세 정보를 확인하세요',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF717182),
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
                                builder: (_) =>
                                    NewProjectScreen(projectId: _project.id),
                              ),
                            )
                            .then((_) => _refreshProject());
                      },
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        child: const Text(
                          '수정',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF637069),
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
                      // Image
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 240,
                            height: 135,
                            child: _project.imagePath != null
                                ? Image.file(
                                    File(_project.imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: const Color(0xFFECECF0),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 40,
                                        color: Color(0xFF717182),
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
                        _project.name,
                        valueColor: const Color(0xFF0A0A0A),
                      ),
                      const SizedBox(height: 24),

                      // Needle Info
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              '바늘 종류',
                              _project.needleType?.isNotEmpty == true
                                  ? _project.needleType!
                                  : '-',
                              valueColor: const Color(0xFF0A0A0A),
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              '바늘 사이즈',
                              _project.needleSize?.isNotEmpty == true
                                  ? _project.needleSize!
                                  : '-',
                              valueColor: const Color(0xFF0A0A0A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Lot Number
                      _buildDetailItem(
                        '실 로트 번호',
                        _project.lotNumber?.isNotEmpty == true
                            ? _project.lotNumber!
                            : '-',
                        valueColor: const Color(0xFF0A0A0A),
                      ),
                      const SizedBox(height: 24),

                      // Tags
                      _buildSection(
                        title: '태그',
                        content: projectTags.isEmpty
                            ? const Text(
                                '지정된 태그가 없습니다.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF717182),
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
                              (_project.gaugeStitches?.isNotEmpty == true) ||
                              (_project.gaugeRows?.isNotEmpty == true);
                          if (hasGauge) {
                            final parts = <String>[];
                            if (_project.gaugeStitches?.isNotEmpty == true) {
                              parts.add('${_project.gaugeStitches}코');
                            }
                            if (_project.gaugeRows?.isNotEmpty == true) {
                              parts.add('${_project.gaugeRows}단');
                            }
                            return _buildDetailItem(
                              '게이지',
                              '${parts.join(' / ')} (10cm x 10cm 기준)',
                              valueColor: const Color(0xFF0A0A0A),
                            );
                          } else {
                            return _buildDetailItem(
                              '게이지',
                              '게이지 정보 없음',
                              valueColor: const Color(0xFF717182),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // Memo
                      _buildDetailItem(
                        '메모',
                        _project.memo?.isNotEmpty == true
                            ? _project.memo!
                            : '메모 없음',
                        valueColor: _project.memo?.isNotEmpty == true
                            ? const Color(0xFF0A0A0A)
                            : const Color(0xFF717182),
                      ),
                      const SizedBox(height: 24),

                      // Dates (Top border)
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color(0x1A000000),
                              width: 0.7,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDateItem(
                                '생성일',
                                _formatDate(_project.createdAt),
                              ),
                            ),
                            Expanded(
                              child: _buildDateItem(
                                '최근 수정',
                                _project.updatedAt != null
                                    ? _formatDate(_project.updatedAt!)
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
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF717182),
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
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF717182),
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
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF717182),
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF0A0A0A),
            letterSpacing: -0.15,
          ),
        ),
      ],
    );
  }
}
