import 'package:flutter/material.dart';

class MyRoot extends StatelessWidget {
  final ScrollController? controller;
  const MyRoot({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      key: const PageStorageKey('my_scroll'),
      slivers: const [
        SliverAppBar(
          pinned: true,
          title: Text('마이'),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            ListTile(title: Text('프로필')),
            ListTile(title: Text('설정')),
            ListTile(title: Text('도움말')),
          ]),
        ),
      ],
    );
  }
}
