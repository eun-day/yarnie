import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../modules/projects/projects_api.dart';
import '../../db/app_db.dart';
import '../../new_project_screen.dart';
import '../../project_detail_screen.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/tag_selection_sheet.dart';
import '../../widgets/colored_tag_chip.dart';
import '../../widgets/project_list_tile.dart';
import '../../widgets/project_image.dart';
import '../../widgets/common_banner_ad.dart';
import '../../widgets/ad_visibility_wrapper.dart';
import '../../core/providers/premium_provider.dart';
import '../../core/premium/premium_policy.dart';
import '../../common/time_helper.dart';

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
            Text(AppLocalizations.of(context)!.projects),
            Text(
              AppLocalizations.of(
                context,
              )!.projectsCount(state.allProjects.length),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Consumer(
              builder: (context, ref, _) {
                final isPremium = ref.watch(premiumProvider);
                final isLocked = !PremiumPolicy.canCreateProject(state.allProjects.length, isPremium);
                final buttonStyle = PremiumUIHelper.getButtonStyle(
                  isLocked: isLocked,
                  defaultIcon: Icons.add,
                  defaultBackgroundColor: const Color(0xFF637069),
                );

                return FilledButton.tonalIcon(
                  onPressed: () {
                    if (!isLocked) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NewProjectScreen()),
                      );
                    } else {
                      PremiumUIHelper.showUpsellSnackbar(context);
                    }
                  },
                  icon: Icon(buttonStyle.$1, size: 20),
                  label: Text(AppLocalizations.of(context)!.createNewProject),
                  style: FilledButton.styleFrom(
                    backgroundColor: buttonStyle.$2,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
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
      bottomNavigationBar: ref.watch(premiumProvider)
          ? null
          : AdVisibilityWrapper(
              child: CommonBannerAdWidget(
                adUnitId: Platform.isAndroid
                    ? 'ca-app-pub-3940256099942544/6300978111'
                    : 'ca-app-pub-3940256099942544/2934735716',
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
          onLongPress: (id) => _showProjectMenu(id),
        );
      case ProjectViewMode.smallCard:
        return _SmallCardView(
          projects: projects,
          tags: state.allTags,
          onProjectTap: (id) => _openProject(id),
          onLongPress: (id) => _showProjectMenu(id),
        );
      case ProjectViewMode.list:
        return _ListView(
          projects: projects,
          tags: state.allTags,
          onProjectTap: (id) => _openProject(id),
          onLongPress: (id) => _showProjectMenu(id),
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

  Future<void> _showTagAssignmentSheet(
    BuildContext context,
    int projectId,
    List<int> currentTagIds,
  ) async {
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          TagSelectionSheet(initialSelectedIds: currentTagIds.toSet()),
    );

    if (result != null) {
      ref
          .read(projectsProvider.notifier)
          .onEvent(AssignTagsToProject(projectId, result.toList()));
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
      padding: EdgeInsets.symmetric(vertical: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          // 전체 칩
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: TagChip(
              label: AppLocalizations.of(context)!.all,
              isSelected: selectedTagIds.isEmpty,
              onTap: onClearFilters,
              showCloseButton: false,
            ),
          ),
          // 태그 칩들
          ...tags.map((tag) {
            final isSelected = selectedTagIds.contains(tag.id);
            return Padding(
              padding: EdgeInsets.only(right: 6),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            padding: EdgeInsets.all(3),
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
                  tooltip: AppLocalizations.of(context)!.bigCard,
                ),
                _ViewModeIconButton(
                  icon: Icons.grid_on_rounded,
                  isSelected: viewMode == ProjectViewMode.smallCard,
                  onPressed: () => onViewModeChanged(ProjectViewMode.smallCard),
                  tooltip: AppLocalizations.of(context)!.smallCard,
                ),
                _ViewModeIconButton(
                  icon: Icons.view_list_rounded,
                  isSelected: viewMode == ProjectViewMode.list,
                  onPressed: () => onViewModeChanged(ProjectViewMode.list),
                  tooltip: AppLocalizations.of(context)!.list,
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
  final ValueChanged<int> onLongPress;

  const _LargeCardView({
    required this.projects,
    required this.tags,
    required this.onProjectTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: _LargeProjectCard(
            project: project,
            tags: tags,
            onTap: () => onProjectTap(project.id),
            onLongPress: () => onLongPress(project.id),
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
  final VoidCallback onLongPress;

  const _LargeProjectCard({
    required this.project,
    required this.tags,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              project.imagePath != null
                  ? ProjectImage(
                      imagePath: project.imagePath,
                      fit: BoxFit.cover,
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
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.surface,
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
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatDateDisplay(
                                project.createdAt,
                                AppLocalizations.of(context)!,
                              ),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface.withOpacity(0.8),
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
                      return ColoredTagChip(key: ValueKey(tag.id), tag: tag);
                    }).toList(),
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      color: Theme.of(context).colorScheme.surface,
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
      final tagIds = decoded
          .map((e) => int.tryParse(e.toString()) ?? -1)
          .toSet();
      return tags.where((tag) => tagIds.contains(tag.id)).toList();
    } catch (_) {
      return [];
    }
  }
}

// ============================================================
// 작은 카드 뷰
// ============================================================

class _SmallCardView extends StatelessWidget {
  final List<Project> projects;
  final List<Tag> tags;
  final ValueChanged<int> onProjectTap;
  final ValueChanged<int> onLongPress;

  const _SmallCardView({
    required this.projects,
    required this.tags,
    required this.onProjectTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
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
          onLongPress: () => onLongPress(project.id),
        );
      },
    );
  }
}

class _SmallProjectCard extends StatelessWidget {
  final Project project;
  final List<Tag> tags;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SmallProjectCard({
    required this.project,
    required this.tags,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final projectTags = _getProjectTags();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 이미지 영역
            Container(
              color: const Color(0xFFD9D9D9),
              child: project.imagePath != null
                  ? ProjectImage(
                      imagePath: project.imagePath,
                      fit: BoxFit.cover,
                      placeholder: _placeholderImage(context),
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
                    return ColoredTagChip(key: ValueKey(tag.id), tag: tag);
                  }).toList(),
                ),
              ),

            // 하단 정보 바 (Project Name + Arrow)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 32,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.surface,
                          height: 1.33,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Theme.of(context).colorScheme.surface,
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
      final tagIds = decoded
          .map((e) => int.tryParse(e.toString()) ?? -1)
          .toSet();
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
  final ValueChanged<int> onLongPress;

  const _ListView({
    required this.projects,
    required this.tags,
    required this.onProjectTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectListTile(
          project: project,
          tags: tags,
          onTap: () => onProjectTap(project.id),
          onLongPress: () => onLongPress(project.id),
        );
      },
    );
  }
}

// ============================================================
// 빈 상태 뷰
// ============================================================

class _EmptyView extends ConsumerWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectsProvider);
    final isPremium = ref.watch(premiumProvider);
    final isLocked = !PremiumPolicy.canCreateProject(state.allProjects.length, isPremium);
    final buttonStyle = PremiumUIHelper.getButtonStyle(
      isLocked: isLocked,
      defaultIcon: Icons.add,
      defaultBackgroundColor: Theme.of(context).colorScheme.primary,
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
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
              AppLocalizations.of(context)!.noProjectsYet,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                if (!isLocked) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NewProjectScreen()),
                  );
                } else {
                  PremiumUIHelper.showUpsellSnackbar(context);
                }
              },
              icon: Icon(buttonStyle.$1),
              label: Text(AppLocalizations.of(context)!.createProject),
              style: FilledButton.styleFrom(
                backgroundColor: buttonStyle.$2,
              ),
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
        padding: EdgeInsets.all(24),
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
              AppLocalizations.of(context)!.noMatchingProjects,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.filterResetDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off),
              label: Text(AppLocalizations.of(context)!.resetFilter),
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
            title: Text(AppLocalizations.of(context)!.copyProject),
            onTap: () {
              Navigator.pop(context);
              ref
                  .read(projectsProvider.notifier)
                  .onEvent(DuplicateProject(projectId));
            },
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: Text(AppLocalizations.of(context)!.assignTags),
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
