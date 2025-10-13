import 'dart:io' show Platform;
import 'package:drift/drift.dart' show Value;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';

class ProjectInfoScreen extends StatefulWidget {
  final int projectId;
  final bool isEditMode;

  const ProjectInfoScreen({
    super.key,
    required this.projectId,
    this.isEditMode = false,
  });

  @override
  State<ProjectInfoScreen> createState() => _ProjectInfoScreenState();
}

class _ProjectInfoScreenState extends State<ProjectInfoScreen> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _lotNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCategory;
  String? _selectedNeedleType;
  String? _selectedNeedleSize;

  bool _isEditMode = false;
  bool _isLoading = true;
  Project? _project;

  final List<String> _categories = ['뜨개', '자수', '퀼트', '기타'];
  final Map<String, List<String>> _needleSizes = {
    '대바늘': [
      '2.0mm',
      '2.5mm',
      '3.0mm',
      '3.5mm',
      '4.0mm',
      '4.5mm',
      '5.0mm',
      '5.5mm',
      '6.0mm',
      '6.5mm',
      '7.0mm',
      '8.0mm',
      '9.0mm',
      '10.0mm',
    ],
    '코바늘': [
      '2/0호 (2.0mm)',
      '3/0호 (2.2mm)',
      '4/0호 (2.5mm)',
      '5/0호 (3.0mm)',
      '6/0호 (3.5mm)',
      '7/0호 (4.0mm)',
      '8/0호 (5.0mm)',
      '9/0호 (5.5mm)',
      '10/0호 (6.0mm)',
    ],
  };

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.isEditMode;
    _loadProject();
  }

  void _loadProject() {
    // watchProject를 사용하여 실시간 업데이트 지원
    appDb.watchProject(widget.projectId).listen((project) {
      if (mounted) {
        setState(() {
          _project = project;
          _projectNameController.text = project.name;
          _selectedCategory = project.category;
          _selectedNeedleType = project.needleType;
          _selectedNeedleSize = project.needleSize;
          _lotNumberController.text = project.lotNumber ?? '';
          _notesController.text = project.memo ?? '';
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _saveProject() async {
    if (_project == null) return;

    try {
      await appDb.updateProject(
        ProjectsCompanion(
          id: Value(_project!.id),
          name: Value(_projectNameController.text),
          category: Value(_selectedCategory),
          needleType: Value(_selectedNeedleType),
          needleSize: Value(_selectedNeedleSize),
          lotNumber: Value(
            _lotNumberController.text.isEmpty
                ? null
                : _lotNumberController.text,
          ),
          memo: Value(
            _notesController.text.isEmpty ? null : _notesController.text,
          ),
        ),
      );

      setState(() => _isEditMode = false);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로젝트 정보가 저장되었습니다')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    }
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
        actions: _isEditMode
            ? [
                TextButton(
                  onPressed: () => setState(() => _isEditMode = false),
                  child: const Text('취소'),
                ),
                TextButton(onPressed: _saveProject, child: const Text('저장')),
              ]
            : [
                if (Platform.isIOS)
                  TextButton(
                    onPressed: () => setState(() => _isEditMode = true),
                    child: const Text('편집'),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => setState(() => _isEditMode = true),
                  ),
              ],
      ),
      body: _isEditMode ? _buildEditMode() : _buildViewMode(),
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
            _kv('카테고리', _project!.category ?? '-'),
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

  Widget _buildEditMode() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          children: [
            TextField(
              controller: _projectNameController,
              decoration: const InputDecoration(
                labelText: '프로젝트 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              hint: const Text('카테고리 선택'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (String? newValue) {
                setState(() => _selectedCategory = newValue);
              },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedNeedleType,
              hint: const Text('바늘 종류 선택'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedNeedleType = newValue;
                  _selectedNeedleSize = null;
                });
              },
              items: _needleSizes.keys.map<DropdownMenuItem<String>>((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _selectedNeedleSize,
              hint: const Text('바늘 사이즈 선택'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              onChanged: _selectedNeedleType == null
                  ? null
                  : (String? newValue) {
                      setState(() => _selectedNeedleSize = newValue);
                    },
              items: _selectedNeedleType == null
                  ? []
                  : _needleSizes[_selectedNeedleType]!
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _lotNumberController,
              decoration: const InputDecoration(
                labelText: 'Lot Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _notesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: '메모',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
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

  @override
  void dispose() {
    _projectNameController.dispose();
    _lotNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
