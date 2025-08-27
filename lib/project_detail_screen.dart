import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';


// 상세 페이지 (간단 버전)
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
              return const Scaffold(
                body: Center(child: Text('프로젝트를 찾을 수 없어요.')),
              );
            }

            final project = snap.data!;
            final created = project.createdAt.toLocal();
            final updated = project.updatedAt?.toLocal();

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
                  _kv('생성일', _fmt(created)),
                  _kv('수정일', updated != null ? _fmt(updated) : '-'),
                ],
              ),
            );
          }
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
