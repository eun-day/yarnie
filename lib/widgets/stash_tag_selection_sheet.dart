import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/model/tag_color_preset.dart';

class StashTagSelectionSheet extends ConsumerStatefulWidget {
  final Set<int> initialSelectedIds;
  const StashTagSelectionSheet({required this.initialSelectedIds, super.key});

  @override
  ConsumerState<StashTagSelectionSheet> createState() => _StashTagSelectionSheetState();
}

class _StashTagSelectionSheetState extends ConsumerState<StashTagSelectionSheet> {
  late Set<int> _selectedIds;
  String _searchQuery = '';
  late final TextEditingController _newTagNameController;
  final FocusNode _newTagFocusNode = FocusNode();
  bool _isAdding = false;

  final List<Color> _colorPalette = TagColorPreset.all.map((e) => e.backgroundColor).toList();
  late Color _newTagColor;

  List<StashTag> _allTags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initialSelectedIds};
    _newTagNameController = TextEditingController();
    _newTagColor = _colorPalette.first;
    _loadTags();
  }

  Future<void> _loadTags() async {
    setState(() => _isLoading = true);
    try {
      final tags = await appDb.getAllStashTags();
      setState(() {
        _allTags = tags;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
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
    final filteredTags = _filterTags(_allTags, _searchQuery);

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
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
              // 핸들바
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

              // 헤더: 타이틀 + 추가 버튼
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

              // 검색 필드
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
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),

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

              // 태그 리스트
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: filteredTags.length + (_isAdding ? 1 : 0),
                        itemBuilder: (context, index) {
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
                                  _buildTagChip(tag),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // 적용 버튼
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

  Widget _buildTagChip(StashTag tag) {
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

  Future<void> _handleCreateTag() async {
    if (_newTagNameController.text.isNotEmpty) {
      try {
        await appDb.createStashTag(
          name: _newTagNameController.text,
          color: _newTagColor.value,
        );
        _newTagNameController.clear();
        setState(() {
          _isAdding = false;
        });
        await _loadTags();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

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

  List<StashTag> _filterTags(List<StashTag> allTags, String query) {
    if (query.isEmpty) {
      return allTags;
    }
    return allTags
        .where((tag) => tag.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _showTagActionSheet(StashTag tag) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _StashTagActionSheet(
        tag: tag,
        colorPalette: _colorPalette,
        onTagUpdated: () => _loadTags(),
      ),
    );
  }
}

class _StashTagActionSheet extends ConsumerWidget {
  final StashTag tag;
  final List<Color> colorPalette;
  final VoidCallback onTagUpdated;

  const _StashTagActionSheet({
    required this.tag,
    required this.colorPalette,
    required this.onTagUpdated,
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
                  Navigator.pop(context);
                  _showEditTagDialog(context);
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
                  Navigator.pop(context);
                  _showDeleteConfirm(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditTagDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: tag.name);
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
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.save),
              onPressed: () async {
                await appDb.updateStashTag(
                  tagId: tag.id,
                  name: nameController.text,
                  color: selectedColor.value,
                );
                Navigator.of(dialogContext).pop();
                onTagUpdated();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirm(BuildContext context) {
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await appDb.deleteStashTag(tag.id);
                          Navigator.pop(dialogContext);
                          onTagUpdated();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4183D),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(l10n.delete),
                      ),
                    ),
                  ],
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
