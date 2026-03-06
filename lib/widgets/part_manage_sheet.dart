import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/modules/projects/application/part_manage_notifier.dart';
import 'package:yarnie/modules/projects/application/part_manage_event.dart';
import 'package:yarnie/modules/projects/application/part_manage_effect.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';

/// Part 관리 시트
/// - Part 리스트를 보여주고 드래그로 순서 변경
/// - 파트 이름을 길게 눌러 수정
/// - 새 파트 추가 버튼
class PartManageSheet extends ConsumerStatefulWidget {
  final int projectId;

  /// 파트 변경/삭제/추가 시 외부에서 반응할 수 있도록 콜백 제공 (선택)
  final void Function(int? selectedPartId)? onPartChanged;

  const PartManageSheet({
    super.key,
    required this.projectId,
    this.onPartChanged,
  });

  @override
  ConsumerState<PartManageSheet> createState() => _PartManageSheetState();
}

class _PartManageSheetState extends ConsumerState<PartManageSheet> {
  bool _isAdding = false;
  int? _renamingPartId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(partManageProvider.notifier)
          .onEvent(LoadParts(widget.projectId));
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(partManageEffectsProvider, (_, asyncEffect) {
      asyncEffect.whenData((effect) {
        if (effect is ShowErrorEffect) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(effect.message)));
        } else if (effect is PartCreatedEffect) {
          widget.onPartChanged?.call(effect.partId);
        }
      });
    });

    final state = ref.watch(partManageProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 16, bottom: 8),
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFECECF0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // Header: 타이틀 + 설명 + 새 파트 추가 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Part 관리',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A0A0A),
                            letterSpacing: -0.31,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Part 이름을 길게 눌러 수정하거나, 왼쪽 아이콘을 드래그하여 순서를 변경하세요.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF717182),
                            letterSpacing: -0.15,
                            height: 1.43,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // New Part Button (+)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAdding = true;
                        _renamingPartId = null;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Color(0xFF0A0A0A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Part List
            Flexible(
              child: Builder(
                builder: (context) {
                  if (state.isLoading && state.parts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final parts = state.parts;

                  // items 배열을 구성합니다.
                  // adding 상태면 제일 첫 번째 아이템으로 input section을 넣습니다.
                  final List<Widget> listItems = [];

                  if (_isAdding) {
                    listItems.add(
                      _PartInputSection(
                        key: const ValueKey('add_new_part'),
                        projectId: widget.projectId,
                        onSave: (newName) {
                          ref
                              .read(partManageProvider.notifier)
                              .onEvent(CreatePart(widget.projectId, newName));
                          setState(() {
                            _isAdding = false;
                          });
                        },
                        onCancel: () {
                          setState(() {
                            _isAdding = false;
                          });
                        },
                      ),
                    );
                  }

                  if (parts.isEmpty && !_isAdding) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Center(
                        child: Text(
                          '등록된 Part가 없습니다.',
                          style: TextStyle(color: Color(0xFF717182)),
                        ),
                      ),
                    );
                  }

                  for (int i = 0; i < parts.length; i++) {
                    final part = parts[i];
                    if (_renamingPartId == part.id) {
                      listItems.add(
                        _PartInputSection(
                          key: ValueKey('rename_${part.id}'),
                          projectId: widget.projectId,
                          initialText: part.name,
                          onSave: (newName) {
                            ref
                                .read(partManageProvider.notifier)
                                .onEvent(UpdatePart(part.id, newName));
                            setState(() {
                              _renamingPartId = null;
                            });
                            widget.onPartChanged?.call(part.id);
                          },
                          onCancel: () {
                            setState(() {
                              _renamingPartId = null;
                            });
                          },
                        ),
                      );
                    } else {
                      listItems.add(
                        _PartItemTile(
                          key: ValueKey(part.id),
                          index: i,
                          part: part,
                          projectId: widget.projectId,
                          onRenameRequest: () {
                            setState(() {
                              _renamingPartId = part.id;
                              _isAdding = false;
                            });
                          },
                          onDeleted: () {
                            widget.onPartChanged?.call(null);
                          },
                        ),
                      );
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          elevation: 4,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: child,
                        );
                      },
                      onReorder: (oldIndex, newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final reordered = List<Part>.from(parts);
                        final item = reordered.removeAt(oldIndex);
                        reordered.insert(newIndex, item);

                        final partIds = reordered.map((e) => e.id).toList();
                        ref
                            .read(partManageProvider.notifier)
                            .onEvent(ReorderParts(widget.projectId, partIds));
                        HapticFeedback.lightImpact();
                      },
                      itemCount: listItems.length,
                      itemBuilder: (context, index) {
                        return listItems[index];
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 개별 Part 아이템 타일
class _PartItemTile extends StatelessWidget {
  final int index;
  final Part part;
  final int projectId;
  final VoidCallback? onRenameRequest;
  final VoidCallback? onDeleted;

  const _PartItemTile({
    super.key,
    required this.index,
    required this.part,
    required this.projectId,
    this.onRenameRequest,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onLongPress: () => _showPartActionSheet(context),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x1A000000), width: 0.694),
          ),
          child: Row(
            children: [
              // Drag Handle (GripVertical icon)
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 0),
                  child: Icon(
                    Icons.drag_indicator,
                    size: 20,
                    color: const Color(0xFF717182).withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Part Name
              Expanded(
                child: Text(
                  part.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A0A0A),
                    letterSpacing: -0.15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showPartActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _PartActionSheet(
        part: part,
        projectId: projectId,
        onRenameRequest: onRenameRequest,
        onDeleted: onDeleted,
      ),
    );
  }
}

/// Part 롱프레스 액션 시트 (이름 수정, 삭제)
class _PartActionSheet extends ConsumerWidget {
  final Part part;
  final int projectId;
  final VoidCallback? onRenameRequest;
  final VoidCallback? onDeleted;

  const _PartActionSheet({
    required this.part,
    required this.projectId,
    this.onRenameRequest,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
                    color: const Color(0xFFECECF0),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // 이름 수정
              _ActionButton(
                label: '이름 수정',
                icon: Icons.edit_outlined,
                backgroundColor: Colors.white,
                textColor: const Color(0xFF0A0A0A),
                iconColor: const Color(0xFF0A0A0A),
                showBorder: true,
                onTap: () {
                  Navigator.pop(context);
                  onRenameRequest?.call();
                },
              ),
              const SizedBox(height: 8),
              // 삭제
              _ActionButton(
                label: '삭제',
                icon: Icons.delete_outline,
                backgroundColor: Colors.white,
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

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Part 삭제',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0A0A0A),
                        letterSpacing: -0.44,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\'${part.name}\' Part를 삭제하시겠습니까?\n이 Part에 속한 모든 카운터, 세션 기록, 메모가 함께 삭제됩니다.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF717182),
                        letterSpacing: -0.15,
                        height: 1.43,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Buttons
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(partManageProvider.notifier)
                            .onEvent(DeletePart(part.id));
                        Navigator.pop(context);
                        onDeleted?.call();
                      },
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4183D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0x1A000000),
                            width: 0.694,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0A0A0A),
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
      },
    );
  }
}

/// 인라인으로 표시되는 새 파트 이름 입력 및 수정 폼
class _PartInputSection extends StatefulWidget {
  final int projectId;
  final String? initialText;
  final ValueChanged<String> onSave;
  final VoidCallback onCancel;

  const _PartInputSection({
    super.key,
    required this.projectId,
    this.initialText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_PartInputSection> createState() => _PartInputSectionState();
}

class _PartInputSectionState extends State<_PartInputSection> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    if (name == widget.initialText) {
      widget.onCancel();
      return;
    }

    // 중복 체크
    final exists = await appDb.isPartNameExists(
      projectId: widget.projectId,
      name: name,
    );
    if (exists) {
      if (mounted) {
        setState(() {
          _errorText = '이미 존재하는 파트 이름입니다.';
        });
      }
      return;
    }

    widget.onSave(name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x1A000000), width: 0.694),
        ),
        padding: const EdgeInsets.fromLTRB(12.694, 12.694, 12.694, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField Area
            Container(
              height: _errorText != null ? null : 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: _errorText != null ? null : Alignment.centerLeft,
              child: TextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: (_) => _handleSave(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0A0A0A),
                  letterSpacing: -0.31,
                ),
                decoration: InputDecoration(
                  hintText: '새 Part 이름',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF717182),
                    letterSpacing: -0.31,
                  ),
                  errorText: _errorText,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _handleSave,
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF637069),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.initialText == null ? '추가' : '저장',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0x1A000000),
                          width: 0.694,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0A0A0A),
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
              ? Border.all(color: const Color(0x1A000000), width: 0.694)
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
