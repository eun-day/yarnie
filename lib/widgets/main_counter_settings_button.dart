import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/theme/app_theme.dart';

class MainCounterSettingsButton extends StatelessWidget {
  final VoidCallback onChangeTarget;
  final VoidCallback onRemoveTarget;
  final VoidCallback onSetCountBy;

  const MainCounterSettingsButton({
    super.key,
    required this.onChangeTarget,
    required this.onRemoveTarget,
    required this.onSetCountBy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        dividerTheme: DividerThemeData(
          color: Theme.of(context).colorScheme.outline,
          thickness: 0.5,
          space: 8,
        ),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'change') onChangeTarget();
          if (value == 'remove') onRemoveTarget();
          if (value == 'countBy') onSetCountBy();
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
            color: Theme.of(context).colorScheme.outline,
            width: 0.5,
          ),
        ),
        // Offset to align below the button
        offset: const Offset(0, 36),
        
        // Menu Items
        itemBuilder: (context) => [
          _buildMenuItem(context, 'change', l10n.changeTargetRow),
          _buildMenuItem(context, 'remove', l10n.removeTargetRow),
          const PopupMenuDivider(height: 8),
          _buildMenuItem(context, 'countBy', l10n.setCountBy),
        ],
        
        // The Trigger Button
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/icons/settings.svg',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              context.counterSettingsIcon,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 4.5), // Outer padding from Figma
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 8), // Inner padding from Figma
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: context.popupMenuTextColor,
            letterSpacing: -0.15,
          ),
        ),
      ),
    );
  }
}
