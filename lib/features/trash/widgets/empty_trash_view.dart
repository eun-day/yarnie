import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyTrashView extends StatelessWidget {
  /// 실 휴지통 탭이면 true (안내 문구만 다름)
  final bool isStash;

  const EmptyTrashView({super.key, this.isStash = false});

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
          isStash
              ? AppLocalizations.of(context)!.noDeletedYarns
              : AppLocalizations.of(context)!.noDeletedProjects,
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
