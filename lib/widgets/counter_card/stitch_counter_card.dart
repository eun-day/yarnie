import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/counter_card/base_counter_card.dart';
import 'package:yarnie/widgets/counter_card/counter_settings_button.dart';
import 'package:yarnie/widgets/number_input_group.dart';

class StitchCounterCard extends StatelessWidget {
  final String label;
  final int currentValue;
  final int countBy;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int>? onCountByChanged;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StitchCounterCard({
    super.key,
    required this.label,
    required this.currentValue,
    this.countBy = 1,
    required this.onIncrement,
    required this.onDecrement,
    this.onCountByChanged,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCounterCard(
      label: label,
      progress: null, // 스티치 카운터는 프로그레스 바 없음
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Decrease Button
            GestureDetector(
              onTap: onDecrement,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.52),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.remove, size: 16, color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
            const SizedBox(width: 4),

            // Value Display
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$currentValue',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: 0.37,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.stitch,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Increase Button
            GestureDetector(
              onTap: onIncrement,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.add, size: 16, color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ),
      ),
      bottomToolbar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Count By Dropdown
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 120,
                maxWidth: 120,
              ),
              offset: const Offset(0, -10), // Adjust to appear above/below correctly
              color: Theme.of(context).colorScheme.surface,
              elevation: 4,
              shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
              ),
              onSelected: (value) {
                if (value == -1) {
                  _showCustomInput(context);
                } else {
                  onCountByChanged?.call(value);
                }
              },
              itemBuilder: (context) => [
                for (final n in [1, 2, 3, 4, 5, 10])
                  PopupMenuItem<int>(
                    value: n,
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: countBy == n ? const Color(0xFFF3F3F5) : null,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.increaseBy(n),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                const PopupMenuDivider(height: 1),
                PopupMenuItem<int>(
                  value: -1,
                  height: 32,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    height: 32,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.manualInput,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
              child: Container(
                height: 24,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '+$countBy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.keyboard_arrow_down, size: 14, color: Theme.of(context).colorScheme.onSurface),
                  ],
                ),
              ),
            ),
          ),
          
          // Settings Button
          CounterSettingsButton(
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }

  void _showCustomInput(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => const _CountByCustomDialog(),
    ).then((value) {
      if (value != null && value is int) {
        onCountByChanged?.call(value);
      }
    });
  }
}

class _CountByCustomDialog extends StatefulWidget {
  const _CountByCustomDialog();

  @override
  State<_CountByCustomDialog> createState() => _CountByCustomDialogState();
}

class _CountByCustomDialogState extends State<_CountByCustomDialog> {
  late TextEditingController _controller;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_validate);
  }

  @override
  void dispose() {
    _controller.removeListener(_validate);
    _controller.dispose();
    super.dispose();
  }

  void _validate() {
    final value = int.tryParse(_controller.text);
    final isValid = value != null && value > 0;
    if (_isValid != isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 360,
        padding: EdgeInsets.all(24),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              AppLocalizations.of(context)!.setIncreaseValue,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.44,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.setIncreaseValueDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -0.15,
              ),
            ),
            const SizedBox(height: 36),

            // Use NumberInputGroup
            NumberInputGroup(
              label: AppLocalizations.of(context)!.increaseValue,
              controller: _controller,
              hintText: AppLocalizations.of(context)!.increaseValueHint,
              min: 1,
              onChanged: _validate,
            ),
            
            const SizedBox(height: 36),

            // Footer Buttons
            GestureDetector(
              onTap: _isValid
                  ? () {
                      final value = int.parse(_controller.text);
                      Navigator.pop(context, value);
                    }
                  : null,
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: _isValid ? const Color(0xFF6FB96F) : const Color(0xFF6FB96F).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.confirm,
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
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.52),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
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
          ],
        ),
      ),
    );
  }
}
