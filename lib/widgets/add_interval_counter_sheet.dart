import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';

class AddIntervalCounterSheet extends ConsumerStatefulWidget {
  final int partId;
  final int initialStartRow;
  final SectionCounter? existingCounter;

  const AddIntervalCounterSheet({
    super.key,
    required this.partId,
    required this.initialStartRow,
    this.existingCounter,
  });

  @override
  ConsumerState<AddIntervalCounterSheet> createState() => _AddIntervalCounterSheetState();
}

class _AddIntervalCounterSheetState extends ConsumerState<AddIntervalCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _startRowController;
  late TextEditingController _intervalController;
  late TextEditingController _totalCountController;

  bool _isColorOptionsExpanded = false;
  final List<Color> _selectedPalette = [];

  bool get _isEditing => widget.existingCounter != null;

  List<Color> get _availableColors => [
    const Color(0xFFFFFFFF), const Color(0xFFFFFFF0), const Color(0xFFF5F5DC), const Color(0xFFFFFDD0), const Color(0xFFFFB6C1), const Color(0xFFFF7F50),
    const Color(0xFFDC143C), const Color(0xFF800020), const Color(0xFFFF8C00), const Color(0xFFFFD700), const Color(0xFF32CD32), const Color(0xFF228B22),
    const Color(0xFF98FF98), const Color(0xFF40E0D0), const Color(0xFF87CEEB), const Color(0xFF4169E1), const Color(0xFF000080), const Color(0xFFE6E6FA),
    const Color(0xFF9370DB), const Color(0xFF8B4513), Theme.of(context).colorScheme.primary, const Color(0xFF808080), const Color(0xFF36454F), const Color(0xFF000000),
  ];

  bool get _isValid {
    final startRow = int.tryParse(_startRowController.text);
    final interval = int.tryParse(_intervalController.text);
    final totalCount = int.tryParse(_totalCountController.text);
    return _labelController.text.isNotEmpty && 
           startRow != null && startRow > 0 && 
           interval != null && interval > 0 &&
           totalCount != null && totalCount > 0;
  }

  @override
  void initState() {
    super.initState();
    
    String label = AppLocalizations.of(context)!.intervalCounterLabel;
    String startRow = widget.initialStartRow.toString();
    String interval = '';
    String totalCount = '';

    if (_isEditing) {
      label = widget.existingCounter!.name;
      try {
        final spec = jsonDecode(widget.existingCounter!.specJson);
        startRow = spec['startRow']?.toString() ?? startRow;
        interval = spec['intervalRows']?.toString() ?? '';
        totalCount = spec['totalCount']?.toString() ?? '';
        
        // Load palette
        final paletteHex = spec['palette'] as List<dynamic>?;
        if (paletteHex != null) {
          for (final hex in paletteHex) {
            try {
              final color = Color(int.parse((hex as String).substring(1), radix: 16) + 0xFF000000);
              _selectedPalette.add(color);
            } catch (_) {}
          }
          if (_selectedPalette.isNotEmpty) {
            _isColorOptionsExpanded = true;
          }
        }
      } catch (_) {}
    }

    _labelController = TextEditingController(text: label);
    _startRowController = TextEditingController(text: startRow);
    _intervalController = TextEditingController(text: interval);
    _totalCountController = TextEditingController(text: totalCount);

    _labelController.addListener(_updateState);
    _startRowController.addListener(_updateState);
    _intervalController.addListener(_updateState);
    _totalCountController.addListener(_updateState);
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
    
    _labelController.dispose();
    _startRowController.dispose();
    _intervalController.dispose();
    _totalCountController.dispose();
    super.dispose();
  }

  void _toggleColor(Color color) {
    setState(() {
      if (_selectedPalette.contains(color)) {
        _selectedPalette.remove(color);
      } else {
        _selectedPalette.add(color);
      }
    });
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final name = _labelController.text.trim();
    final startRow = int.parse(_startRowController.text);
    final interval = int.parse(_intervalController.text);
    final totalCount = int.parse(_totalCountController.text);

    // Convert palette colors to HEX strings
    final paletteHex = _selectedPalette.map((c) => '#${c.value.toRadixString(16).substring(2).toUpperCase()}').toList();

    // Spec JSON Construction
    final spec = {
      'type': 'interval',
      'startRow': startRow,
      'intervalRows': interval,
      'totalCount': totalCount,
      'palette': paletteHex,
      'targetInfo': '매 ${interval}행마다 × $totalCount회',
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
                        _isEditing ? AppLocalizations.of(context)!.editIntervalCounter : AppLocalizations.of(context)!.addIntervalCounter,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.intervalCounterDescSimple,
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
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.intervalRows,
                        controller: _intervalController,
                        hintText: AppLocalizations.of(context)!.intervalHint,
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      NumberInputGroup(
                        label: AppLocalizations.of(context)!.totalTimes,
                        controller: _totalCountController,
                        hintText: AppLocalizations.of(context)!.timesHint,
                        helperText: AppLocalizations.of(context)!.intervalTimesHelper,
                        onChanged: _updateState,
                      ),
                      
                      const SizedBox(height: 24),

                      // Color Options Toggle
                      GestureDetector(
                        onTap: () => setState(() => _isColorOptionsExpanded = !_isColorOptionsExpanded),
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.colorOption,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                letterSpacing: -0.15,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isColorOptionsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),

                      if (_isColorOptionsExpanded) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.colorOptionDesc,
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildColorGrid(),
                      ],
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

  Widget _buildColorGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _availableColors.length,
      itemBuilder: (context, index) {
        final color = _availableColors[index];
        final isSelected = _selectedPalette.contains(color);
        final selectionIndex = _selectedPalette.indexOf(color);

        return GestureDetector(
          onTap: () => _toggleColor(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Color(0xFFE5E7EB),
                width: isSelected ? 2.5 : 1.9,
              ),
            ),
            alignment: Alignment.center,
            child: isSelected
                ? Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${selectionIndex + 1}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}