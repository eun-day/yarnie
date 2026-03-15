import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';

class AddRangeCounterSheet extends ConsumerStatefulWidget {
  final int partId;
  final int initialStartRow; // Usually current MainCounter value
  final SectionCounter? existingCounter;

  const AddRangeCounterSheet({
    super.key,
    required this.partId,
    required this.initialStartRow,
    this.existingCounter,
  });

  @override
  ConsumerState<AddRangeCounterSheet> createState() =>
      _AddRangeCounterSheetState();
}

class _AddRangeCounterSheetState extends ConsumerState<AddRangeCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _startRowController;
  late TextEditingController _totalRowsController;

  bool get _isEditing => widget.existingCounter != null;

  bool get _isValid {
    final startRow = int.tryParse(_startRowController.text);
    final totalRows = int.tryParse(_totalRowsController.text);
    return _labelController.text.isNotEmpty &&
        startRow != null &&
        startRow > 0 &&
        totalRows != null &&
        totalRows > 0;
  }

  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  void _initializeControllers() {
    if (_initialized) return;

    String label = AppLocalizations.of(context)!.rangeCounterLabel;
    String startRow = widget.initialStartRow.toString();
    String totalRows = '';

    if (_isEditing) {
      label = widget.existingCounter!.name;
      try {
        final spec = jsonDecode(widget.existingCounter!.specJson);
        startRow = spec['startRow']?.toString() ?? startRow;
        totalRows = spec['rowsTotal']?.toString() ?? '';
      } catch (_) {}
    }

    _labelController = TextEditingController(text: label);
    _startRowController = TextEditingController(text: startRow);
    _totalRowsController = TextEditingController(text: totalRows);

    _labelController.addListener(_updateState);
    _startRowController.addListener(_updateState);
    _totalRowsController.addListener(_updateState);

    _initialized = true;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    if (_initialized) {
      _labelController.removeListener(_updateState);
      _startRowController.removeListener(_updateState);
      _totalRowsController.removeListener(_updateState);

      _labelController.dispose();
      _startRowController.dispose();
      _totalRowsController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final name = _labelController.text.trim();
    final startRow = int.parse(_startRowController.text);
    final totalRows = int.parse(_totalRowsController.text);
    final endRow = startRow + totalRows - 1;

    // Spec JSON Construction
    final spec = {
      'type': 'range',
      'startRow': startRow,
      'endRow': endRow,
      'rowsTotal': totalRows, // Renamed from totalRows to match DB
      'targetInfo': '$startRow~$endRow${AppLocalizations.of(context)!.stitch}',
    };

    try {
      if (_isEditing) {
        await appDb.updateSectionCounter(
          counterId: widget.existingCounter!.id,
          name: name,
          specJson: jsonEncode(spec),
        );
      } else {
        await appDb.createSectionCounter(
          partId: widget.partId,
          name: name,
          specJson: jsonEncode(spec),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        final message = _isEditing
            ? AppLocalizations.of(context)!.restoreFailed(e.toString())
            : AppLocalizations.of(context)!.deleteFailed(e.toString());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllers();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 16, bottom: 24),
                    width: 100,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing
                            ? AppLocalizations.of(context)!.editRangeCounter
                            : AppLocalizations.of(context)!.addRangeCounter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.rangeCounterDescSimple,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Label Field
                      _buildLabelField(),
                      const SizedBox(height: 16),

                      // Start Row Field
                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.startRow,
                        controller: _startRowController,
                        hintText: '19',
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      // Total Rows Field
                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.totalRows,
                        controller: _totalRowsController,
                        hintText: AppLocalizations.of(context)!.rowsHint,
                        helperText: AppLocalizations.of(context)!.rowsHelper,
                        onChanged: _updateState,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Footer Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _isValid ? _handleSave : null,
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isValid
                                ? Theme.of(context).colorScheme.primary
                                : Color(0xFF6FB96F).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isEditing
                                ? AppLocalizations.of(context)!.save
                                : AppLocalizations.of(context)!.add,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.surface,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 0.64,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _labelController,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.labelHint,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
