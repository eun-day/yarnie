import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../db/app_db.dart';
import '../../widgets/tag_chip.dart';
import '../../model/tag_color_preset.dart';
import '../../core/providers/premium_provider.dart';
import '../../widgets/ad_visibility_wrapper.dart';
import '../../widgets/common_banner_ad.dart';
import '../../common/ad_helper.dart';
import 'package:yarnie/modules/stash/stash_api.dart';
import 'new_stash_screen.dart';
import 'stash_detail_screen.dart';
import 'package:yarnie/widgets/app_image.dart';
import '../../widgets/stash_tag_selection_sheet.dart';

const _kStashViewModeKey = 'stash_view_mode';

class StashRoot extends ConsumerStatefulWidget {
  final ScrollController controller;
  const StashRoot({super.key, required this.controller});

  @override
  ConsumerState<StashRoot> createState() => _StashRootState();
}

class _StashRootState extends ConsumerState<StashRoot> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stashProvider.notifier).onEvent(const LoadStash());
      _loadViewMode();
    });
  }

  Future<void> _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_kStashViewModeKey) ?? 0;
    final mode = StashViewMode.values[modeIndex];
    if (mounted) {
      ref.read(stashProvider.notifier).onEvent(ChangeViewMode(mode));
    }
  }

  Future<void> _saveViewMode(StashViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kStashViewModeKey, mode.index);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(stashEffectsProvider, (_, asyncEffect) {
      asyncEffect.whenData((effect) => _handleEffect(context, effect));
    });

    final state = ref.watch(stashProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.stash),
            Text(
              AppLocalizations.of(context)!.stashYarnsCount(state.allYarns.length),
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewStashScreen()),
                );
              },
              icon: const Icon(Icons.add, size: 20),
              label: Text(AppLocalizations.of(context)!.createStash),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF637069),
                padding: const EdgeInsets.symmetric(horizontal: 12),
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

            // 태그 필터 바
            _TagFilterBar(
              tags: state.allTags,
              selectedTagIds: state.selectedTagIds,
              onTagTap: (tagId) {
                ref.read(stashProvider.notifier).onEvent(ToggleTagFilter(tagId));
              },
              onClearFilters: () {
                ref.read(stashProvider.notifier).onEvent(const ClearFilters());
              },
            ),
            // 뷰 모드 바
            _ViewModeBar(
              viewMode: state.viewMode,
              onViewModeChanged: (mode) {
                ref.read(stashProvider.notifier).onEvent(ChangeViewMode(mode));
                _saveViewMode(mode);
              },
            ),
            // 바디 영역
            Expanded(child: _buildBody(state)),
          ],
        ),
      ),
      bottomNavigationBar: ref.watch(premiumProvider)
          ? null
          : AdVisibilityWrapper(
              child: CommonBannerAdWidget(
                adUnitId: AdHelper.projectListBannerId, // 광고 에셋 키 재활용
              ),
            ),
    );
  }

  Widget _buildBody(StashState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isEmpty) {
      return const _EmptyView();
    }

    if (state.isFilteredEmpty) {
      return _FilteredEmptyView(
        onClearFilters: () {
          ref.read(stashProvider.notifier).onEvent(const ClearFilters());
        },
      );
    }

    final yarns = state.displayYarns;

    switch (state.viewMode) {
      case StashViewMode.smallCard:
        return _SmallCardView(
          yarns: yarns,
          tags: state.allTags,
          onYarnTap: _openStashDetail,
          onLongPress: _showStashMenu,
        );
      case StashViewMode.list:
        return _ListView(
          yarns: yarns,
          tags: state.allTags,
          onYarnTap: _openStashDetail,
          onLongPress: _showStashMenu,
        );
    }
  }

  void _openStashDetail(int id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StashDetailScreen(stashYarnId: id),
      ),
    );
  }

  void _showStashMenu(int id) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StashMenuSheet(yarnId: id),
    );
  }

  void _handleEffect(BuildContext context, StashEffect effect) {
    final l10n = AppLocalizations.of(context)!;
    switch (effect) {
      case ShowStashErrorMessage(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      case ShowStashLocalizedErrorMessage(:final messageBuilder):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(messageBuilder(l10n)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      case ShowStashLocalizedSuccessMessage(:final messageBuilder):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageBuilder(l10n))),
        );
      case StashYarnCreated(:final yarnId):
        _openStashDetail(yarnId);
      case StashYarnUpdated():
      case StashYarnDeleted():
        break;
      case ShowAssignStashTagsDialog(:final yarnId, :final currentTagIds):
        _showTagAssignmentSheet(context, yarnId, currentTagIds);
        break;
    }
  }

  Future<void> _showTagAssignmentSheet(
    BuildContext context,
    int yarnId,
    List<int> currentTagIds,
  ) async {
    final result = await showModalBottomSheet<Set<int>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StashTagSelectionSheet(
        initialSelectedIds: currentTagIds.toSet(),
      ),
    );

    if (result != null && mounted) {
      ref.read(stashProvider.notifier).onEvent(
            AssignTagsToStashYarnEvent(yarnId, result.toList()),
          );
    }
  }
}

// ============================================================
// 태그 필터 바
// ============================================================
class _TagFilterBar extends StatelessWidget {
  final List<StashTag> tags;
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
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: TagChip(
              label: AppLocalizations.of(context)!.all,
              isSelected: selectedTagIds.isEmpty,
              onTap: onClearFilters,
              showCloseButton: false,
            ),
          ),
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
// 뷰 모드 바 (LargeCardView 제외, 2개 버튼만 노출)
// ============================================================
class _ViewModeBar extends StatelessWidget {
  final StashViewMode viewMode;
  final ValueChanged<StashViewMode> onViewModeChanged;

  const _ViewModeBar({required this.viewMode, required this.onViewModeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
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
                  icon: Icons.grid_on_rounded,
                  isSelected: viewMode == StashViewMode.smallCard,
                  onPressed: () => onViewModeChanged(StashViewMode.smallCard),
                  tooltip: AppLocalizations.of(context)!.smallCard,
                ),
                _ViewModeIconButton(
                  icon: Icons.view_list_rounded,
                  isSelected: viewMode == StashViewMode.list,
                  onPressed: () => onViewModeChanged(StashViewMode.list),
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
        style: const ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity(horizontal: -2, vertical: -2),
        ),
      ),
    );
  }
}

// ============================================================
// Stash 용 Colored Tag Chip
// ============================================================
class ColoredStashTagChip extends StatelessWidget {
  final StashTag tag;
  const ColoredStashTagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final tagColorValue = tag.color;
    final tagColor = Color(tagColorValue);
    final presetTextColor = TagColorPreset.getTextColor(tagColorValue);
    final textColor = presetTextColor ??
        (ThemeData.estimateBrightnessForColor(tagColor) == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : Colors.black87);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 2.5),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.33,
        ),
      ),
    );
  }
}

// ============================================================
// 1. 작은 카드 뷰
// ============================================================
class _SmallCardView extends StatelessWidget {
  final List<StashYarn> yarns;
  final List<StashTag> tags;
  final ValueChanged<int> onYarnTap;
  final ValueChanged<int> onLongPress;

  const _SmallCardView({
    required this.yarns,
    required this.tags,
    required this.onYarnTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: yarns.length,
      itemBuilder: (context, index) {
        final yarn = yarns[index];
        return _SmallStashCard(
          yarn: yarn,
          tags: tags,
          onTap: () => onYarnTap(yarn.id),
          onLongPress: () => onLongPress(yarn.id),
        );
      },
    );
  }
}

class _SmallStashCard extends StatelessWidget {
  final StashYarn yarn;
  final List<StashTag> tags;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SmallStashCard({
    required this.yarn,
    required this.tags,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final yarnTags = _getYarnTags();
    final l10n = AppLocalizations.of(context)!;

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
            // 이미지 영역 (1:1 비율 전체 채움)
            AppImage(
              imagePath: yarn.imagePath,
              fallbackPadding: 24,
            ),
            
            // 좌측 상단 태그
            if (yarnTags.isNotEmpty)
              Positioned(
                left: 8,
                top: 8,
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: yarnTags.take(2).map((t) => ColoredStashTagChip(key: ValueKey(t.id), tag: t)).toList(),
                ),
              ),

            // 하단 정보 바 (프로젝트 탭 스몰카드 뷰 of overlay style 이식)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                color: Colors.black.withOpacity(0.4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1줄: 실 이름
                    Text(
                      yarn.yarnName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.surface,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // 2줄: 남은 양 + 색상명 (최대 4글자) 수직 정렬을 위한 Row 분리
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.skeinsCount(yarn.skeins ?? 0),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                            height: 1.0,
                          ),
                        ),
                        if (yarn.colorwayName != null && yarn.colorwayName!.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.5),
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                                height: 1.0,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              yarn.colorwayName!.length > 4 
                                  ? '${yarn.colorwayName!.substring(0, 4)}...' 
                                  : yarn.colorwayName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ],
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

  List<StashTag> _getYarnTags() {
    if (yarn.tagIds == null || yarn.tagIds!.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(yarn.tagIds!);
      if (decoded is! List) return [];
      final tagIds = decoded.map((e) => int.tryParse(e.toString()) ?? -1).toSet();
      return tags.where((t) => tagIds.contains(t.id)).toList();
    } catch (_) {
      return [];
    }
  }

  // 로컬 파일 경로인 경우 대응용 헬퍼
  File dynamicFile(String path) {
    return File(path);
  }
}

// ============================================================
// 2. 리스트 뷰
// ============================================================
class _ListView extends StatelessWidget {
  final List<StashYarn> yarns;
  final List<StashTag> tags;
  final ValueChanged<int> onYarnTap;
  final ValueChanged<int> onLongPress;

  const _ListView({
    required this.yarns,
    required this.tags,
    required this.onYarnTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: yarns.length,
      itemBuilder: (context, index) {
        final yarn = yarns[index];
        return StashListTile(
          yarn: yarn,
          tags: tags,
          onTap: () => onYarnTap(yarn.id),
          onLongPress: () => onLongPress(yarn.id),
        );
      },
    );
  }
}

class StashListTile extends StatelessWidget {
  final StashYarn yarn;
  final List<StashTag> tags;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const StashListTile({
    required this.yarn,
    required this.tags,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final yarnTags = _getYarnTags();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 썸네일
              SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: AppImage(
                    imagePath: yarn.imagePath,
                    fallbackPadding: 0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      yarn.yarnName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5,
                        letterSpacing: -0.31,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if ((yarn.brandName != null && yarn.brandName!.isNotEmpty) ||
                        (yarn.colorwayName != null && yarn.colorwayName!.isNotEmpty)) ...[
                      Row(
                        children: [
                          if (yarn.brandName != null && yarn.brandName!.isNotEmpty)
                            Text(
                              yarn.brandName!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                height: 1.42,
                                letterSpacing: -0.15,
                              ),
                            ),
                          if (yarn.colorwayName != null && yarn.colorwayName!.isNotEmpty) ...[
                            if (yarn.brandName != null && yarn.brandName!.isNotEmpty)
                              const SizedBox(width: 6),
                            Text(
                              yarn.brandName != null && yarn.brandName!.isNotEmpty
                                  ? '•  ${yarn.colorwayName!}'
                                  : yarn.colorwayName!,
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
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      children: [
                        Text(
                          l10n.skeinsCount(yarn.skeins ?? 0),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            height: 1.42,
                            letterSpacing: -0.15,
                          ),
                        ),
                        if (yarnTags.isNotEmpty) ...[
                          const SizedBox(width: 9),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: yarnTags.map((t) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: ColoredStashTagChip(key: ValueKey(t.id), tag: t),
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

  List<StashTag> _getYarnTags() {
    if (yarn.tagIds == null || yarn.tagIds!.isEmpty) return [];
    try {
      final dynamic decoded = jsonDecode(yarn.tagIds!);
      if (decoded is! List) return [];
      final tagIds = decoded.map((e) => int.tryParse(e.toString()) ?? -1).toSet();
      return tags.where((t) => tagIds.contains(t.id)).toList();
    } catch (_) {
      return [];
    }
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
              Icons.widgets_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noStashesYet,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewStashScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.createStash),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF637069),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noMatchingYarns,
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
// Stash 메뉴 시트
// ============================================================
class _StashMenuSheet extends ConsumerWidget {
  final int yarnId;
  const _StashMenuSheet({required this.yarnId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(stashProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // 실 정보 복제
              _StashMenuButton(
                label: l10n.copyStash,
                icon: Icons.copy,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.onSurface,
                iconColor: Theme.of(context).colorScheme.onSurface,
                showBorder: true,
                onTap: () {
                  Navigator.pop(context);
                  ref.read(stashProvider.notifier).onEvent(
                        DuplicateStashYarnEvent(yarnId, l10n.copySuffix),
                      );
                },
              ),
              const SizedBox(height: 8),
              // 태그 지정
              _StashMenuButton(
                label: l10n.assignTags,
                icon: Icons.label_outline,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.onSurface,
                iconColor: Theme.of(context).colorScheme.onSurface,
                showBorder: true,
                onTap: () {
                  Navigator.pop(context);
                  ref.read(stashProvider.notifier).onEvent(
                        OpenAssignStashTagsDialog(yarnId),
                      );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StashMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final bool showBorder;
  final VoidCallback onTap;

  const _StashMenuButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.showBorder = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: showBorder
              ? Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.694,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
                letterSpacing: -0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
