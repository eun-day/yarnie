import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainCounterSettingsButton extends StatelessWidget {
  final VoidCallback onChangeTarget;
  final VoidCallback onRemoveTarget;

  const MainCounterSettingsButton({
    super.key,
    required this.onChangeTarget,
    required this.onRemoveTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'change') onChangeTarget();
          if (value == 'remove') onRemoveTarget();
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 224,
          maxWidth: 224,
        ),
        // Custom styling to match Figma
        color: Theme.of(context).colorScheme.surface,
        elevation: 3,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            width: 0.5,
          ),
        ),
        // Offset to align below the button
        offset: const Offset(0, 36),
        
        // Menu Items
        itemBuilder: (context) => [
          _buildMenuItem(context, 'change', '목표 단수 변경'),
          _buildMenuItem(context, 'remove', '목표 단수 해제'),
        ],
        
        // The Trigger Button
        child: SvgPicture.asset(
          'assets/icons/settings.svg',
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.surface, BlendMode.srcIn),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 4.5), // Outer padding from Figma
      child: Container(
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 8), // Inner padding from Figma
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
      ),
    );
  }
}
