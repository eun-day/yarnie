import 'package:flutter/cupertino.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/features/projects/end_session_result.dart';
import 'package:yarnie/widget/labelpill.dart' show LabelPill;

class EndSessionSheetCupertino extends StatefulWidget {
  final Duration segment;
  final String? initialLabel;
  final Future<String?> Function(String? initial) onPickLabel;
  const EndSessionSheetCupertino({
    super.key,
    required this.segment,
    required this.initialLabel,
    required this.onPickLabel,
  });

  @override
  State<EndSessionSheetCupertino> createState() => _EndSessionSheetCupertinoState();
}

class _EndSessionSheetCupertinoState extends State<EndSessionSheetCupertino> {
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
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPad),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: LabelPill(
                  text: _label ?? '미분류',
                  isIOS: true,
                  onTap: () async {
                    final picked = await widget.onPickLabel(_label);
                    if (!mounted) return;
                    setState(() => _label = picked);
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('작업 메모', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              CupertinoTextField(
                controller: _memoCtl,
                focusNode: _focus,
                maxLines: 4,
                placeholder: '메모를 입력하세요',
              ),
              const SizedBox(height: 16),
              Text('작업 시간 ${fmt(widget.segment)}을 저장하시겠습니까?',
                  style: const TextStyle(fontSize: 14, color: CupertinoColors.label)),
              const SizedBox(height: 16),
              Row(
                children: [
                  CupertinoButton(child: const Text('취소'), onPressed: () => _close(false)),
                  const Spacer(),
                  CupertinoButton.filled(child: const Text('저장'), onPressed: () => _close(true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
