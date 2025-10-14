import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yarnie/common/time_helper.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/project_info_screen.dart';
import 'package:yarnie/stopwatch_panel.dart';
import 'package:yarnie/counter_panel.dart';
import 'package:yarnie/widget/project_info_section.dart';

class ProjectDetailScreen extends StatelessWidget {
  final int projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    // Drift 스트림으로 단건 구독 (없으면 아래 주석 참고)
    final stream = appDb.watchProject(projectId);

    return StreamBuilder<Project>(
      stream: stream,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: Text('프로젝트를 찾을 수 없어요.')));
        }

        final project = snap.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(project.name),
            actions: [
              PopupMenuButton<String>(
                icon: Platform.isIOS
                    ? const Icon(CupertinoIcons.ellipsis_circle)
                    : null, // 안드로이드는 기본 아이콘 사용
                onSelected: (value) {
                  if (value == 'project_info') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            ProjectInfoScreen(projectId: project.id),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'project_info',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 8),
                        Text('프로젝트 정보'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(child: ProjectDetailTabs(projectId: project.id)),
            ],
          ),
        );
      },
    );
  }
}

class ProjectDetailTabs extends StatefulWidget {
  final int projectId;
  const ProjectDetailTabs({super.key, required this.projectId});

  @override
  State<ProjectDetailTabs> createState() => _ProjectDetailTabsState();
}

class _ProjectDetailTabsState extends State<ProjectDetailTabs> {
  // iOS 전용 선택 인덱스
  int _cupertinoIndex = 0;

  @override
  Widget build(BuildContext context) {
    // iOS: SegmentedControl + 내용 영역
    if (Platform.isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoSegmentedControl<int>(
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('스톱워치'),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('카운터'),
                ),
              },
              groupValue: _cupertinoIndex,
              onValueChanged: (v) => setState(() => _cupertinoIndex = v),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: IndexedStack(
              index: _cupertinoIndex,
              children: [
                StopwatchPanel(
                  key: const ValueKey('stopwatch'),
                  projectId: widget.projectId,
                ),
                CounterPanel(
                  key: const ValueKey('counter'),
                  projectId: widget.projectId,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Android/기타: TabBar + TabBarView
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '스톱워치', icon: Icon(Icons.timer_outlined)),
              Tab(text: '카운터', icon: Icon(Icons.exposure_plus_1)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                StopwatchPanel(projectId: widget.projectId),
                CounterPanel(projectId: widget.projectId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
