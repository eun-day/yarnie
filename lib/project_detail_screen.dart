import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/stopwatch_panel.dart';
import 'package:yarnie/widget/project_info_section.dart';

class ProjectDetailScreen extends StatelessWidget {
  final int projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  String _fmt(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

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
        final created = project.createdAt.toLocal();
        final updated = project.updatedAt?.toLocal();

        return Scaffold(
          appBar: AppBar(title: Text(project.name)),
          body: Column(
            children: [
              ProjectInfoSection(
                title: '프로젝트 정보',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _kv('카테고리', project.category ?? '-'),
                    _kv('바늘 종류', project.needleType ?? '-'),
                    _kv('바늘 호수', project.needleSize ?? '-'),
                    _kv('Lot No.', project.lotNumber ?? '-'),
                    _kv(
                      '메모',
                      project.memo?.isNotEmpty == true ? project.memo! : '-',
                    ),
                    const Divider(height: 24),
                    _kv('생성일', _fmt(created)),
                    _kv('수정일', updated != null ? _fmt(updated) : '-'),
                  ],
                ),
              ),
              const Divider(height: 1),
              const Expanded(child: ProjectDetailTabs()),
            ],
          ),
        );
      },
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}

class ProjectDetailTabs extends StatefulWidget {
  const ProjectDetailTabs({super.key});

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
              children: const [
                  StopwatchPanel(key: ValueKey('stopwatch')),
                  _CounterView(key: ValueKey('counter')),
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
        children: const [
          TabBar(
            tabs: [
              Tab(text: '스톱워치', icon: Icon(Icons.timer_outlined)),
              Tab(text: '카운터', icon: Icon(Icons.exposure_plus_1)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                StopwatchPanel(),
                _CounterView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterView extends StatefulWidget {
  const _CounterView({super.key});

  @override
  State<_CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<_CounterView> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 카운터(단수/패턴 등) UI로 교체
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('카운트: $count', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () => setState(() => count++),
              icon: const Icon(Icons.add),
              label: const Text('증가'),
            ),
            OutlinedButton.icon(
              onPressed: () => setState(() => count = 0),
              icon: const Icon(Icons.refresh),
              label: const Text('리셋'),
            ),
          ],
        ),
      ],
    );
  }
}
