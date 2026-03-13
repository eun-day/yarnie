import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';

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
  ConsumerState<AddShapingCounterSheet> createState() => _AddShapingCounterSheetState();
}

class _AddShapingCounterSheetState extends ConsumerState<AddShapingCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _startRowController;
  late TextEditingController _intervalController;
  late TextEditingController _totalCountController;
  late TextEditingController _amountController;

  bool get _isEditing => widget.existingCounter != null;

  bool get _isValid {
    final startRow = int.tryParse(_startRowController.text);
    final interval = int.tryParse(_intervalController.text);
    final totalCount = int.tryParse(_totalCountController.text);
    final amount = int.tryParse(_amountController.text);
    
    return _labelController.text.isNotEmpty && 
           startRow != null && startRow > 0 && 
           interval != null && interval > 0 &&
           totalCount != null && totalCount > 0 &&
           amount != null && amount != 0; // 0은 의미 없음
  }

  @override
  void initState() {
    super.initState();
    
    String label = AppLocalizations.of(context)!.shapingCounterLabel;
    String startRow = widget.initialStartRow.toString();
    String interval = '';
    String totalCount = '';
    String amount = '';

    if (_isEditing) {
      label = widget.existingCounter!.name;
      try {
        final spec = jsonDecode(widget.existingCounter!.specJson);
        startRow = spec['startRow']?.toString() ?? startRow;
        interval = spec['intervalRows']?.toString() ?? '';
        totalCount = spec['totalCount']?.toString() ?? '';
        amount = spec['amount']?.toString() ?? '';
      } catch (_) {}
    }

    _labelController = TextEditingController(text: label);
    _startRowController = TextEditingController(text: startRow);
    _intervalController = TextEditingController(text: interval);
    _totalCountController = TextEditingController(text: totalCount);
    _amountController = TextEditingController(text: amount);

    _labelController.addListener(_updateState);
    _startRowController.addListener(_updateState);
    _intervalController.addListener(_updateState);
    _totalCountController.addListener(_updateState);
    _amountController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _labelController.removeListener(_updateState);
    _startRowController.removeListener(_updateState);
    _intervalController.removeListener(_updateState);
    _totalCountController.removeListener(_updateState);
    _amountController.removeListener(_updateState);
    
    _labelController.dispose();
    _startRowController.dispose();
    _intervalController.dispose();
    _totalCountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final name = _labelController.text.trim();
    final startRow = int.parse(_startRowController.text);
    final interval = int.parse(_intervalController.text);
    final totalCount = int.parse(_totalCountController.text);
    final amount = int.parse(_amountController.text);

    // Spec JSON Construction
    final spec = {
      'type': 'shaping',
      'startRow': startRow,
      'intervalRows': interval,
      'totalCount': totalCount,
      'amount': amount,
      'targetInfo': '매 ${interval}행마다 ${amount > 0 ? "+$amount" : amount}${AppLocalizations.of(context)!.stitch} × $totalCount회',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

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
                        _isEditing ? AppLocalizations.of(context)!.editShapingCounter : AppLocalizations.of(context)!.addShapingCounter,
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
                      const SizedBox(height: 16),

                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.stitchChange,
                        controller: _amountController,
                        hintText: AppLocalizations.of(context)!.stitchChangeHint,
                        helperText: AppLocalizations.of(context)!.stitchChangeHelper,
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
                            color: _isValid ? Theme.of(context).colorScheme.primary : Color(0xFF6FB96F).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isEditing ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.add,
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
          AppLocalizations.of(context)!.labelHint,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}