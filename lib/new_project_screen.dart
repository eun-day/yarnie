import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/modules/projects/projects_api.dart';
import 'package:yarnie/project_detail_screen.dart';
import 'package:yarnie/widgets/colored_tag_chip.dart';
import 'package:yarnie/widgets/project_image.dart';
import 'package:yarnie/widgets/tag_selection_sheet.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/core/providers/length_unit_provider.dart';

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
    Future.microtask(
      () => ref
          .read(projectFormNotifierProvider.notifier)
          .onEvent(LoadProjectData(widget.projectId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.listen<AsyncValue<ProjectFormEffect>>(projectFormEffectsProvider, (
      _,
      asyncEffect,
    ) {
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(effect.message)));
        } else if (effect is ShowProjectFormErrorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(effect.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      });
    });

    final state = ref.watch(projectFormNotifierProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.isEditMode ? l10n.editProject : l10n.newProject,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.07,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              state.isEditMode ? l10n.editProjectDesc : l10n.newProjectDesc,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -0.15,
              ),
            ),
          ],
        ),
        toolbarHeight: 88,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).colorScheme.outline, // rgba(0,0,0,0.1)
            height: 0.7,
          ),
        ),
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
                onImageRemoved: () => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(const ImagePathChanged(null)),
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
                onLotNumberChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(LotNumberChanged(value)),
              ),
              const SizedBox(height: 24),
              _TagInfoSection(
                allTags: state.allAvailableTags,
                selectedTagIds: state.selectedTagIds,
                onAddTagPressed: () async {
                  final result = await showModalBottomSheet<Set<int>>(
                    context: context,
                    isScrollControlled: true,
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
              const SizedBox(height: 24),
              _MemoSection(
                memo: state.memo,
                onMemoChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(MemoChanged(value)),
              ),
              const SizedBox(height: 24),
              _GaugeSection(
                initialStitches: state.gaugeStitches,
                initialRows: state.gaugeRows,
                onStitchesChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(GaugeStitchesChanged(value)),
                onRowsChanged: (value) => ref
                    .read(projectFormNotifierProvider.notifier)
                    .onEvent(GaugeRowsChanged(value)),
              ),
              const SizedBox(height: 48), // Padding at bottom for scroll
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.7)),
        ),
        child: SafeArea(
          // Ensure it avoids safe area at bottom
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 0.7,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: state.isSaving
                    ? null
                    : () => ref
                          .read(projectFormNotifierProvider.notifier)
                          .onEvent(const SaveProject()),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: state.isSaving
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.surface,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          state.isEditMode ? l10n.editComplete : l10n.addComplete,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.addImage,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.05,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.imageSourceDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: -0.15,
                ),
              ),
              const SizedBox(height: 24),
              _buildImageSourceButton(
                iconPath: 'assets/icons/camera_icon.svg',
                label: l10n.cameraShot,
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              _buildImageSourceButton(
                iconPath: 'assets/icons/upload_icon.svg',
                label: l10n.gallerySelect,
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.15,
              ),
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
  final VoidCallback onImageRemoved;

  const _ProjectImageSection({
    this.imagePath,
    required this.onImagePressed,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.projectImage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.7),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  if (imagePath != null) ...[
                    // Preview Image
                    Positioned.fill(
                      child: ProjectImage(imagePath: imagePath, fit: BoxFit.cover),
                    ),
                    // Button Area Gradient
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildImageButton(
                                context,
                                icon: Icons.close,
                                label: l10n.reset,
                                onTap: onImageRemoved, // 이미지 제거 콜백
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildImageButton(
                                context,
                                icon: Icons.upload_outlined,
                                label: l10n.change,
                                onTap: onImagePressed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Placeholder
                    GestureDetector(
                      onTap: onImagePressed,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Theme.of(context).colorScheme.surface,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/image_icon.svg'),
                            const SizedBox(height: 8),
                            Text(
                              l10n.addImage,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                letterSpacing: -0.15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2), width: 0.7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.surface, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.surface,
                letterSpacing: -0.15,
              ),
            ),
          ],
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.15,
            ),
            children: <TextSpan>[
              TextSpan(text: '${l10n.projectName} '),
              const TextSpan(
                text: '*', // Red asterisk
                style: TextStyle(color: Color(0xFFD4183D)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.31,
            ),
            decoration: InputDecoration(
              hintText: l10n.projectNameHint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -0.31,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: TextInputAction.next,
          ),
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.needleType,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          context: context,
          value: needleType?.toString().split('.').last,
          itemMap: {
            for (var type in NeedleType.values)
              type.toString().split('.').last: type == NeedleType.knitting
                  ? l10n.knittingNeedle
                  : l10n.crochetNeedle,
          },
          onChanged: onNeedleTypeChanged,
          hintText: l10n.needleTypeHint,
        ),
        const SizedBox(height: 24),

        Text(
          l10n.needleSize,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          context: context,
          value: needleSize,
          itemMap: {for (var size in availableNeedleSizes) size: size},
          onChanged: onNeedleSizeChanged,
          hintText: l10n.needleSizeHint,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required T? value,
    required Map<T, String> itemMap,
    required ValueChanged<T?> onChanged,
    required String hintText,
  }) {
    final displayText = value != null ? itemMap[value] : null;

    return Builder(
      builder: (dropdownContext) {
        return GestureDetector(
          onTap: itemMap.isEmpty
              ? null
              : () async {
                  final renderBox =
                      dropdownContext.findRenderObject() as RenderBox;
                  final offset = renderBox.localToGlobal(Offset.zero);
                  final size = renderBox.size;
                  final screenWidth = MediaQuery.of(dropdownContext).size.width;

                  final result = await showMenu<T>(
                    context: dropdownContext,
                    position: RelativeRect.fromLTRB(
                      offset.dx,
                      offset.dy + size.height + 4,
                      screenWidth - offset.dx - size.width,
                      0,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                        width: 0.7,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                    constraints: BoxConstraints(
                      minWidth: size.width,
                      maxWidth: size.width,
                      maxHeight: 288,
                    ),
                    items: itemMap.entries.map((entry) {
                      return PopupMenuItem<T>(
                        value: entry.key,
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.15,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                  if (result != null) {
                    onChanged(result);
                  }
                },
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText ?? hintText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: displayText != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: itemMap.isEmpty
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onSurface,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _YarnInfoSection extends StatefulWidget {
  final String? lotNumber;
  final ValueChanged<String> onLotNumberChanged;

  const _YarnInfoSection({this.lotNumber, required this.onLotNumberChanged});

  @override
  State<_YarnInfoSection> createState() => _YarnInfoSectionState();
}

class _YarnInfoSectionState extends State<_YarnInfoSection> {
  late final TextEditingController _lotNumberController;

  @override
  void initState() {
    super.initState();
    _lotNumberController = TextEditingController(text: widget.lotNumber ?? '');
  }

  @override
  void didUpdateWidget(_YarnInfoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lotNumber != _lotNumberController.text) {
      _lotNumberController.text = widget.lotNumber ?? '';
    }
  }

  @override
  void dispose() {
    _lotNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.lotNumberLabel,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _lotNumberController,
            onChanged: widget.onLotNumberChanged,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -0.31,
            ),
            decoration: InputDecoration(
              hintText: l10n.lotNumberHint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                letterSpacing: -0.31,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: TextInputAction.next,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.lotNumberDesc,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _MemoSection extends StatefulWidget {
  final String? memo;
  final ValueChanged<String> onMemoChanged;

  const _MemoSection({this.memo, required this.onMemoChanged});

  @override
  State<_MemoSection> createState() => _MemoSectionState();
}

class _MemoSectionState extends State<_MemoSection> {
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.memo ?? '');
  }

  @override
  void didUpdateWidget(_MemoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.memo != _memoController.text) {
      _memoController.text = widget.memo ?? '';
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.memo,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 65),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _memoController,
            onChanged: widget.onMemoChanged,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
              letterSpacing: -0.31,
            ),
            decoration: InputDecoration(
              hintText: l10n.memoHint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
                letterSpacing: -0.31,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
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
    final l10n = AppLocalizations.of(context)!;
    final selectedTags = allTags
        .where((tag) => selectedTagIds.contains(tag.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tag,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 12),
        if (selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedTags
                .map(
                  (tag) => ColoredTagChip(
                    tag: tag,
                    showDeleteButton: true,
                    onDeleted: () => onRemoveTag(tag.id),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        GestureDetector(
          onTap: onAddTagPressed,
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.7),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
                const SizedBox(width: 4),
                Text(
                  l10n.tagAdd,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GaugeSection extends ConsumerStatefulWidget {
  final String? initialStitches;
  final String? initialRows;
  final ValueChanged<String> onStitchesChanged;
  final ValueChanged<String> onRowsChanged;

  const _GaugeSection({
    this.initialStitches,
    this.initialRows,
    required this.onStitchesChanged,
    required this.onRowsChanged,
  });

  @override
  ConsumerState<_GaugeSection> createState() => _GaugeSectionState();
}

class _GaugeSectionState extends ConsumerState<_GaugeSection> {
  late final TextEditingController _stitchController;
  late final TextEditingController _rowController;

  @override
  void initState() {
    super.initState();
    _stitchController = TextEditingController(
      text: widget.initialStitches ?? '',
    );
    _rowController = TextEditingController(text: widget.initialRows ?? '');
  }

  @override
  void didUpdateWidget(_GaugeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialStitches != _stitchController.text) {
      _stitchController.text = widget.initialStitches ?? '';
    }
    if (widget.initialRows != _rowController.text) {
      _rowController.text = widget.initialRows ?? '';
    }
  }

  @override
  void dispose() {
    _stitchController.dispose();
    _rowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lengthUnit = ref.watch(lengthUnitProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gauge,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lengthUnit == LengthUnit.cm ? l10n.gaugeDesc : l10n.gaugeDescInch,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _stitchController,
                        onChanged: widget.onStitchesChanged,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          letterSpacing: -0.31,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.stitchesHint,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                            letterSpacing: -0.31,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.stitchesUnit,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _rowController,
                        onChanged: widget.onRowsChanged,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          letterSpacing: -0.31,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.rowsHintGauge,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                            letterSpacing: -0.31,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.rowsUnit,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
