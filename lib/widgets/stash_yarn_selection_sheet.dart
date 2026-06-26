import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/modules/stash/stash_api.dart';
import 'package:yarnie/features/stash/new_stash_screen.dart';
import 'package:yarnie/widgets/app_image.dart';

class StashYarnSelectionSheet extends ConsumerStatefulWidget {
  const StashYarnSelectionSheet({super.key});

  @override
  ConsumerState<StashYarnSelectionSheet> createState() => _StashYarnSelectionSheetState();
}

class _StashYarnSelectionSheetState extends ConsumerState<StashYarnSelectionSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stashProvider.notifier).onEvent(const LoadStash());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stashProvider);
    final l10n = AppLocalizations.of(context)!;

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle Bar
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.selectStashYarn,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      // 우측 상단 실 추가 버튼 (실이 있을 때도 상시 노출)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NewStashScreen(isFromSelectionSheet: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(l10n.addYarn),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),

                // Body List
                Expanded(
                  child: _buildContent(state, l10n, scrollController),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(StashState state, AppLocalizations l10n, ScrollController scrollController) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.allYarns.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noStashesYet, // "아직 등록한 실이 없어요."
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewStashScreen(isFromSelectionSheet: true),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addYarn),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.allYarns.length,
      itemBuilder: (context, index) {
        final yarn = state.allYarns[index];
        final specText = _buildSpecText(yarn, l10n);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, yarn.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Yarn Image Thumbnail
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AppImage(
                        imagePath: yarn.imagePath,
                        fallbackPadding: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Yarn info text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (yarn.brandName != null && yarn.brandName!.isNotEmpty)
                          Text(
                            yarn.brandName!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Text(
                          yarn.yarnName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (specText.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            specText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Yarn Quantity (Skeins)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.skeinsCount(yarn.skeins ?? 0),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _buildSpecText(StashYarn yarn, AppLocalizations l10n) {
    final List<String> parts = [];
    if (yarn.colorwayName != null && yarn.colorwayName!.isNotEmpty) {
      parts.add(yarn.colorwayName!);
    }
    if (yarn.dyeLot != null && yarn.dyeLot!.isNotEmpty) {
      parts.add('${l10n.dyeLot}: ${yarn.dyeLot}');
    }
    if (yarn.location != null && yarn.location!.isNotEmpty) {
      parts.add(yarn.location!);
    }
    return parts.join('  •  ');
  }
}
