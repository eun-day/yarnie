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
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0A0A0A),
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
                  keyboardType: const TextInputType.numberWithOptions(signed: true),
                  readOnly: isReadOnly,
                  style: textStyle ?? const TextStyle(fontSize: 16, color: Color(0xFF0A0A0A)),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Color(0xFF717182)),
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
            style: const TextStyle(fontSize: 12, color: Color(0xFF717182)),
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
          color: _isPressed ? const Color(0xFFC0D2A4) : Colors.white,
          border: Border.all(
            color: _isPressed ? const Color(0xFFC0D2A4) : const Color(0x1A000000), 
            width: 0.64
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.icon,
          size: 16,
          color: _isPressed ? Colors.white : const Color(0xFF0A0A0A),
        ),
      ),
    );
  }
}
