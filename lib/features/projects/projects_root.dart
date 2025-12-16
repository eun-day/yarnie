import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/projects/projects_api.dart';
import '../../db/app_db.dart';
import '../../new_project_screen.dart';
import '../../project_detail_screen.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/tag_selection_sheet.dart';
import '../../widgets/colored_tag_chip.dart';

/// SharedPreferences 키
const _kViewModeKey = 'projects_view_mode';

/// 프로젝트 목록 화면
class ProjectsRoot extends ConsumerStatefulWidget {
  final ScrollController controller;
  const ProjectsRoot({super.key, required this.controller});

  @override
  ConsumerState<ProjectsRoot> createState() => _ProjectsRootState();
}

class _ProjectsRootState extends ConsumerState<ProjectsRoot> {
  @override
  void initState() {
    super.initState();
    // 초기 로드
    Future.microtask(() {
      ref.read(projectsProvider.notifier).onEvent(const LoadProjects());
      _loadViewMode();
    });
  }

  /// 저장된 뷰 모드 불러오기
  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_kViewModeKey) ?? 0;
    final mode = ProjectViewMode.values[modeIndex];
    if (mounted) {
      ref.read(projectsProvider.notifier).onEvent(ChangeViewMode(mode));
    }
  }

  /// 뷰 모드 저장
  Future<void> _saveViewMode(ProjectViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kViewModeKey, mode.index);
  }

  @override
  Widget build(BuildContext context) {
    // Effect 구독
    ref.listen(projectsEffectsProvider, (_, asyncEffect) {
      asyncEffect.whenData((effect) => _handleEffect(context, effect));
    });

    final state = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('프로젝트'),
            Text(
              '${state.allProjects.length}개의 프로젝트',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.tonalIcon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewProjectScreen()),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('새 프로젝트'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // 태그 필터
            _TagFilterBar(
              tags: state.allTags,
              selectedTagIds: state.selectedTagIds,
              onTagTap: (tagId) {
                ref
                    .read(projectsProvider.notifier)
                    .onEvent(ToggleTagFilter(tagId));
              },
              onClearFilters: () {
                ref
                    .read(projectsProvider.notifier)
                    .onEvent(const ClearFilters());
              },
            ),
            // 뷰 모드 전환 바
            _ViewModeBar(
              viewMode: state.viewMode,
              onViewModeChanged: (mode) {
                ref
                    .read(projectsProvider.notifier)
                    .onEvent(ChangeViewMode(mode));
                _saveViewMode(mode);
              },
            ),
            // 프로젝트 목록
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ProjectsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isEmpty) {
      return const _EmptyView();
    }

    if (state.isFilteredEmpty) {
      return _FilteredEmptyView(
        onClearFilters: () {
          ref.read(projectsProvider.notifier).onEvent(const ClearFilters());
        },
      );
    }

    final projects = state.displayProjects;

    switch (state.viewMode) {
      case ProjectViewMode.largeCard:
        return _LargeCardView(
          projects: projects,
          tags: state.allTags,
          onProjectTap: (id) => _openProject(id),
          onMoreTap: (id) => _showProjectMenu(id),
        );
      case ProjectViewMode.smallCard:
        return _SmallCardView(
          projects: projects,
          tags: state.allTags,
          onProjectTap: (id) => _openProject(id),
          onMoreTap: (id) => _showProjectMenu(id),
        );
      case ProjectViewMode.list:
        return _ListView(
          projects: projects,
          tags: state.allTags,
          onProjectTap: (id) => _openProject(id),
          onMoreTap: (id) => _showProjectMenu(id),
        );
    }
  }

  void _openProject(int projectId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(projectId: projectId),
      ),
    );
  }

  void _showProjectMenu(int projectId) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _ProjectMenuSheet(projectId: projectId),
    );
  }

  void _handleEffect(BuildContext context, ProjectsEffect effect) {
    switch (effect) {
      case NavigateToProjectDetail(:final projectId):
        _openProject(projectId);
      case ShowSuccessMessage(:final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case ShowErrorMessage(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      case ShowAssignTagsDialog(:final projectId, :final currentTagIds):
        _showTagAssignmentSheet(context, projectId, currentTagIds);
        break;
      case ProjectCreated():
        break;
      case ProjectUpdated():
        break;
      case ProjectDeleted():
        break;
    }
  }

  Future<void> _showTagAssignmentSheet(BuildContext context, int projectId, List<int> currentTagIds) async {
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TagSelectionSheet(
        initialSelectedIds: currentTagIds.toSet(),
      ),
    );

    if (result != null) {
      ref.read(projectsProvider.notifier).onEvent(AssignTagsToProject(projectId, result.toList()));
    }
  }
}

// ============================================================
// 태그 필터 바
// ============================================================

class _TagFilterBar extends StatelessWidget {
  final List<Tag> tags;
  final Set<int> selectedTagIds;
  final ValueChanged<int> onTagTap;
  final VoidCallback onClearFilters;

  const _TagFilterBar({
    required this.tags,
    required this.selectedTagIds,
    required this.onTagTap,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // 전체 칩
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: TagChip(
              label: '전체',
              isSelected: selectedTagIds.isEmpty,
              onTap: onClearFilters,
              showCloseButton: false,
            ),
          ),
          // 태그 칩들
          ...tags.map((tag) {
            final isSelected = selectedTagIds.contains(tag.id);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: TagChip(
                label: tag.name,
                isSelected: isSelected,
                onTap: () => onTagTap(tag.id),
                showCloseButton: true,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ============================================================
// 뷰 모드 전환 바
// ============================================================

class _ViewModeBar extends StatelessWidget {
  final ProjectViewMode viewMode;
  final ValueChanged<ProjectViewMode> onViewModeChanged;

  const _ViewModeBar({required this.viewMode, required this.onViewModeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 뷰 모드 아이콘 박스
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ViewModeIconButton(
                  icon: Icons.grid_view_rounded,
                  isSelected: viewMode == ProjectViewMode.largeCard,
                  onPressed: () => onViewModeChanged(ProjectViewMode.largeCard),
                  tooltip: '큰 카드',
                ),
                _ViewModeIconButton(
                  icon: Icons.grid_on_rounded,
                  isSelected: viewMode == ProjectViewMode.smallCard,
                  onPressed: () => onViewModeChanged(ProjectViewMode.smallCard),
                  tooltip: '작은 카드',
                ),
                _ViewModeIconButton(
                  icon: Icons.view_list_rounded,
                  isSelected: viewMode == ProjectViewMode.list,
                  onPressed: () => onViewModeChanged(ProjectViewMode.list),
                  tooltip: '리스트',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 뷰 모드 아이콘 버튼
// ============================================================

class _ViewModeIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;
  final String tooltip;

  const _ViewModeIconButton({
    required this.icon,
    required this.isSelected,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 20,
        color: Colors.black,
        onPressed: onPressed,
        tooltip: tooltip,
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
        ),
      ),
    );
  }
}

// ============================================================
// 큰 카드 뷰
// ============================================================

class _LargeCardView extends StatelessWidget {
  final List<Project> projects;
  final List<Tag> tags;
  final ValueChanged<int> onProjectTap;
  final ValueChanged<int> onMoreTap;

  const _LargeCardView({
    required this.projects,
    required this.tags,
    required this.onProjectTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _LargeProjectCard(
            project: project,
            tags: tags,
            onTap: () => onProjectTap(project.id),
            onMoreTap: () => onMoreTap(project.id),
          ),
        );
      },
    );
  }
}

class _LargeProjectCard extends StatelessWidget {
  final Project project;
  final List<Tag> tags;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const _LargeProjectCard({
    required this.project,
    required this.tags,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              project.imagePath != null
                  ? Image.network(
                      project.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFFD9D9D9)),
                    )
                  : Container(color: const Color(0xFFD9D9D9)),
              // 하단 정보 섹션
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color.fromRGBO(0, 0, 0, 0.6),
                        const Color.fromRGBO(0, 0, 0, 0.0),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            letterSpacing: -0.3125,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(project.createdAt),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: -0.15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 좌측 상단 태그
              if (projectTags.isNotEmpty)
                Positioned(
                  left: 12,
                  top: 12,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: projectTags.take(3).map((tag) {
                      return ColoredTagChip(
                        key: ValueKey(tag.id),
                        tag: tag,
                      );
                    }).toList(),
                  ),
                ),

              // 우측 상단 더보기 버튼
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(6.4),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert),
                    iconSize: 20,
                    onPressed: onMoreTap,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              // 우측 중앙 다음 버튼
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent, // 배경 없음
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      color: Colors.white,
                      onPressed: onTap,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
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
      final tagIds = decoded.map((e) => int.tryParse(e.toString()) ?? -1).toSet();
      return tags.where((tag) => tagIds.contains(tag.id)).toList();
    } catch (_) {
      return [];
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}년 ${local.month}월 ${local.day}일';
  }
}

// ============================================================
// 작은 카드 뷰
// ============================================================

class _SmallCardView extends StatelessWidget {
  final List<Project> projects;
  final List<Tag> tags;
  final ValueChanged<int> onProjectTap;
  final ValueChanged<int> onMoreTap;

  const _SmallCardView({
    required this.projects,
    required this.tags,
    required this.onProjectTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 4 / 3,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _SmallProjectCard(
          project: project,
          tags: tags,
          onTap: () => onProjectTap(project.id),
          onMoreTap: () => onMoreTap(project.id),
        );
      },
    );
  }
}

class _SmallProjectCard extends StatelessWidget {
  final Project project;
  final List<Tag> tags;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const _SmallProjectCard({
    required this.project,
    required this.tags,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 이미지 영역
            Container(
              color: const Color(0xFFD9D9D9), // Placeholder color from Figma
              child: project.imagePath != null
                  ? Image.network(
                      project.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholderImage(context),
                    )
                  : _placeholderImage(context),
            ),
            
            // 좌측 상단 태그
            if (projectTags.isNotEmpty)
              Positioned(
                left: 8,
                top: 8,
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: projectTags.take(2).map((tag) {
                    return ColoredTagChip(
                      key: ValueKey(tag.id),
                      tag: tag,
                    );
                  }).toList(),
                ),
              ),

            // 우측 상단 더보기 버튼
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(6.4),
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  iconSize: 20,
                  onPressed: onMoreTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.black, // Ensure icon is visible
                ),
              ),
            ),

            // 하단 정보 바 (Project Name + Arrow)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 32, // Fixed height based on design (~139-107=32px)
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.33, // leading 16px / 12px
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image,
        size: 48,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  List<Tag> _getProjectTags() {
    if (project.tagIds == null || project.tagIds!.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(project.tagIds!);
      if (decoded is! List) return [];
      final tagIds = decoded.map((e) => int.tryParse(e.toString()) ?? -1).toSet();
      return tags.where((tag) => tagIds.contains(tag.id)).toList();
    } catch (_) {
      return [];
    }
  }
}

// ============================================================
// 리스트 뷰
// ============================================================

class _ListView extends StatelessWidget {
  final List<Project> projects;
  final List<Tag> tags;
  final ValueChanged<int> onProjectTap;
  final ValueChanged<int> onMoreTap;

  const _ListView({
    required this.projects,
    required this.tags,
    required this.onProjectTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _ProjectListTile(
          project: project,
          tags: tags,
          onTap: () => onProjectTap(project.id),
          onMoreTap: () => onMoreTap(project.id),
        );
      },
    );
  }
}

class _ProjectListTile extends StatelessWidget {
  final Project project;
  final List<Tag> tags;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const _ProjectListTile({
    required this.project,
    required this.tags,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 0.65,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Align center vertically
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
                          errorBuilder: (_, _, _) => Container(color: const Color(0xFFD9D9D9)),
                        ),
                      )
                    : Container(color: const Color(0xFFD9D9D9)), // Placeholder empty
              ),
              const SizedBox(width: 16),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF0A0A0A), // neutral-950
                        height: 1.5, // leading 24px / 16px
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
                            const Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Color(0xFF717182),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(project.createdAt),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF717182),
                                height: 1.42, // leading 20px / 14px
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
                                    padding: const EdgeInsets.only(right: 4.0),
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
              // 더보기 버튼
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  iconSize: 20,
                  onPressed: onMoreTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9), // As per design but might be invisible on white bg
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.4)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderIcon(BuildContext context) {
    return Icon(
      Icons.image,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  List<Tag> _getProjectTags() {
    if (project.tagIds == null || project.tagIds!.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(project.tagIds!);
      if (decoded is! List) return [];
      final tagIds = decoded.map((e) => int.tryParse(e.toString()) ?? -1).toSet();
      return tags.where((tag) => tagIds.contains(tag.id)).toList();
    } catch (_) {
      return [];
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}년 ${local.month}월 ${local.day}일';
  }
}

// ============================================================
// 빈 상태 뷰
// ============================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open,
              size: 96,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '아직 만든 프로젝트가 없어요.\n프로젝트를 만들어볼까요?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewProjectScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('프로젝트 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilteredEmptyView extends StatelessWidget {
  final VoidCallback onClearFilters;

  const _FilteredEmptyView({required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 96,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '해당하는 프로젝트가 없습니다',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '다른 태그를 선택하거나\n필터를 초기화해보세요',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('필터 초기화'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 프로젝트 메뉴 시트
// ============================================================

class _ProjectMenuSheet extends ConsumerWidget {
  final int projectId;

  const _ProjectMenuSheet({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('프로젝트 복사'),
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(projectsProvider.notifier)
                  .onEvent(DuplicateProject(projectId));
            },
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('태그 지정'),
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(projectsProvider.notifier)
                  .onEvent(OpenAssignTagsDialog(projectId));
            },
          ),
        ],
      ),
    );
  }
}