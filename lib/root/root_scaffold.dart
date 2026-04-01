import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/exit_confirm_dialog.dart';
import 'package:yarnie/core/providers/premium_provider.dart';
import '../../features/home/home_root.dart';
import '../../features/projects/projects_root.dart';
import '../../features/my/my_root.dart';

class RootScaffold extends ConsumerStatefulWidget {
  const RootScaffold({super.key});
  @override
  ConsumerState<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends ConsumerState<RootScaffold> {
  final _bucket = PageStorageBucket();
  int _index = 0;

  // 탭 재탭 시 맨 위로 스크롤용 컨트롤러
  final _homeCtrl = ScrollController();
  final _projectsCtrl = ScrollController();
  final _myCtrl = ScrollController();

  @override
  void dispose() {
    _homeCtrl.dispose();
    _projectsCtrl.dispose();
    _myCtrl.dispose();
    super.dispose();
  }

  void _onTap(int i) {
    if (i == _index) {
      // 같은 탭 다시 탭하면 해당 리스트 맨 위로
      final ctrl = [_homeCtrl, _projectsCtrl, _myCtrl][i];
      if (ctrl.hasClients) {
        ctrl.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
      return;
    }
    setState(() => _index = i);
  }

Future<void> _handleBack(bool didPop, Object? result) async {
    if (didPop) return;

    if (_index != 0) {
      setState(() => _index = 0);
      return;
    }

    // iOS에선 조용히 무시
    if (!Platform.isAndroid) return;

    final isPremium = ref.read(premiumProvider);
    if (isPremium) {
      SystemNavigator.pop();
      return;
    }

    // Android: 앱 종료 확인 팝업 노출
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => const ExitConfirmDialog(),
    );

    if (shouldExit == true) {
      SystemNavigator.pop(); // 종료
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 우리가 직접 처리
      onPopInvokedWithResult: _handleBack,
      child: Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(
          index: _index,
          children: [
            HomeRoot(controller: _homeCtrl, key: const PageStorageKey('home')),
            ProjectsRoot(controller: _projectsCtrl, key: const PageStorageKey('projects')),
            MyRoot(controller: _myCtrl, key: const PageStorageKey('my')),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: AppLocalizations.of(context)!.projects),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: AppLocalizations.of(context)!.my),
        ],
      ),
      )
    );
  }
}
