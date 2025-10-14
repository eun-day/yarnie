import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/root/root_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final projects = await appDb.watchAll().first;
  for (final project in projects) {
    print(
        '📌Project: id=${project.id}, name=${project.name}, category=${project.category}, needleType=${project.needleType}, needleSize=${project.needleSize}, lotNumber=${project.lotNumber}, memo=${project.memo}, createdAt=${project.createdAt}, updatedAt=${project.updatedAt}');
  }

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
      home: const RootScaffold(),
    );
  }
}
