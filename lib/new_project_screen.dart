import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/modules/projects/projects_api.dart';
import 'package:yarnie/project_detail_screen.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/widgets/tag_selection_sheet.dart'; // New import

class NewProjectScreen extends ConsumerStatefulWidget {
  final int? projectId; // 수정 모드일 경우 null이 아님

  const NewProjectScreen({this.projectId, super.key});

  @override
  ConsumerState<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends ConsumerState<NewProjectScreen> {
  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드는 initState에서 한 번만 수행
    Future.microtask(() => ref
        .read(projectFormNotifierProvider.notifier)
        .onEvent(LoadProjectData(widget.projectId)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<ProjectFormEffect>>(projectFormEffectsProvider, (_, asyncEffect) {
      asyncEffect.whenData((effect) {
        if (effect is GoToProjectDetail) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ProjectDetailScreen(projectId: effect.projectId),
            ),
          );
        } else if (effect is CloseEditForm) {
          Navigator.of(context).pop();
        } else if (effect is ShowProjectFormSuccessMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(effect.message)),
          );
        } else if (effect is ShowProjectFormErrorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(effect.message), backgroundColor: Theme.of(context).colorScheme.error),
          );
        }
      });
    });

    final state = ref.watch(projectFormNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditMode ? '프로젝트 수정' : '새 프로젝트'),
        actions: [
          TextButton(
            onPressed: state.isSaving
                ? null
                : () => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(const SaveProject()),
            child: state.isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProjectNameSection(
                initialValue: state.name,
                onChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(ProjectNameChanged(value)),
              ),
              const SizedBox(height: 24),
              _ProjectImageSection(
                imagePath: state.imagePath,
                onImagePressed: () => _showImageSourceSheet(context),
              ),
              const SizedBox(height: 24),
              _NeedleInfoSection(
                needleType: state.needleType,
                needleSize: state.needleSize,
                availableNeedleSizes: state.availableNeedleSizes,
                onNeedleTypeChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(NeedleTypeChanged(value)),
                onNeedleSizeChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(NeedleSizeChanged(value)),
              ),
              const SizedBox(height: 24),
              _YarnInfoSection(
                lotNumber: state.lotNumber,
                memo: state.memo,
                onLotNumberChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(LotNumberChanged(value)),
                onMemoChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(MemoChanged(value)),
              ),
              const SizedBox(height: 24),
              _TagInfoSection(
                allTags: state.allAvailableTags,
                selectedTagIds: state.selectedTagIds,
                onAddTagPressed: () async {
                  final result = await showModalBottomSheet<Set<int>>(
                    context: context,
                    isScrollControlled: true, // 전체 화면 높이 사용 가능
                    builder: (_) => TagSelectionSheet(
                      initialSelectedIds: state.selectedTagIds,
                    ),
                  );
                  if (result != null) {
                    ref
                        .read(projectFormNotifierProvider.notifier)
                        .onEvent(UpdateSelectedTags(result));
                  }
                },
                onRemoveTag: (tagId) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(ToggleTagSelected(tagId)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('앨범에서 선택'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('이미지 삭제'),
              onTap: () {
                ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(const ImagePathChanged(null));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      ref
          .read(projectFormNotifierProvider.notifier)
          .onEvent(ImagePathChanged(pickedFile.path));
    }
  }
}

// === Sections ===

class _ProjectImageSection extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onImagePressed;

  const _ProjectImageSection({this.imagePath, required this.onImagePressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onImagePressed,
        child: Container(
          width: double.infinity, // Take full width available within parent
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
                image: imagePath != null
                    ? DecorationImage(
                        image: FileImage(File(imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imagePath == null
                  ? Icon(Icons.camera_alt, size: 48, color: Colors.grey.shade600)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectNameSection extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _ProjectNameSection({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_ProjectNameSection> createState() => _ProjectNameSectionState();
}

class _ProjectNameSectionState extends State<_ProjectNameSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_ProjectNameSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium,
            children: <TextSpan>[
              const TextSpan(text: '프로젝트명'),
              TextSpan(
                text: ' *', // Red asterisk
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
            hintText: '프로젝트 이름을 입력하세요',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}

class _NeedleInfoSection extends StatelessWidget {
  final NeedleType? needleType;
  final String? needleSize;
  final List<String> availableNeedleSizes;
  final ValueChanged<String?> onNeedleTypeChanged;
  final ValueChanged<String?> onNeedleSizeChanged;

  const _NeedleInfoSection({
    required this.needleType,
    required this.needleSize,
    required this.availableNeedleSizes,
    required this.onNeedleTypeChanged,
    required this.onNeedleSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('사용 바늘 정보', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: needleType?.toString().split('.').last,
                onChanged: onNeedleTypeChanged,
                decoration: const InputDecoration(
                  labelText: '바늘 종류',
                  border: OutlineInputBorder(),
                ),
                items: NeedleType.values
                    .map((type) => DropdownMenuItem(
                          value: type.toString().split('.').last,
                          child: Text(type == NeedleType.knitting ? '대바늘' : '코바늘'),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: needleSize,
                onChanged: onNeedleSizeChanged,
                decoration: const InputDecoration(
                  labelText: '사이즈',
                  border: OutlineInputBorder(),
                ),
                items: availableNeedleSizes
                    .map((size) => DropdownMenuItem(
                          value: size,
                          child: Text(size),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _YarnInfoSection extends StatefulWidget {
  final String? lotNumber;
  final String? memo;
  final ValueChanged<String> onLotNumberChanged;
  final ValueChanged<String> onMemoChanged;

  const _YarnInfoSection({
    this.lotNumber,
    this.memo,
    required this.onLotNumberChanged,
    required this.onMemoChanged,
  });

  @override
  State<_YarnInfoSection> createState() => _YarnInfoSectionState();
}

class _YarnInfoSectionState extends State<_YarnInfoSection> {
  late final TextEditingController _lotNumberController;
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _lotNumberController = TextEditingController(text: widget.lotNumber ?? '');
    _memoController = TextEditingController(text: widget.memo ?? '');
  }

  @override
  void didUpdateWidget(_YarnInfoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lotNumber != _lotNumberController.text) {
      _lotNumberController.text = widget.lotNumber ?? '';
    }
    if (widget.memo != _memoController.text) {
      _memoController.text = widget.memo ?? '';
    }
  }

  @override
  void dispose() {
    _lotNumberController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('사용 실 정보', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lotNumberController,
          onChanged: widget.onLotNumberChanged,
          decoration: const InputDecoration(
            labelText: 'Lot 번호',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _memoController,
          onChanged: widget.onMemoChanged,
          decoration: const InputDecoration(
            labelText: '메모',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }
}
class _TagInfoSection extends StatelessWidget {
  final List<Tag> allTags;
  final Set<int> selectedTagIds;
  final VoidCallback onAddTagPressed;
  final ValueChanged<int> onRemoveTag;

  const _TagInfoSection({
    required this.allTags,
    required this.selectedTagIds,
    required this.onAddTagPressed,
    required this.onRemoveTag,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTags = allTags.where((tag) => selectedTagIds.contains(tag.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('태그', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedTags.isEmpty)
                const Text('선택된 태그가 없습니다.')
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedTags
                      .map((tag) => ColoredTagChip(
                            tag: tag,
                            showDeleteButton: true,
                            onDeleted: () => onRemoveTag(tag.id),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: onAddTagPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('태그 추가 또는 수정'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}