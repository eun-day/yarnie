import 'package:flutter/material.dart';
import 'package:yarnie/widgets/number_input_group.dart';
import 'package:yarnie/l10n/app_localizations.dart';

class TargetSettingDialog extends StatefulWidget {
  final int initialValue;
  final Function(int) onSave;

  const TargetSettingDialog({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<TargetSettingDialog> createState() => _TargetSettingDialogState();
}

class _TargetSettingDialogState extends State<TargetSettingDialog> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 360, // Approximate width to match design relative to screen
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.setTargetRow,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.setTargetRowDesc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Input Group
            NumberInputGroup(
              label: l10n.targetRow,
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
                    widget.onSave(_currentValue);
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
