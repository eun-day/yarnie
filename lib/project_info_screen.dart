import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/new_project_screen.dart';

class ProjectInfoScreen extends StatefulWidget {
  final int projectId;

  const ProjectInfoScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  bool _isLoading = true;
  Project? _project;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    // watchProject를 사용하여 실시간 업데이트 지원
    appDb.watchProject(widget.projectId).listen((project) {
      if (mounted) {
        setState(() {
          _project = project;
          _isLoading = false;
        });
      }
    });
  }

  String _fmt(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('프로젝트 정보')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('프로젝트 정보')),
        body: const Center(child: Text('프로젝트를 찾을 수 없습니다')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로젝트 정보'),
        actions: [
          if (Platform.isIOS)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        NewProjectScreen(projectId: widget.projectId),
                  ),
                );
              },
              child: const Text('편집'),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        NewProjectScreen(projectId: widget.projectId),
                  ),
                );
              },
            ),
        ],
      ),
      body: _buildViewMode(),
    );
  }

  Widget _buildViewMode() {
    final created = _project!.createdAt.toLocal();
    final updated = _project!.updatedAt?.toLocal();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard([
            _kv('프로젝트 이름', _project!.name),
            _kv('바늘 종류', _project!.needleType ?? '-'),
            _kv('바늘 사이즈', _project!.needleSize ?? '-'),
            _kv('Lot Number', _project!.lotNumber ?? '-'),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard([_kvMultiline('메모', _project!.memo ?? '-')]),
          const SizedBox(height: 16),
          _buildInfoCard([
            _kv('생성일', _fmt(created)),
            _kv('수정일', updated != null ? _fmt(updated) : '-'),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
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

  Widget _kvMultiline(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(v),
        ],
      ),
    );
  }
}
