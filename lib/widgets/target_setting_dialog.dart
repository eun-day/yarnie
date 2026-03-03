import 'package:flutter/material.dart';
import 'package:yarnie/widgets/number_input_group.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 360, // Approximate width to match design relative to screen
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
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
              children: const [
                Text(
                  '목표 단수 설정',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A0A0A),
                    letterSpacing: -0.44,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '완료하고자 하는 총 단수를 입력하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF717182),
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // Input Group
            NumberInputGroup(
              label: '목표 단수',
              controller: _controller,
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Color(0xFF0A0A0A),
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
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.1), width: 0.5),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0A0A0A),
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

// Reused from CounterEditBottomSheet pattern
class _StepButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isPressed ? const Color(0xFFC0D2A4) : const Color.fromRGBO(0, 0, 0, 0.1),
            width: 0.5,
          ),
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
