import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/root/root_scaffold.dart';
import 'package:yarnie/core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final projects = await appDb.watchAll().first;
  for (final project in projects) {
    debugPrint(
      '📌Project: id=${project.id}, name=${project.name}, needleType=${project.needleType}, needleSize=${project.needleSize}, lotNumber=${project.lotNumber}, memo=${project.memo}, createdAt=${project.createdAt}, updatedAt=${project.updatedAt}',
    );
  }

  // 삭제된지 30일이 지난 프로젝트 영구 삭제
  try {
    await appDb.cleanupDeletedProjects();
  } catch (e) {
    debugPrint('Failed to cleanup deleted projects: $e');
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final appLanguage = ref.watch(localeProvider);
    Locale? locale;
    if (appLanguage == AppLanguage.ko) {
      locale = const Locale('ko');
    } else if (appLanguage == AppLanguage.en) {
      locale = const Locale('en');
    }

    return MaterialApp(
      title: 'Yarnie',
      locale: locale,
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
