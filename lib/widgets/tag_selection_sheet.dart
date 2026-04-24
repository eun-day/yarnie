import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/tag_color_preset.dart';
import 'package:yarnie/modules/tags/tags_api.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';

class TagSelectionSheet extends ConsumerStatefulWidget {
  final Set<int> initialSelectedIds;

  const TagSelectionSheet({required this.initialSelectedIds, super.key});

  @override
  ConsumerState<TagSelectionSheet> createState() => _TagSelectionSheetState();
}

class _TagSelectionSheetState extends ConsumerState<TagSelectionSheet> {
  late Set<int> _selectedIds;
  String _searchQuery = '';
  late final TextEditingController _newTagNameController;
  final FocusNode _newTagFocusNode = FocusNode();
  bool _isAdding = false;

  final List<Color> _colorPalette = TagColorPreset.all.map((e) => e.backgroundColor).toList();
  late Color _newTagColor; // Make it late, initialize in initState

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initialSelectedIds};
    _newTagNameController = TextEditingController();
    _newTagColor = _colorPalette.first; // Initialize here
    // 태그 목록 로드
    Future.microtask(() => ref.read(tagsProvider.notifier).onEvent(const LoadTags()));
  }

  void _handleEffect(TagsEffect effect) {
    if (effect is ShowTagSuccessMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(effect.message)),
      );
      _newTagNameController.clear(); // 새 태그 생성 후 필드 초기화
      // Navigator.of(context).pop(); // 다이얼로그 닫기 (태그 추가/수정/삭제 후) - 바텀 시트 내에서 다이얼로그만 닫아야 함.
    } else if (effect is ShowTagErrorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(effect.message), backgroundColor: Theme.of(context).colorScheme.error),
      );
    }
  }

  @override
  void dispose() {
    _newTagNameController.dispose();
    _newTagFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 효과 리스너 (성공/실패 메시지, 다이얼로그 닫기 등)
    ref.listen<AsyncValue<TagsEffect>>(tagsEffectsProvider, (previous, next) {
      next.whenData((effect) {
        if (mounted) {
          _handleEffect(effect);
        }
      });
    });

    final tagsState = ref.watch(tagsProvider);
    final filteredTags = _filterTags(tagsState.allTags, _searchQuery);

    return DraggableScrollableSheet(
      initialChildSize: 0.8, // 시트가 차지하는 초기 화면 높이 비율
      minChildSize: 0.5, // 최소 높이
      maxChildSize: 0.8, // 최대 높이
      expand: false, // 시트가 항상 전체 화면을 차지하지 않도록
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── 핸들바 ───
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              // ─── 헤더: 타이틀 + 서브타이틀 + 추가 버튼 ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.tagSelection,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.tagSelectionSubtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: -0.15,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // New Tag Button (+)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAdding = !_isAdding;
                          if (_isAdding) {
                            _newTagNameController.clear();
                            _newTagColor = _colorPalette.first;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _newTagFocusNode.requestFocus();
                            });
                          }
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isAdding ? Icons.close : Icons.add,
                          size: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ─── 검색 필드 ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: l10n.searchTags,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    prefixIcon: null,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // ─── 도움말 문구 (기존 유지) ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 13,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.tagSelectionDesc,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                          letterSpacing: -0.15,
                          height: 1.43,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ─── 태그 리스트 ───
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filteredTags.length + (_isAdding ? 1 : 0),
                  itemBuilder: (context, index) {
                    // 새 태그 추가 영역 (리스트 최상단)
                    if (_isAdding && index == 0) {
                      return _buildNewTagInputArea(theme, l10n);
                    }

                    final tagIndex = _isAdding ? index - 1 : index;
                    final tag = filteredTags[tagIndex];
                    final isSelected = _selectedIds.contains(tag.id);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedIds.remove(tag.id);
                          } else {
                            _selectedIds.add(tag.id);
                          }
                        });
                      },
                      onLongPress: () => _showTagActionSheet(tag),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        child: Row(
                          children: [
                            // 체크박스
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (bool? selected) {
                                  setState(() {
                                    if (selected == true) {
                                      _selectedIds.add(tag.id);
                                    } else {
                                      _selectedIds.remove(tag.id);
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outlineVariant,
                                  width: 1.5,
                                ),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            // 태그 칩
                            ColoredTagChip(tag: tag),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),



              // ─── "적용" 버튼 ───
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(_selectedIds);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C6B5D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.applyTags,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 새 태그 추가 인라인 입력 영역 (리스트 최상단에 표시)
  Widget _buildNewTagInputArea(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 0.694,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 태그 이름 입력 + 색상 선택
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTagNameController,
                    focusNode: _newTagFocusNode,
                    decoration: InputDecoration(
                      hintText: l10n.tagName,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      isDense: true,
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface,
                    ),
                    onSubmitted: (_) => _handleCreateTag(),
                  ),
                ),
                const SizedBox(width: 10),
                // 색상 선택 버튼
                GestureDetector(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _newTagColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 버튼 영역
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _handleCreateTag,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7CB670),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.createNewTagButton,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.surface,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAdding = false;
                      });
                    },
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border.all(
                          color: theme.colorScheme.outline,
                          width: 0.694,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l10n.cancel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 새 태그 생성 처리
  void _handleCreateTag() {
    if (_newTagNameController.text.isNotEmpty) {
      ref.read(tagsProvider.notifier).onEvent(CreateTag(
        name: _newTagNameController.text,
        color: _newTagColor.value,
      ));
      setState(() {
        _isAdding = false;
      });
    }
  }

  /// 색상 선택 팝업
  void _showColorPicker() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _colorPalette.map((color) {
                    final isCurrentColor = _newTagColor.value == color.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _newTagColor = color);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isCurrentColor
                              ? Border.all(color: theme.colorScheme.primary, width: 2.5)
                              : Border.all(color: Colors.black12),
                        ),
                        child: isCurrentColor
                            ? Icon(Icons.check, size: 18, color: theme.colorScheme.primary)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Tag> _filterTags(List<Tag> allTags, String query) {
    if (query.isEmpty) {
      return allTags;
    }
    return allTags
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// 태그 롱프레스 시 액션 시트 (수정, 삭제)
  void _showTagActionSheet(Tag tag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _TagActionSheet(
        tag: tag,
        colorPalette: _colorPalette,
        onTagUpdated: () {
          // 태그 업데이트 후 선택 상태 유지
        },
      ),
    );
  }
}

/// 태그 롱프레스 액션 시트 (수정, 삭제) - PartManageSheet 패턴 활용
class _TagActionSheet extends ConsumerWidget {
  final Tag tag;
  final List<Color> colorPalette;
  final VoidCallback? onTagUpdated;

  const _TagActionSheet({
    required this.tag,
    required this.colorPalette,
    this.onTagUpdated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
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
              // Handle Bar
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
              // 수정
              _ActionButton(
                label: l10n.editTag,
                icon: Icons.edit_outlined,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.onSurface,
                iconColor: Theme.of(context).colorScheme.onSurface,
                showBorder: true,
                onTap: () {
                  final notifier = ref.read(tagsProvider.notifier);
                  Navigator.pop(context);
                  _showEditTagDialog(context, notifier);
                },
              ),
              const SizedBox(height: 8),
              // 삭제
              _ActionButton(
                label: l10n.delete,
                icon: Icons.delete_outline,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: const Color(0xFFD4183D),
                iconColor: const Color(0xFFD4183D),
                showBorder: true,
                onTap: () {
                  final notifier = ref.read(tagsProvider.notifier);
                  Navigator.pop(context);
                  _showDeleteConfirm(context, notifier);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditTagDialog(BuildContext context, TagsNotifier notifier) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController nameController = TextEditingController(text: tag.name);
    Color selectedColor = colorPalette.firstWhere(
      (c) => c.value == tag.color,
      orElse: () => colorPalette.first,
    );

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.editTag),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.tagName,
                        border: const OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<Color>(
                        value: selectedColor,
                        onChanged: (Color? color) {
                          if (color != null) {
                            setState(() => selectedColor = color);
                          }
                        },
                        items: colorPalette.map((color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(l10n.save),
              onPressed: () {
                notifier.onEvent(UpdateTag(
                  tagId: tag.id,
                  newName: nameController.text,
                  newColor: selectedColor.value,
                ));
                Navigator.of(dialogContext).pop();
                onTagUpdated?.call();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirm(BuildContext context, TagsNotifier notifier) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.deleteTag,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(dialogContext).colorScheme.onSurface,
                    letterSpacing: -0.44,
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.deleteTagConfirm(tag.name),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(dialogContext).colorScheme.onSurfaceVariant,
                    letterSpacing: -0.15,
                    height: 1.43,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // 삭제 버튼
                GestureDetector(
                  onTap: () {
                    notifier.onEvent(DeleteTag(tag.id));
                    Navigator.pop(dialogContext);
                      },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4183D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.delete,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(dialogContext).colorScheme.surface,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // 취소 버튼
                GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(dialogContext).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(dialogContext).colorScheme.outline,
                        width: 0.694,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(dialogContext).colorScheme.onSurface,
                        letterSpacing: -0.15,
                          ),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final bool showBorder;
  final VoidCallback onTap;

  const _ActionButton({
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