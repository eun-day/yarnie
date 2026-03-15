import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';
import 'package:yarnie/l10n/app_localizations.dart';

class AddLengthCounterSheet extends ConsumerStatefulWidget {
  final int partId;
  final int initialStartRow;
  final SectionCounter? existingCounter;

  const AddLengthCounterSheet({
    super.key,
    required this.partId,
    required this.initialStartRow,
    this.existingCounter,
  });

  @override
  ConsumerState<AddLengthCounterSheet> createState() => _AddLengthCounterSheetState();
}

class _AddLengthCounterSheetState extends ConsumerState<AddLengthCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _startRowController;
  late TextEditingController _targetLengthController;
  late TextEditingController _rowHeightController;
  final ScrollController _scrollController = ScrollController();

  bool get _isEditing => widget.existingCounter != null;

  int? get _estimatedRows {
    final targetLength = double.tryParse(_targetLengthController.text);
    final rowHeight = double.tryParse(_rowHeightController.text);
    // targetLength가 rowHeight보다 커야 의미가 있음
    if (targetLength == null || rowHeight == null || rowHeight <= 0 || targetLength <= rowHeight) return null;
    return (targetLength / rowHeight).ceil();
  }

  String? get _rowHeightError {
    final targetLength = double.tryParse(_targetLengthController.text);
    final rowHeight = double.tryParse(_rowHeightController.text);
    if (targetLength != null && rowHeight != null && targetLength <= rowHeight) {
      return AppLocalizations.of(context)!.rowHeightError;
    }
    return null;
  }

  bool get _isValid {
    final startRow = int.tryParse(_startRowController.text);
    final rows = _estimatedRows;
    
    return _labelController.text.isNotEmpty && 
           startRow != null && startRow > 0 && 
           rows != null && rows > 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if label was default, update it if locale changed (only on first init ideally)
  }

  @override
  void initState() {
    super.initState();
    
    // We can't use AppLocalizations here as context is not fully ready for it yet in some cases,
    // but in initState it's usually okay if it's already in the tree.
    // However, to be safe, we might want to handle default label carefully.
  }

  bool _initialized = false;

  void _initializeControllers() {
    if (_initialized) return;
    final l10n = AppLocalizations.of(context)!;

    String label = l10n.lengthMeasurement;
    String startRow = widget.initialStartRow.toString();
    String targetLength = '';
    String rowHeight = '';

    if (_isEditing) {
      label = widget.existingCounter!.name;
      try {
        final spec = jsonDecode(widget.existingCounter!.specJson);
        startRow = spec['startRow']?.toString() ?? startRow;
        targetLength = spec['targetLength']?.toString() ?? '';
        rowHeight = spec['rowHeight']?.toString() ?? '';
      } catch (_) {}
    }

    _labelController = TextEditingController(text: label);
    _startRowController = TextEditingController(text: startRow);
    _targetLengthController = TextEditingController(text: targetLength);
    _rowHeightController = TextEditingController(text: rowHeight);

    _labelController.addListener(_updateState);
    _startRowController.addListener(_updateState);
    _targetLengthController.addListener(_onInputChanged);
    _rowHeightController.addListener(_onInputChanged);
    _initialized = true;
  }

  void _onInputChanged() {
    _updateState();
    if (_estimatedRows != null) {
      // Scroll to bottom after state update to show result
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    if (_initialized) {
      _labelController.removeListener(_updateState);
      _startRowController.removeListener(_updateState);
      _targetLengthController.removeListener(_onInputChanged);
      _rowHeightController.removeListener(_onInputChanged);

      _labelController.dispose();
      _startRowController.dispose();
      _targetLengthController.dispose();
      _rowHeightController.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;
    final l10n = AppLocalizations.of(context)!;

    final name = _labelController.text.trim();
    final startRow = int.parse(_startRowController.text);
    final targetLength = double.parse(_targetLengthController.text);
    final rowHeight = double.parse(_rowHeightController.text);
    final totalRows = _estimatedRows!;

    // Convert back to gauge for storage
    final gauge = 10 / rowHeight;

    // Spec JSON Construction
    final spec = {
      'type': 'length',
      'startRow': startRow,
      'rowsTotal': totalRows, // Important for DB
      'mode': 'target',
      'units': 'cm',
      'targetLength': targetLength,
      'gaugeRowsPer10cm': gauge,
      'rowHeight': rowHeight,
      'targetInfo': l10n.targetInfoLength(targetLength.toString()),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorOccurred(e.toString()))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllers();
    final l10n = AppLocalizations.of(context)!;
    final estimatedRows = _estimatedRows;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
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
                    margin: const EdgeInsets.only(top: 16, bottom: 24),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? l10n.editLengthCounterTitle : l10n.addLengthCounterTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.lengthCounterDesc,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildLabelField(),
                      const SizedBox(height: 16),
                      
                      NumberInputGroup(
                        label: l10n.startStitch,
                        controller: _startRowController,
                        hintText: '19',
                        min: 1,
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      _buildDecimalInputGroup(
                        label: l10n.targetLengthCm,
                        controller: _targetLengthController,
                        hintText: '예: 25.0',
                        min: 1.0,
                      ),
                      const SizedBox(height: 16),

                      // Row Height (Decimal allowed)
                      _buildDecimalInputGroup(
                        label: l10n.rowHeightCm,
                        controller: _rowHeightController,
                        hintText: '예: 0.33',
                        min: 0.1,
                        helperText: _rowHeightError != null 
                            ? _rowHeightError! 
                            : l10n.rowHeightDesc,
                        helperTextColor: _rowHeightError != null ? Colors.red : Theme.of(context).colorScheme.onSurfaceVariant,
                        action: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.gaugeInputComingSoon)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.goToGaugeInput,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (estimatedRows != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.expectedRows,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.estimatedRowsDisplay(estimatedRows.toString()),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: 0.07,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Footer Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _isValid ? _handleSave : null,
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isValid ? Theme.of(context).colorScheme.primary : const Color(0xFF6FB96F).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isEditing ? l10n.save : l10n.add,
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
                            border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.64),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.cancel,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.label,
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _labelController,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.labelHint,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  // Helper for Decimal inputs (since NumberInputGroup is currently Integer only)
  // Re-implementing a simple version here or we could modify NumberInputGroup to support double.
  // Given NumberInputGroup uses int.tryParse, let's make a local one or modify it.
  // For safety and speed, I'll implement a local widget here that looks like NumberInputGroup but handles doubles.
  Widget _buildDecimalInputGroup({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required double min,
    String? helperText,
    Color? helperTextColor,
    Widget? action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.15,
              ),
            ),
            if (action != null) action,
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _StepButton(
              icon: Icons.remove,
              onTap: () {
                final current = double.tryParse(controller.text) ?? 0.0;
                final next = (current - 0.1).clamp(min, 9999.0); // Use min here
                controller.text = double.parse(next.toStringAsFixed(2)).toString(); 
                _onInputChanged();
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (_) => _onInputChanged(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _StepButton(
              icon: Icons.add,
              onTap: () {
                final current = double.tryParse(controller.text) ?? 0.0;
                final next = current + 0.1;
                controller.text = double.parse(next.toStringAsFixed(2)).toString();
                _onInputChanged();
              },
            ),
          ],
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText,
            style: TextStyle(
              fontSize: 12, 
              color: helperTextColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _StepButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) async {
        widget.onTap();
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFFC0D2A4) : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: _isPressed ? const Color(0xFFC0D2A4) : Theme.of(context).colorScheme.outline,
            width: 0.64
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.icon,
          size: 16,
          color: _isPressed ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
