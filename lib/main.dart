import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/root/root_scaffold.dart';
import 'package:yarnie/widget/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yarnie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppInitializer(),
    );
  }
}

/// 앱 초기화를 담당하는 위젯
/// 데이터베이스 초기화 등의 작업을 수행하면서 로딩 화면을 표시합니다.
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 데이터 로드와 최소 로딩 시간을 병렬로 처리
      await Future.wait([
        _loadAppData(),
        Future.delayed(const Duration(milliseconds: 1500)), // 1.5초로 단축
      ]);

      if (mounted) {
        // 페이드 전환 효과 적용
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const RootScaffold(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      }
    } catch (error) {
      // 에러 처리
      debugPrint('앱 초기화 중 오류 발생: $error');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const RootScaffold(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      }
    }
  }

  Future<void> _loadAppData() async {
    // 데이터베이스 초기화 및 데이터 로드
    final projects = await appDb.watchAll().first;
    debugPrint('로드된 프로젝트 수: ${projects.length}');

    // 추가적인 초기화 작업이 필요한 경우 여기에 추가
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen();
  }
}
