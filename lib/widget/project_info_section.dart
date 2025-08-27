import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProjectInfoSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const ProjectInfoSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = true,
  });

  @override
  State<ProjectInfoSection> createState() => _ProjectInfoSectionState();
}

class _ProjectInfoSectionState extends State<ProjectInfoSection> {
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // iOS 스타일: Disclosure + 애니메이션
      return Column(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 16)),
                Icon(
                  _expanded
                      ? CupertinoIcons.chevron_down
                      : CupertinoIcons.chevron_forward,
                  size: 18,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: widget.child,
            ),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      );
    }

    // Android(Material): ExpansionTile
    return ExpansionTile(
      title: Text(widget.title),
      initiallyExpanded: widget.initiallyExpanded,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [widget.child],
    );
  }
}
