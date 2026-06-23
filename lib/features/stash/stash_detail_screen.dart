import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/model/tag_color_preset.dart';
import '../../project_detail_screen.dart';
import 'package:yarnie/modules/stash/stash_api.dart';
import 'new_stash_screen.dart';
import 'package:yarnie/widgets/number_input_group.dart';
import 'package:yarnie/widgets/app_image.dart';
import 'package:yarnie/widgets/stash_delete_dialog.dart';
import '../../core/providers/premium_provider.dart';
import '../../widgets/ad_visibility_wrapper.dart';
import '../../widgets/common_banner_ad.dart';
import '../../common/ad_helper.dart';

class StashDetailScreen extends ConsumerStatefulWidget {
  final int stashYarnId;
  const StashDetailScreen({super.key, required this.stashYarnId});

  @override
  ConsumerState<StashDetailScreen> createState() => _StashDetailScreenState();
}

class _StashDetailScreenState extends ConsumerState<StashDetailScreen> {
  TextEditingController? _skeinsController;
  FocusNode? _skeinsFocusNode;

  @override
  void initState() {
    super.initState();
    _skeinsFocusNode = FocusNode();
    Future.microtask(() {
      ref.read(stashProvider.notifier).onEvent(const LoadStash());
    });
  }

  @override
  void dispose() {
    _skeinsController?.dispose();
    _skeinsFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final stashState = ref.watch(stashProvider);

    // 현재 StashYarn 검색
    final yarnList = stashState.allYarns.where((y) => y.id == widget.stashYarnId);
    if (yarnList.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.errorLoadingData)),
      );
    }
    final yarn = yarnList.first;
    final skeins = yarn.skeins ?? 0.0;

    if (_skeinsController == null) {
      _skeinsController = TextEditingController(text: skeins.toString());
    } else {
      if (!_skeinsFocusNode!.hasFocus) {
        final parsed = double.tryParse(_skeinsController!.text) ?? 0.0;
        if (parsed != skeins) {
          _skeinsController!.text = skeins.toString();
        }
      }
    }

    // Ravelry standard 굵기 및 스펙 렌더링용
    final String displayYarnWeight = yarn.yarnWeight ?? '-';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.7,
                ),
              ),
              color: Theme.of(context).colorScheme.surface,
              elevation: 2,
              padding: EdgeInsets.zero,
              child: Container(
                width: 42,
                height: 36,
                alignment: Alignment.center,
                child: Icon(
                  Icons.more_vert,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.editStash,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.deleteStash,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.error,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ],
              onSelected: (String value) async {
                if (value == 'edit') {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NewStashScreen(stashYarnId: yarn.id),
                    ),
                  );
                  if (context.mounted) {
                    FocusScope.of(context).unfocus();
                  }
                } else if (value == 'delete') {
                  if (context.mounted) {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => StashDeleteDialog(
                        yarnName: yarn.yarnName,
                        onDelete: () {
                          Navigator.of(dialogContext).pop(true);
                        },
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      ref.read(stashProvider.notifier).onEvent(DeleteStashYarnEvent(yarn.id));
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. 큰 이미지 또는 기본 위젯 아이콘
              _buildImageHero(yarn),
  
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. 브랜드 & 실 명칭
                    Text(
                      yarn.brandName ?? '-',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      yarn.yarnName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (yarn.nickname != null && yarn.nickname!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '"${yarn.nickname}"',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
  
                    // 태그 목록
                    _buildTagsRow(yarn, stashState.allTags),
                    const SizedBox(height: 24),
  
                    // 3. 간이 볼 수 카운터 (수량 직접 증감)
                    _buildSkeinsCounter(yarn, l10n, theme),
                    const SizedBox(height: 24),
  
                    // 4. 상세 스펙 카드
                    _buildSpecsCard(yarn, displayYarnWeight, l10n, theme),
                    const SizedBox(height: 24),
  
                    // 5. 사용 중인 프로젝트 목록 연계
                    _buildLinkedProjects(yarn, l10n, theme),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ref.watch(premiumProvider)
          ? null
          : AdVisibilityWrapper(
              child: CommonBannerAdWidget(
                adUnitId: AdHelper.stashDetailBannerId,
              ),
            ),
    );
  }

  Widget _buildImageHero(StashYarn yarn) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
      child: FractionallySizedBox(
        widthFactor: 2 / 3,
        alignment: Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: AppImage(
              imagePath: yarn.imagePath,
              fallbackPadding: 48,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagsRow(StashYarn yarn, List<StashTag> allTags) {
    if (yarn.tagIds == null || yarn.tagIds!.isEmpty) return const SizedBox.shrink();
    try {
      final dynamic decoded = jsonDecode(yarn.tagIds!);
      if (decoded is! List) return const SizedBox.shrink();
      final tagIds = decoded.map((e) => int.tryParse(e.toString()) ?? -1).toSet();
      final yarnTags = allTags.where((t) => tagIds.contains(t.id)).toList();

      if (yarnTags.isEmpty) return const SizedBox.shrink();

      return Wrap(
        spacing: 6,
        runSpacing: 6,
        children: yarnTags.map((tag) {
          final tagColor = Color(tag.color);
          final presetTextColor = TagColorPreset.getTextColor(tag.color);
          final textColor = presetTextColor ??
              (ThemeData.estimateBrightnessForColor(tagColor) == Brightness.dark
                  ? Colors.white
                  : Colors.black87);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag.name,
              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildSkeinsCounter(StashYarn yarn, AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.skeins,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          NumberInputGroup(
            controller: _skeinsController!,
            focusNode: _skeinsFocusNode,
            isDecimal: true,
            min: 0,
            step: 0.1,
            onChanged: () {
              final newSkeins = double.tryParse(_skeinsController!.text) ?? 0.0;
              final currentSkeins = yarn.skeins ?? 0.0;
              final offset = newSkeins - currentSkeins;
              if (offset == 0) return;

              // DB 업데이트
              ref.read(stashProvider.notifier).onEvent(QuickAdjustSkeins(widget.stashYarnId, offset));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsCard(StashYarn yarn, String displayYarnWeight, AppLocalizations l10n, ThemeData theme) {
    final color = yarn.colorwayName ?? '-';
    final dyeLot = yarn.dyeLot ?? '-';
    final location = yarn.location ?? '-';
    final notes = yarn.notes ?? '-';

    final lengthPerSkeinStr = yarn.yarnLengthPerSkein != null
        ? '${yarn.yarnLengthPerSkein} ${yarn.lengthUnit == 'yards' ? 'yd' : 'm'}'
        : '-';
    final weightPerSkeinStr = yarn.yarnWeightPerSkein != null
        ? '${yarn.yarnWeightPerSkein} ${yarn.weightUnit == 'grams' ? 'g' : 'oz'}'
        : '-';

    final totalLengthStr = yarn.totalLength != null
        ? '${yarn.totalLength} ${yarn.lengthUnit == 'yards' ? 'yd' : 'm'}'
        : '-';
    final totalWeightStr = yarn.totalWeight != null
        ? '${yarn.totalWeight} ${yarn.weightUnit == 'grams' ? 'g' : 'oz'}'
        : '-';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.stashInfo,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _buildSpecRow(l10n.colorwayName, color, theme),
            _buildSpecRow(l10n.dyeLot, dyeLot, theme),
            _buildSpecRow(l10n.yarnWeight, displayYarnWeight, theme),
            _buildSpecRow(l10n.yarnLengthPerSkein, lengthPerSkeinStr, theme),
            _buildSpecRow(l10n.yarnWeightPerSkein, weightPerSkeinStr, theme),
            _buildSpecRow(l10n.totalLength, totalLengthStr, theme),
            _buildSpecRow(l10n.totalWeight, totalWeightStr, theme),
            _buildSpecRow(l10n.location, location, theme),
            const Divider(height: 24),
            Text(
              l10n.memo,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 4),
            Text(
              notes,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 사용 중인 프로젝트 목록 연계 표시
  // ============================================================
  Widget _buildLinkedProjects(StashYarn yarn, AppLocalizations l10n, ThemeData theme) {
    // 1단계 MVP 연계: 프로젝트의 lotNumber(실 로트 번호)가 StashYarn의 dyeLot과 일치하는 프로젝트 필터링
    return StreamBuilder<List<Project>>(
      stream: appDb.watchAll(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final allProjects = snapshot.data!;
        final matchedProjects = allProjects.where((p) {
          // 실 로트 번호 또는 별명/제품명이 매치되는 프로젝트 필터
          final lotMatch = yarn.dyeLot != null &&
              yarn.dyeLot!.isNotEmpty &&
              p.lotNumber != null &&
              p.lotNumber!.trim().toLowerCase() == yarn.dyeLot!.trim().toLowerCase();
          return lotMatch;
        }).toList();

        if (matchedProjects.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              l10n.recentProjects, // "이 실을 사용 중인 프로젝트" 번역 키 대용
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matchedProjects.length,
              itemBuilder: (context, index) {
                final project = matchedProjects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.folder_open),
                    title: Text(
                      project.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('${l10n.lotNumberLabel}: ${project.lotNumber ?? "-"}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(projectId: project.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

