import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/common/time_helper.dart';

class PartMemoSheet extends StatefulWidget {
  final int partId;
  final String partName;

  const PartMemoSheet({
    super.key,
    required this.partId,
    required this.partName,
  });

  @override
  State<PartMemoSheet> createState() => _PartMemoSheetState();
}

class _PartMemoSheetState extends State<PartMemoSheet> {
  final TextEditingController _textController = TextEditingController();
  bool _isInputValid = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _textController.removeListener(_validateInput);
    _textController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final isValid = _textController.text.trim().isNotEmpty;
    if (_isInputValid != isValid) {
      setState(() {
        _isInputValid = isValid;
      });
    }
  }

  Future<void> _addMemo() async {
    final content = _textController.text.trim();
    if (content.isEmpty) return;

    await appDb.createPartNote(
      partId: widget.partId,
      content: content,
    );
    _textController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                margin: EdgeInsets.only(top: 16, bottom: 8),
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.partMemo(widget.partName),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.31,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.partMemoDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),

            // Input Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.newMemoHint,
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _isInputValid ? _addMemo : null,
                    child: Container(
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: _isInputValid ? 1.0 : 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 16, color: Theme.of(context).colorScheme.surface),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context)!.addMemo,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.surface,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Memo List Section
            Flexible(
              child: StreamBuilder<List<PartNote>>(
                stream: appDb.watchPartNotes(widget.partId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final notes = snapshot.data!;
                  if (notes.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.noMemos,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return _MemoCard(note: note);
                    },
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

class _MemoCard extends StatelessWidget {
  final PartNote note;

  const _MemoCard({required this.note});

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MemoActionSheet(note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showActionSheet(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.64),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.content,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (note.isPinned)
                    Icon(
                      Icons.push_pin,
                      size: 16,
                      color: Color(0xFFD4183D),
                    ),
                ],
              ),
            ),
            Container(
              height: 0.64,
              color: Theme.of(context).colorScheme.outline,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                mdHm(note.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoActionSheet extends StatelessWidget {
  final PartNote note;

  const _MemoActionSheet({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Menu List
              _ActionButton(
                label: note.isPinned ? AppLocalizations.of(context)!.unpin : AppLocalizations.of(context)!.pin,
                icon: Icons.push_pin_outlined,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.surface,
                iconColor: Theme.of(context).colorScheme.surface,
                onTap: () {
                  appDb.togglePartNotePin(note.id);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
              _ActionButton(
                label: AppLocalizations.of(context)!.edit,
                icon: Icons.edit_outlined,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: Theme.of(context).colorScheme.onSurface,
                iconColor: Theme.of(context).colorScheme.onSurface,
                showBorder: true,
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context);
                },
              ),
              const SizedBox(height: 8),
              _ActionButton(
                label: AppLocalizations.of(context)!.delete,
                icon: Icons.delete_outline,
                backgroundColor: Theme.of(context).colorScheme.surface,
                textColor: const Color(0xFFD4183D),
                iconColor: const Color(0xFFD4183D),
                showBorder: true,
                onTap: () {
                  appDb.deletePartNote(note.id);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: note.content);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  width: 100,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.editMemo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 120,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: controller,
                        maxLines: null,
                        autofocus: true,
                        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(color: Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final newContent = controller.text.trim();
                              if (newContent.isNotEmpty) {
                                appDb.updatePartNote(
                                  noteId: note.id,
                                  content: newContent,
                                );
                              }
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.save,
                                style: TextStyle(color: Theme.of(context).colorScheme.surface),
                              ),
                            ),
                          ),
                        ),
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
          border: showBorder ? Border.all(color: Theme.of(context).colorScheme.outline, width: 0.694) : null,
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
