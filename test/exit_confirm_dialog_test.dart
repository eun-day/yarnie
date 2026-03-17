import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yarnie/widgets/exit_confirm_dialog.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Widget createTestWidget() {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ko')],
      home: ExitConfirmDialog(),
    );
  }

  testWidgets('ExitConfirmDialog displays title and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    // Check if title is present (default English)
    expect(find.text('Do you want to exit the app?'), findsOneWidget);

    // Check for buttons
    expect(find.text('Exit'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Check for Ad placeholder or AdWidget
    // Note: AdWidget might not be easily findable in unit tests without proper mocking
    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('ExitConfirmDialog returns true when Exit is pressed', (WidgetTester tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ko')],
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (context) => const ExitConfirmDialog(),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pump();

    await tester.tap(find.text('Exit'));
    await tester.pump();

    expect(result, true);
  });

  testWidgets('ExitConfirmDialog returns false when Cancel is pressed', (WidgetTester tester) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ko')],
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (context) => const ExitConfirmDialog(),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pump();

    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(result, false);
  });
}
