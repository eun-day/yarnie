import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/number_input_group.dart';

class CounterEditBottomSheet extends StatefulWidget {
  final int initialValue;
  final Function(int) onSave;

  const CounterEditBottomSheet({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  @override
  State<CounterEditBottomSheet> createState() => _CounterEditBottomSheetState();
}

class _CounterEditBottomSheetState extends State<CounterEditBottomSheet> {
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 0,
        right: 0,
        bottom: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.editMainCount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.31,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.editMainCountDesc,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberInputGroup(
                  label: AppLocalizations.of(context)!.currentCount,
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

                // Action Buttons
                Row(
                  children: [
                    // Reset Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onSave(1);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1), width: 0.5),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, size: 12, color: Theme.of(context).colorScheme.onSurface),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.resetToOne,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  letterSpacing: -0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Save Button
                    Expanded(
                      child: GestureDetector(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Handle keyboard overlap
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}