import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yarnie/features/projects/end_session_sheet_material.dart';

import 'end_session_sheet_cupertino.dart';

class EndSessionResult {
  final bool confirmed;
  final String? label;
  final String? memo;
  const EndSessionResult({required this.confirmed, this.label, this.memo});
}

Future<EndSessionResult?> showEndSessionSheet({
  required BuildContext context,
  required Duration segment,
  String? initialLabel,
  required Future<String?> Function(String? initial) onPickLabel,
}) {
  if (Platform.isIOS) {
    return showCupertinoModalBottomSheet<EndSessionResult>(
      context: context,
      expand: false,
      backgroundColor: CupertinoColors.systemBackground,
      builder: (_) => EndSessionSheetCupertino(
        segment: segment,
        initialLabel: initialLabel,
        onPickLabel: onPickLabel,
      ),
    );
  }
  return showModalBottomSheet<EndSessionResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => EndSessionSheetMaterial(
      segment: segment,
      initialLabel: initialLabel,
      onPickLabel: onPickLabel,
    ),
  );
}
