import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputGroup extends StatelessWidget {
  final String? label;
  final String? helperText;
  final TextEditingController controller;
  final String? hintText;
  final bool isReadOnly;
  final VoidCallback? onChanged;
  final TextStyle? textStyle;
  final int min;
  final int? max;
  final bool skipZero;

  const NumberInputGroup({
    super.key,
    this.label,
    this.helperText,
    required this.controller,
    this.hintText,
    this.isReadOnly = false,
    this.onChanged,
    this.textStyle,
    this.min = 1,
    this.max,
    this.skipZero = false,
  });

  void _increment() {
    final current = int.tryParse(controller.text);
    int next;
    if (current == null) {
      next = 1;
      if (next < min) next = min;
    } else {
      next = current + 1;
      if (skipZero && next == 0) {
        next = 1;
      }
    }

    if (max != null && next > max!) return;
    controller.text = next.toString();
    onChanged?.call();
  }

  void _decrement() {
    final current = int.tryParse(controller.text);
    int next;
    if (current == null) {
      next = -1;
      if (next < min) next = min;
    } else {
      next = current - 1;
      if (skipZero && next == 0) {
        next = -1;
      }
    }

    if (next < min) return;
    controller.text = next.toString();
    onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            _StepButton(
              icon: Icons.remove,
              onTap: _decrement,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  readOnly: isReadOnly,
                  style: textStyle ?? TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                  ],
                  onChanged: (_) {
                    onChanged?.call();
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            _StepButton(
              icon: Icons.add,
              onTap: _increment,
            ),
          ],
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}

class _StepButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) async {
        widget.onTap();
        // Delay visual feedback reset slightly so the user sees the flash
        await Future.delayed(const Duration(milliseconds: 150));
        if (mounted) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _isPressed ? Color(0xFFC0D2A4) : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: _isPressed ? Color(0xFFC0D2A4) : Theme.of(context).colorScheme.outline,
            width: 0.64
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.icon,
          size: 16,
          color: _isPressed ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
