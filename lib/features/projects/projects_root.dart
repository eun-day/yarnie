import 'package:flutter/material.dart';
import 'package:yarnie/new_project_screen.dart';
import '../../db/app_db.dart';
import '../../db/di.dart'; // appDb

class ProjectsRoot extends StatefulWidget {
  final ScrollController controller;
  final bool debugForceEmpty; // ⬅️ 임시
  const ProjectsRoot({super.key, required this.controller, this.debugForceEmpty = true});

  @override
  State<ProjectsRoot> createState() => _ProjectsRootState();
}

class _ProjectsRootState extends State<ProjectsRoot> {
  late final Stream<List<Project>> _stream;

  @override
  void initState() {
    super.initState();
    //_stream = appDb.watchAll(); // 한 번만 생성
    _stream = widget.debugForceEmpty
    ? Stream.value(const <Project>[])          // ⬅️ 강제로 빈 목록
    : appDb.watchAll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(              // ⬅️ 상단(iOS 노치/Android status bar) 여백 확보
      top: true,
      bottom: false,              // 하단은 NavigationBar가 이미 있으니 false 권장
      child: StreamBuilder<List<Project>>(
        stream: _stream, // AppDb의 watchAll() 그대로 사용
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('오류: ${snap.error}'));
          }
          final items = snap.data ?? const <Project>[];
          if (items.isEmpty) {
            return const _EmptyView();
          }

          return ListView.builder(
            controller: widget.controller,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(_metaText(p)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailPage(project: p),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _metaText(Project p) {
    final cat = p.category?.isNotEmpty == true ? p.category! : '카테고리 없음';
    final dt = (p.createdAt).toLocal();
    final d =
        '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
    return '$cat · $d';
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 일러스트 (없으면 그냥 아이콘 쓰자)
            Image.asset(
              'assets/illus/empty_projects.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.folder_open, size: 96),
            ),
            const SizedBox(height: 16),
            Text(
              '아직 만든 프로젝트가 없어요.\n프로젝트를 만들어볼까요?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewProjectScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('프로젝트 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}

// 상세 페이지 (간단 버전)
class ProjectDetailPage extends StatelessWidget {
  final Project project;
  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final created = project.createdAt.toLocal();
    final updated = project.updatedAt?.toLocal();
    String fmt(DateTime dt) =>
        '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kv('카테고리', project.category ?? '-'),
          _kv('바늘 종류', project.needleType ?? '-'),
          _kv('바늘 호수', project.needleSize ?? '-'),
          _kv('Lot No.', project.lotNumber ?? '-'),
          _kv('메모', project.memo?.isNotEmpty == true ? project.memo! : '-'),
          const Divider(height: 24),
          _kv('생성일', fmt(created)),
          _kv('수정일', updated != null ? fmt(updated) : '-'),
        ],
      ),
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
