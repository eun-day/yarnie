import 'dart:async';

import 'package:flutter/material.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      initialChildSize: 0.75, // 시트가 차지하는 초기 화면 높이 비율
      minChildSize: 0.75, // 최소 높이
      maxChildSize: 0.75, // 최대 높이 (전체 화면)
      expand: false, // 시트가 항상 전체 화면을 차지하지 않도록
      builder: (BuildContext context, ScrollController scrollController) {
        return Scaffold( // Scaffold를 사용하여 AppBar 등을 포함
          appBar: AppBar(
            title: const Text('태그 선택'),
            automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedIds); // 선택된 ID 반환
                },
                child: const Text('완료'),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: '태그 검색...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTags.length,
                  itemBuilder: (context, index) {
                    final tag = filteredTags[index];
                    final isSelected = _selectedIds.contains(tag.id);
                    // No direct textColor usage here, but kept for context if needed or cleanup
                    // Since ColoredTagChip handles it, we don't strictly need to calc textColor here 
                    // unless we use it for the Checkbox or InkWell text (which we don't).
                    // We only pass tag to ColoredTagChip.

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
                      onLongPress: () => _showEditTagDialog(tag),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Checkbox(
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
                            ),
                            const SizedBox(width: 8.0),
                            ColoredTagChip(tag: tag),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // 새 태그 추가 영역
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('새 태그 추가', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _newTagNameController,
                            decoration: const InputDecoration(
                              labelText: '태그 이름',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<Color>(
                            value: _newTagColor,
                            onChanged: (Color? color) {
                              if (color != null) {
                                setState(() {
                                  _newTagColor = color;
                                });
                              }
                            },
                            items: _colorPalette.map((color) {
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
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_newTagNameController.text.isNotEmpty) {
                              ref.read(tagsProvider.notifier).onEvent(CreateTag(
                                name: _newTagNameController.text,
                                color: _newTagColor.value,
                              ));
                            }
                          },
                          child: const Text('추가'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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

  Future<void> _showEditTagDialog(Tag tag) async { // tag is now non-nullable because this dialog is only for editing existing tags
    final TextEditingController nameController = TextEditingController(text: tag.name);
    // Ensure the initial color is an object from the palette to avoid assertion errors.
    Color selectedColor = _colorPalette.firstWhere((c) => c.value == tag.color, orElse: () => _colorPalette.first);

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) { // Use dialogContext to avoid conflicts
        return AlertDialog(
          title: const Text('태그 수정'), // Always '태그 수정'
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '태그 이름',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<Color>(
                        value: selectedColor, // This should now always be from _colorPalette
                        onChanged: (Color? color) {
                          if (color != null) {
                            setState(() => selectedColor = color);
                          }
                        },
                        items: _colorPalette.map((color) {
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
              child: const Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref.read(tagsProvider.notifier).onEvent(DeleteTag(tag.id));
                Navigator.of(dialogContext).pop();
              },
            ),
            const Spacer(),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('저장'), // Always '저장'
              onPressed: () {
                final notifier = ref.read(tagsProvider.notifier);
                notifier.onEvent(UpdateTag(
                  tagId: tag.id,
                  newName: nameController.text,
                  newColor: selectedColor.value,
                ));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}