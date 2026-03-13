import 'dart:convert';
import 'package:flutter/material.dart';
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

  static const List<Color> _availableColors = [
    Color(0xFFFFFFFF), Color(0xFFFFFFF0), Color(0xFFF5F5DC), Color(0xFFFFFDD0), Color(0xFFFFB6C1), Color(0xFFFF7F50),
    Color(0xFFDC143C), Color(0xFF800020), Color(0xFFFF8C00), Color(0xFFFFD700), Color(0xFF32CD32), Color(0xFF228B22),
    Color(0xFF98FF98), Color(0xFF40E0D0), Color(0xFF87CEEB), Color(0xFF4169E1), Color(0xFF000080), Color(0xFFE6E6FA),
    Color(0xFF9370DB), Color(0xFF8B4513), Theme.of(context).colorScheme.primary, Color(0xFF808080), Color(0xFF36454F), Color(0xFF000000),
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
    
    String label = '간격 카운터';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${_isEditing ? '수정' : '생성'} 실패: $e')));
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? '간격 카운터 수정' : '간격 카운터 추가',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '일정한 간격으로 작업을 반복할 때 사용하는 카운터입니다.',
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
                        label: '시작 행',
                        controller: _startRowController,
                        hintText: '19',
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      NumberInputGroup(
                        label: '간격 (행)',
                        controller: _intervalController,
                        hintText: '예: 2',
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      NumberInputGroup(
                        label: '총 횟수',
                        controller: _totalCountController,
                        hintText: '예: 10',
                        helperText: '간격과 총 횟수를 입력하세요.',
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
                              '배색 옵션',
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
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '배색 추적이 필요한 경우 사용할 색상을 순서대로 선택하세요',
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
                            _isEditing ? '저장' : '추가',
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
                            '취소',
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
          '라벨',
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
          '어떤 카운터인지 알아보기 쉽게 라벨을 입력해보세요',
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