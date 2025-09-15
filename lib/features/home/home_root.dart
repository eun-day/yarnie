import 'package:flutter/material.dart';
import 'package:yarnie/counter_screen.dart';
import 'package:yarnie/new_project_screen.dart';

class HomeRoot extends StatelessWidget {
  final ScrollController? controller;
  final String title;

  const HomeRoot({super.key, this.controller, this.title = 'Yarnie'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NewProjectScreen()),
                  );
                },
                child: const Text('New Project'),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              // 혹시 작은 화면 대응
              controller: controller,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[                  
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CounterScreen(title: 'Counter'),
                        ),
                      );
                    },
                    child: const Text('Go to Counter'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // 예시: 리스트(스크롤 위치 PageStorageKey로 보존)
  //   return ListView.builder(
  //     controller: controller,
  //     key: const PageStorageKey('home_list'),
  //     padding: const EdgeInsets.all(16),
  //     itemCount: 30,
  //     itemBuilder: (_, i) => Card(
  //       child: ListTile(title: Text('홈 아이템 #$i')),
  //     ),
  //   );
  // }
}
