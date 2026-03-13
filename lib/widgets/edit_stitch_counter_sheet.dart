import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';

class EditStitchCounterSheet extends ConsumerStatefulWidget {
  final StitchCounter counter;

  const EditStitchCounterSheet({
    super.key,
    required this.counter,
  });

  @override
  ConsumerState<EditStitchCounterSheet> createState() => _EditStitchCounterSheetState();
}

class _EditStitchCounterSheetState extends ConsumerState<EditStitchCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _valueController;
  late TextEditingController _countByController;

  bool get _isValid {
    final value = int.tryParse(_valueController.text);
    final countBy = int.tryParse(_countByController.text);
    return _labelController.text.isNotEmpty &&
           value != null && value >= 0 &&
           countBy != null && countBy > 0;
  }

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.counter.name);
    _valueController = TextEditingController(text: widget.counter.currentValue.toString());
    _countByController = TextEditingController(text: widget.counter.countBy.toString());

    _labelController.addListener(_updateState);
    _valueController.addListener(_updateState);
    _countByController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _labelController.removeListener(_updateState);
    _valueController.removeListener(_updateState);
    _countByController.removeListener(_updateState);
    
    _labelController.dispose();
    _valueController.dispose();
    _countByController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final name = _labelController.text.trim();
    final value = int.parse(_valueController.text);
    final countBy = int.parse(_countByController.text);

    try {
      await appDb.updateStitchCounter(
        counterId: widget.counter.id,
        name: name,
        currentValue: value,
        countBy: countBy,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.restoreFailed(e.toString()))));
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
                        AppLocalizations.of(context)!.editStitchCounter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.editCounterInfo,
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
                      
                      // Current Value Field
                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.currentValue,
                        controller: _valueController,
                        hintText: '0',
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      // Count By Field
                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.countUnit,
                        controller: _countByController,
                        hintText: '1',
                        min: 1,
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
                            AppLocalizations.of(context)!.save,
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
      ],
    );
  }
}
