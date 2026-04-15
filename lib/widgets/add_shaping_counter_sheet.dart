import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';

enum _ShapingMode { pattern, direct }

class AddShapingCounterSheet extends ConsumerStatefulWidget {
  final int partId;
  final int initialStartRow;
  final SectionCounter? existingCounter;

  const AddShapingCounterSheet({
    super.key,
    required this.partId,
    required this.initialStartRow,
    this.existingCounter,
  });

  @override
  ConsumerState<AddShapingCounterSheet> createState() =>
      _AddShapingCounterSheetState();
}

class _AddShapingCounterSheetState
    extends ConsumerState<AddShapingCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _startRowController;
  late TextEditingController _intervalController;
  late TextEditingController _totalCountController;
  late TextEditingController _amountController;
  // Direct mode controller
  late TextEditingController _rowsDirectController;

  _ShapingMode _mode = _ShapingMode.pattern;

  bool get _isEditing => widget.existingCounter != null;

  bool get _isValid {
    if (_labelController.text.isEmpty) return false;

    final amount = int.tryParse(_amountController.text);
    if (amount == null || amount == 0) return false;

    if (_mode == _ShapingMode.pattern) {
      final startRow = int.tryParse(_startRowController.text);
      final interval = int.tryParse(_intervalController.text);
      final totalCount = int.tryParse(_totalCountController.text);

      return startRow != null &&
          startRow > 0 &&
          interval != null &&
          interval > 0 &&
          totalCount != null &&
          totalCount > 0;
    } else {
      // Direct mode validation
      final rows = _parseDirectRows();
      return rows.isNotEmpty;
    }
  }

  List<int> _parseDirectRows() {
    final text = _rowsDirectController.text.trim();
    if (text.isEmpty) return [];

    final parts = text.split(RegExp(r'[,，\s]+'));
    final rows = <int>[];
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final val = int.tryParse(trimmed);
      if (val == null || val <= 0) return []; // invalid
      rows.add(val);
    }

    // Sort and deduplicate
    rows.sort();
    final unique = rows.toSet().toList();
    return unique;
  }

  @override
  void initState() {
    super.initState();
  }

  bool _initialized = false;

  void _initializeControllers() {
    if (_initialized) return;

    String label = AppLocalizations.of(context)!.shapingCounterLabel;
    String startRow = widget.initialStartRow.toString();
    String interval = '';
    String totalCount = '';
    String amount = '';
    String rowsDirect = '${widget.initialStartRow}, ';
    _ShapingMode initialMode = _ShapingMode.pattern;

    if (_isEditing) {
      label = widget.existingCounter!.name;
      try {
        final spec = jsonDecode(widget.existingCounter!.specJson);
        amount = spec['amount']?.toString() ?? '';

        final specMode = spec['mode']?.toString();
        if (specMode == 'direct') {
          initialMode = _ShapingMode.direct;
          final List<dynamic> rows = spec['rows'] ?? [];
          rowsDirect = rows.join(', ');
        } else {
          startRow = spec['startRow']?.toString() ?? startRow;
          interval = spec['intervalRows']?.toString() ?? '';
          totalCount = spec['totalCount']?.toString() ?? '';
        }
      } catch (_) {}
    }

    _mode = initialMode;
    _labelController = TextEditingController(text: label);
    _startRowController = TextEditingController(text: startRow);
    _intervalController = TextEditingController(text: interval);
    _totalCountController = TextEditingController(text: totalCount);
    _amountController = TextEditingController(text: amount);
    _rowsDirectController = TextEditingController(text: rowsDirect);

    _labelController.addListener(_updateState);
    _startRowController.addListener(_updateState);
    _intervalController.addListener(_updateState);
    _totalCountController.addListener(_updateState);
    _amountController.addListener(_updateState);
    _rowsDirectController.addListener(_updateState);

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
      _intervalController.removeListener(_updateState);
      _totalCountController.removeListener(_updateState);
      _amountController.removeListener(_updateState);
      _rowsDirectController.removeListener(_updateState);

      _labelController.dispose();
      _startRowController.dispose();
      _intervalController.dispose();
      _totalCountController.dispose();
      _amountController.dispose();
      _rowsDirectController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final name = _labelController.text.trim();
    final amount = int.parse(_amountController.text);

    Map<String, dynamic> spec;

    if (_mode == _ShapingMode.pattern) {
      final startRow = int.parse(_startRowController.text);
      final interval = int.parse(_intervalController.text);
      final totalCount = int.parse(_totalCountController.text);

      spec = {
        'type': 'shaping',
        'mode': 'pattern',
        'startRow': startRow,
        'intervalRows': interval,
        'totalCount': totalCount,
        'amount': amount,
        'targetInfo':
            '매 ${interval}행마다 ${amount > 0 ? "+$amount" : amount}${AppLocalizations.of(context)!.stitch} × $totalCount회',
      };
    } else {
      // Direct mode
      final rows = _parseDirectRows();
      spec = {
        'type': 'shaping',
        'mode': 'direct',
        'startRow': rows.first,
        'rows': rows,
        'amount': amount,
        'totalCount': rows.length,
        'targetInfo':
            '${rows.join(", ")}행에서 ${amount > 0 ? "+$amount" : amount}${AppLocalizations.of(context)!.stitch}',
      };
    }

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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing
                            ? AppLocalizations.of(context)!.editShapingCounter
                            : AppLocalizations.of(context)!.addShapingCounter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.shapingCounterDescSimple,
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
                      _buildLabelField(),
                      const SizedBox(height: 16),
                      _buildModeSegment(),
                      const SizedBox(height: 16),

                      if (_mode == _ShapingMode.pattern) ...[
                        // Pattern mode fields
                        NumberInputGroup(
                          label: AppLocalizations.of(context)!.startRow,
                          controller: _startRowController,
                          hintText: '19',
                          min: 1,
                          onChanged: _updateState,
                        ),
                        const SizedBox(height: 16),

                        NumberInputGroup(
                          label: AppLocalizations.of(context)!.intervalRows,
                          controller: _intervalController,
                          hintText: AppLocalizations.of(context)!.intervalHint,
                          min: 1,
                          onChanged: _updateState,
                        ),
                        const SizedBox(height: 16),

                        NumberInputGroup(
                          label: AppLocalizations.of(context)!.totalTimes,
                          controller: _totalCountController,
                          hintText: AppLocalizations.of(context)!.timesHint,
                          min: 1,
                          onChanged: _updateState,
                        ),
                        if (_buildPatternPreview() != null) ...[
                          const SizedBox(height: 6),
                          _buildPatternPreview()!,
                        ],
                        const SizedBox(height: 16),
                      ] else ...[
                        // Direct mode fields
                        _buildDirectRowsField(),
                        const SizedBox(height: 16),
                      ],

                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.stitchChange,
                        controller: _amountController,
                        hintText: AppLocalizations.of(
                          context,
                        )!.stitchChangeHint,
                        helperText: AppLocalizations.of(
                          context,
                        )!.stitchChangeHelper,
                        min: -999,
                        skipZero: true,
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

  Widget _buildModeSegment() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildSegmentButton(
            label: l10n.shapingModePattern,
            isSelected: _mode == _ShapingMode.pattern,
            onTap: () => setState(() => _mode = _ShapingMode.pattern),
          ),
          _buildSegmentButton(
            label: l10n.shapingModeDirect,
            isSelected: _mode == _ShapingMode.direct,
            onTap: () => setState(() => _mode = _ShapingMode.direct),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: -0.15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectRowsField() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.shapingRowsLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _rowsDirectController,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              hintText: l10n.shapingRowsHint,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.shapingRowsHelper,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget? _buildPatternPreview() {
    final start = int.tryParse(_startRowController.text);
    final interval = int.tryParse(_intervalController.text);
    final count = int.tryParse(_totalCountController.text);

    if (start == null || interval == null || count == null || count <= 0) {
      return null;
    }

    final limit = count > 10 ? 10 : count;
    final List<int> rows = [];
    for (int i = 0; i < limit; i++) {
      rows.add(start + (i * interval));
    }

    String previewStr = rows.join(', ');
    if (count > limit) {
      previewStr += ' ...';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '${AppLocalizations.of(context)!.preview}: $previewStr',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -0.15,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

