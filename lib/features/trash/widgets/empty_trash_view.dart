import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyTrashView extends StatelessWidget {
  const EmptyTrashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/trash_empty.svg',
            width: 64,
            height: 64,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.emptyTrash,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.44,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.noDeletedProjects,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: -0.15,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
