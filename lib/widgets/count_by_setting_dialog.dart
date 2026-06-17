import 'package:flutter/material.dart';
import 'package:yarnie/widgets/number_input_group.dart';
import 'package:yarnie/l10n/app_localizations.dart';

class CountBySettingDialog extends StatefulWidget {
  final int initialValue;
  final Function(int) onSave;

  const CountBySettingDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<CountBySettingDialog> createState() => _CountBySettingDialogState();
}

class _CountBySettingDialogState extends State<CountBySettingDialog> {
  late TextEditingController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildQuickChip(int value) {
    final isSelected = _currentValue == value;
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    String label;
    if (locale == 'ko') {
      label = '$value단씩';
    } else if (locale == 'ja') {
      label = '$value段ずつ';
    } else {
      label = value == 1 ? '1 row' : '$value rows';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentValue = value;
          _controller.text = value.toString();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6FB96F)
              : colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6FB96F)
                : colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              l10n.setCountBy,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.44,
              ),
            ),
            
            const SizedBox(height: 20),

            // Quick Selection Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickChip(1),
                const SizedBox(width: 12),
                _buildQuickChip(2),
              ],
            ),

            const SizedBox(height: 20),

            // Input Group for custom value
            NumberInputGroup(
              label: l10n.countByValue,
              controller: _controller,
              textStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.07,
              ),
              onChanged: () {
                setState(() {
                  _currentValue = int.tryParse(_controller.text) ?? 1;
                });
              },
            ),

            const SizedBox(height: 24),

            // Footer
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Prevent saving 0 or negative values
                    final valueToSave = _currentValue <= 0 ? 1 : _currentValue;
                    widget.onSave(valueToSave);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6FB96F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.save,
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
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1), width: 0.5),
                    ),
                    alignment: Alignment.center,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
