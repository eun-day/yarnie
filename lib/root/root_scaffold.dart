import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/widgets/exit_confirm_dialog.dart';
import 'package:yarnie/widgets/session_absence_dialog.dart';
import 'package:yarnie/core/providers/premium_provider.dart';
import 'package:yarnie/modules/projects/application/session_absence_event.dart';
import 'package:yarnie/modules/projects/application/session_absence_notifier.dart';
import 'package:yarnie/modules/projects/application/session_absence_state.dart';
import '../../features/home/home_root.dart';
import '../../features/projects/projects_root.dart';
import '../../features/stash/stash_root.dart';
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
  final _stashCtrl = ScrollController();
  final _myCtrl = ScrollController();

  // 앱을 떠났다 돌아오면 진행 중인 세션 시간 정산 (기획: 복귀 시 정산 UX)
  late final AppLifecycleListener _lifecycleListener;
  bool _isAbsenceDialogOpen = false;

  @override
  void initState() {
    super.initState();
    final absence = ref.read(sessionAbsenceProvider.notifier);
    _lifecycleListener = AppLifecycleListener(
      onHide: () => absence.onEvent(const AppWentToBackground()),
      onResume: () => absence.onEvent(const AppReturnedToForeground()),
    );
    // 백그라운드에서 앱이 종료된 뒤 다시 켜진 경우도 확인
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => absence.onEvent(const AppReturnedToForeground()),
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _homeCtrl.dispose();
    _projectsCtrl.dispose();
    _stashCtrl.dispose();
    _myCtrl.dispose();
    super.dispose();
  }

  Future<void> _showAbsenceDialog(Duration absence) async {
    if (_isAbsenceDialogOpen) return;
    _isAbsenceDialogOpen = true;
    final include = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SessionAbsenceDialog(absence: absence),
    );
    _isAbsenceDialogOpen = false;
    if (!mounted) return;
    // 뒤로가기로 닫으면 기본 동작(반영)을 유지
    await ref
        .read(sessionAbsenceProvider.notifier)
        .onEvent(AbsenceResolved(include ?? true));
  }

  void _onTap(int i) {
    if (i == _index) {
      // 같은 탭 다시 탭하면 해당 리스트 맨 위로
      final ctrl = [_homeCtrl, _projectsCtrl, _stashCtrl, _myCtrl][i];
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
    ref.listen<SessionAbsenceState>(sessionAbsenceProvider, (previous, next) {
      final absence = next.pendingAbsence;
      if (absence != null && previous?.pendingAbsence == null) {
        _showAbsenceDialog(absence);
      }
    });

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
            StashRoot(controller: _stashCtrl, key: const PageStorageKey('stash')),
            MyRoot(controller: _myCtrl, key: const PageStorageKey('my')),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: AppLocalizations.of(context)!.home),
          NavigationDestination(icon: const Icon(Icons.folder_outlined), selectedIcon: const Icon(Icons.folder), label: AppLocalizations.of(context)!.projects),
          NavigationDestination(icon: const Icon(Icons.inventory_2_outlined), selectedIcon: const Icon(Icons.inventory_2), label: AppLocalizations.of(context)!.stash),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: AppLocalizations.of(context)!.my),
        ],
      ),
      )
    );
  }
}
