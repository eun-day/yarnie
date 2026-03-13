import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/number_input_group.dart';

class AddRepeatCounterSheet extends ConsumerStatefulWidget {
  final int partId;
  final int initialStartRow;
  final SectionCounter? existingCounter;

  const AddRepeatCounterSheet({
    super.key,
    required this.partId,
    required this.initialStartRow,
    this.existingCounter,
  });

  @override
  ConsumerState<AddRepeatCounterSheet> createState() => _AddRepeatCounterSheetState();
}

class _AddRepeatCounterSheetState extends ConsumerState<AddRepeatCounterSheet> {
  late TextEditingController _labelController;
  late TextEditingController _startRowController;
  late TextEditingController _repeatUnitController;
  late TextEditingController _repeatCountController;

  bool get _isEditing => widget.existingCounter != null;

  bool get _isValid {
    final startRow = int.tryParse(_startRowController.text);
    final repeatUnit = int.tryParse(_repeatUnitController.text);
    final repeatCount = int.tryParse(_repeatCountController.text);
    return _labelController.text.isNotEmpty && 
           startRow != null && startRow > 0 && 
           repeatUnit != null && repeatUnit > 0 &&
           repeatCount != null && repeatCount > 0;
  }

  @override
  void initState() {
    super.initState();
    
    String label = '반복 카운터';
    String startRow = widget.initialStartRow.toString();
    String repeatUnit = '';
    String repeatCount = '';

    if (_isEditing) {
      label = widget.existingCounter!.name;
      try {
        final spec = jsonDecode(widget.existingCounter!.specJson);
        startRow = spec['startRow']?.toString() ?? startRow;
        repeatUnit = spec['rowsPerRepeat']?.toString() ?? '';
        repeatCount = spec['repeatCount']?.toString() ?? '';
      } catch (_) {}
    }

    _labelController = TextEditingController(text: label);
    _startRowController = TextEditingController(text: startRow);
    _repeatUnitController = TextEditingController(text: repeatUnit);
    _repeatCountController = TextEditingController(text: repeatCount);

    _labelController.addListener(_updateState);
    _startRowController.addListener(_updateState);
    _repeatUnitController.addListener(_updateState);
    _repeatCountController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    _labelController.removeListener(_updateState);
    _startRowController.removeListener(_updateState);
    _repeatUnitController.removeListener(_updateState);
    _repeatCountController.removeListener(_updateState);
    
    _labelController.dispose();
    _startRowController.dispose();
    _repeatUnitController.dispose();
    _repeatCountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final name = _labelController.text.trim();
    final startRow = int.parse(_startRowController.text);
    final repeatUnit = int.parse(_repeatUnitController.text);
    final repeatCount = int.parse(_repeatCountController.text);

    // Spec JSON Construction (Matching planning document for Repeat Type)
    // { "type": "repeat", "start_row": 60, "rows_per_repeat": 4, "repeat_count": 5, "label": "차트 A" }
    final spec = {
      'type': 'repeat',
      'startRow': startRow,
      'rowsPerRepeat': repeatUnit,
      'repeatCount': repeatCount,
      'targetInfo': '매 ${repeatUnit}행 × ${repeatCount}회', // Display info
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
                        _isEditing ? '반복 카운터 수정' : '반복 카운터 추가',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.31,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '특정 패턴을 반복할 때 사용하는 카운터입니다.',
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
                        label: '시작 행',
                        controller: _startRowController,
                        hintText: '19',
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      // Repeat Unit Field
                      NumberInputGroup(
                        label: '반복 단위 (행)',
                        controller: _repeatUnitController,
                        hintText: '예: 4',
                        onChanged: _updateState,
                      ),
                      const SizedBox(height: 16),

                      // Repeat Count Field
                      NumberInputGroup(
                        label: '반복 횟수',
                        controller: _repeatCountController,
                        hintText: '예: 10',
                        helperText: '패턴의 반복 단위와 횟수를 입력하세요.',
                        onChanged: _updateState,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Footer Buttons (Matching Range Counter design)
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
          height: 36, // Using same height as AddRangeCounterSheet
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _labelController,
            style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface), // Adjusted to match design
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
}