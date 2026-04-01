import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/core/providers/premium_provider.dart';

class AdVisibilityWrapper extends ConsumerWidget {
  final Widget child;

  const AdVisibilityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);

    if (isPremium) {
      return const SizedBox.shrink();
    }

    return child;
  }
}
