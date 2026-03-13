import 'package:flutter/material.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/features/projects/end_session_result.dart';
import 'package:yarnie/widget/labelpill.dart';

class EndSessionSheetMaterial extends StatefulWidget {
  final Duration segment;
  final String? initialLabel;
  final Future<String?> Function(String? initial) onPickLabel;
  const EndSessionSheetMaterial({
    super.key,
    required this.segment,
    required this.initialLabel,
    required this.onPickLabel,
  });

  @override
  State<EndSessionSheetMaterial> createState() => _EndSessionSheetMaterialState();
}

class _EndSessionSheetMaterialState extends State<EndSessionSheetMaterial> {
  late final _memoCtl = TextEditingController();
  late final _focus = FocusNode();
  String? _label;

  @override
  void initState() {
    super.initState();
    _label = widget.initialLabel;
  }

  @override
  void dispose() {
    _focus.dispose();
    _memoCtl.dispose();
    super.dispose();
  }

  void _close(bool ok) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(EndSessionResult(
      confirmed: ok,
      label: _label,
      memo: ok ? _memoCtl.text.trim() : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomPad = mq.viewInsets.bottom + mq.viewPadding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: LabelPill(
                text: _label ?? AppLocalizations.of(context)!.unclassified,
                isIOS: false,
                onTap: () async {
                  final picked = await widget.onPickLabel(_label);
                  if (!mounted) return;
                  setState(() => _label = picked);
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _memoCtl,
              focusNode: _focus,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterMemo,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.saveSessionConfirm(fmt(widget.segment)),
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                OutlinedButton(onPressed: () => _close(false), child: Text(AppLocalizations.of(context)!.cancel)),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context)!.save),
                  onPressed: () => _close(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
