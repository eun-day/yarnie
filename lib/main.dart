import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/root/root_scaffold.dart';
import 'package:yarnie/core/providers/locale_provider.dart';
import 'package:yarnie/core/providers/theme_provider.dart';
import 'package:yarnie/theme/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SharedPreferences? prefs;

  await Future.wait([
    Future(() async {
      unawaited(MobileAds.instance.initialize());

      // RevenueCat SDK 초기화
      String apiKey = '';
      if (Platform.isIOS) {
        apiKey = 'appl_NhwQkFMfsQMHbeQARtdYGIJmros';
      } else if (Platform.isAndroid) {
        apiKey = 'goog_YYXVYRZQeWDAodvssxJXwOOZonT';
      }

      if (apiKey.isNotEmpty) {
        await Purchases.setLogLevel(LogLevel.debug);
        PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
        await Purchases.configure(configuration);
      }

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

      prefs = await SharedPreferences.getInstance();
    }),
    Future.delayed(const Duration(seconds: 1)),
  ]);

  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [
        if (prefs != null) sharedPreferencesProvider.overrideWithValue(prefs!),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLanguage = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Yarnie',
      locale: appLanguage.locale,
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.themeData(AppTheme.lightScheme),
      darkTheme: AppTheme.themeData(AppTheme.darkScheme),
      themeMode: themeMode,
      home: const RootScaffold(),
    );
  }
}
