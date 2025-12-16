import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/root/root_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final projects = await appDb.watchAll().first;
  for (final project in projects) {
    print(
      '📌Project: id=${project.id}, name=${project.name}, needleType=${project.needleType}, needleSize=${project.needleSize}, lotNumber=${project.lotNumber}, memo=${project.memo}, createdAt=${project.createdAt}, updatedAt=${project.updatedAt}',
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ① 시드로 기본 팔레트 생성
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF637069), // 브랜드 카키톤
      brightness: Brightness.light,
    );

    // ② 필요한 색상만 덮어쓰기
    final yarnieScheme = baseScheme.copyWith(
      primary: const Color(0xFF637069), // 브랜드 카키톤
      secondary: const Color(0xFFC0D2A4), // 연한 올리브
      error: const Color(0xFFD4183D), // 흰색 배경
      surface: const Color(0xFFFFFFFF), // 카드/서피스 흰색
      surfaceContainerHighest: const Color(0xFFECECF0), // muted 배경
      onSurfaceVariant: const Color(0xFF717182), // 회색 텍스트
      outline: const Color(0x1A000000), // 투명한 검정 보더
    );

    return MaterialApp(
      title: 'Yarnie',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: yarnieScheme,
        filledButtonTheme: FilledButtonThemeData(
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFF637069)),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
        ),
      ),
      home: const RootScaffold(),
    );
  }
}
