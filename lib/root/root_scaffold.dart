import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../features/home/home_root.dart';
import '../../features/projects/projects_root.dart';
import '../../features/my/my_root.dart';

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});
  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  final _bucket = PageStorageBucket();
  int _index = 0;
  DateTime? _lastBack; // 마지막 뒤로가기 시간
  final Duration _exitInterval = const Duration(seconds: 2);

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

void _handleBack(bool didPop, Object? result) {
    if (didPop) return;

    if (_index != 0) {
      setState(() => _index = 0);
      return;
    }

    // iOS에선 조용히 무시
    if (!Platform.isAndroid) return;

    // Android: 두 번 눌러 종료
    final now = DateTime.now();
    final canExit = _lastBack != null && now.difference(_lastBack!) < _exitInterval;

    if (canExit) {
      SystemNavigator.pop(); // 종료
      return;
    }

    _lastBack = now;
    final m = ScaffoldMessenger.of(context);
    m.removeCurrentSnackBar();
    m.showSnackBar(const SnackBar(content: Text('한 번 더 누르면 종료됩니다.'), duration: Duration(seconds: 2)));
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
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder), label: '프로젝트'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '마이'),
        ],
      ),
      )
    );
  }
}
