import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drift/drift.dart' show Value;
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/l10n/app_localizations.dart';
import 'package:yarnie/model/tag_color_preset.dart';
import '../../widgets/stash_tag_selection_sheet.dart';
import 'package:yarnie/modules/stash/stash_api.dart';
import 'package:yarnie/widgets/app_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yarnie/core/utils/app_image_utils.dart';

class NewStashScreen extends ConsumerStatefulWidget {
  final int? stashYarnId;
  final bool isFromSelectionSheet;
  const NewStashScreen({super.key, this.stashYarnId, this.isFromSelectionSheet = false});

  @override
  ConsumerState<NewStashScreen> createState() => _NewStashScreenState();
}

class _NewStashScreenState extends ConsumerState<NewStashScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameCtrl = TextEditingController();
  final _yarnNameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _colorwayCtrl = TextEditingController();
  final _dyeLotCtrl = TextEditingController();
  final _skeinsCtrl = TextEditingController();
  final _lengthPerSkeinCtrl = TextEditingController();
  final _weightPerSkeinCtrl = TextEditingController();
  final _totalLengthCtrl = TextEditingController();
  final _totalWeightCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  // Focus Nodes
  final _imageFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _yarnNameFocus = FocusNode();
  final _brandFocus = FocusNode();
  final _colorwayFocus = FocusNode();
  final _dyeLotFocus = FocusNode();
  final _skeinsFocus = FocusNode();
  final _lengthPerSkeinFocus = FocusNode();
  final _weightPerSkeinFocus = FocusNode();
  final _totalLengthFocus = FocusNode();
  final _totalWeightFocus = FocusNode();
  final _locationFocus = FocusNode();
  final _notesFocus = FocusNode();
  final _tagAddFocusNode = FocusNode();
  final _yarnWeightFocus = FocusNode();

  String? _imagePath;
  String _lengthUnit = 'yards';
  String _weightUnit = 'grams';
  String? _yarnWeight; // 12가지 표준 굵기
  Set<int> _selectedTagIds = {};
  List<StashTag> _allStashTags = [];

  bool _isSaving = false;
  bool _isLoading = false;



  @override
  void initState() {
    super.initState();
    _loadTags();
    if (widget.stashYarnId != null) {
      _loadExistingYarn();
    }
  }

  Future<void> _loadTags() async {
    final tags = await appDb.getAllStashTags();
    if (mounted) {
      setState(() => _allStashTags = tags);
    }
  }

  Future<void> _loadExistingYarn() async {
    setState(() => _isLoading = true);
    final yarn = await appDb.getStashYarn(widget.stashYarnId!);
    if (yarn != null && mounted) {
      setState(() {
        _imagePath = yarn.imagePath;
        _nameCtrl.text = yarn.nickname ?? '';
        _yarnNameCtrl.text = yarn.yarnName;
        _brandCtrl.text = yarn.brandName ?? '';
        _colorwayCtrl.text = yarn.colorwayName ?? '';
        _dyeLotCtrl.text = yarn.dyeLot ?? '';
        _skeinsCtrl.text = yarn.skeins != null ? yarn.skeins.toString() : '';
        _lengthPerSkeinCtrl.text =
            yarn.yarnLengthPerSkein != null ? yarn.yarnLengthPerSkein.toString() : '';
        _weightPerSkeinCtrl.text =
            yarn.yarnWeightPerSkein != null ? yarn.yarnWeightPerSkein.toString() : '';
        _totalLengthCtrl.text =
            yarn.totalLength != null ? yarn.totalLength.toString() : '';
        _totalWeightCtrl.text =
            yarn.totalWeight != null ? yarn.totalWeight.toString() : '';
        _locationCtrl.text = yarn.location ?? '';
        _notesCtrl.text = yarn.notes ?? '';
        _lengthUnit = yarn.lengthUnit;
        _weightUnit = yarn.weightUnit;
        _yarnWeight = yarn.yarnWeight;
        if (yarn.tagIds != null && yarn.tagIds!.isNotEmpty) {
          try {
            _selectedTagIds = (jsonDecode(yarn.tagIds!) as List).cast<int>().toSet();
          } catch (_) {}
        }
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    // text
    _nameCtrl.dispose();
    _yarnNameCtrl.dispose();
    _brandCtrl.dispose();
    _colorwayCtrl.dispose();
    _dyeLotCtrl.dispose();
    _skeinsCtrl.dispose();
    _lengthPerSkeinCtrl.dispose();
    _weightPerSkeinCtrl.dispose();
    _totalLengthCtrl.dispose();
    _totalWeightCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();

    // focus
    _imageFocus.dispose();
    _nameFocus.dispose();
    _yarnNameFocus.dispose();
    _brandFocus.dispose();
    _colorwayFocus.dispose();
    _dyeLotFocus.dispose();
    _skeinsFocus.dispose();
    _lengthPerSkeinFocus.dispose();
    _weightPerSkeinFocus.dispose();
    _totalLengthFocus.dispose();
    _totalWeightFocus.dispose();
    _locationFocus.dispose();
    _notesFocus.dispose();
    _tagAddFocusNode.dispose();
    _yarnWeightFocus.dispose();
    super.dispose();
  }

  // ============================================================
  // 양방향 자동 계산 로직
  // ============================================================
  void _onSkeinsOrSpecChanged() {
    final skeins = double.tryParse(_skeinsCtrl.text);
    if (skeins == null) return;

    // 무게 자동 계산
    final weightPerSkein = double.tryParse(_weightPerSkeinCtrl.text);
    if (weightPerSkein != null) {
      final totalWeight = double.parse((skeins * weightPerSkein).toStringAsFixed(2));
      _totalWeightCtrl.text = totalWeight.toString();
    }

    // 길이 자동 계산
    final lengthPerSkein = double.tryParse(_lengthPerSkeinCtrl.text);
    if (lengthPerSkein != null) {
      final totalLength = double.parse((skeins * lengthPerSkein).toStringAsFixed(2));
      _totalLengthCtrl.text = totalLength.toString();
    }
  }

  void _onTotalWeightChanged() {
    final totalWeight = double.tryParse(_totalWeightCtrl.text);
    final weightPerSkein = double.tryParse(_weightPerSkeinCtrl.text);
    if (totalWeight != null && weightPerSkein != null && weightPerSkein > 0) {
      final skeins = double.parse((totalWeight / weightPerSkein).toStringAsFixed(2));
      _skeinsCtrl.text = skeins.toString();

      // 길이에 대해서도 비례하여 세팅 가능하면 자동 세팅
      final lengthPerSkein = double.tryParse(_lengthPerSkeinCtrl.text);
      if (lengthPerSkein != null) {
        final totalLength = double.parse((skeins * lengthPerSkein).toStringAsFixed(2));
        _totalLengthCtrl.text = totalLength.toString();
      }
    }
  }

  void _onTotalLengthChanged() {
    final totalLength = double.tryParse(_totalLengthCtrl.text);
    final lengthPerSkein = double.tryParse(_lengthPerSkeinCtrl.text);
    if (totalLength != null && lengthPerSkein != null && lengthPerSkein > 0) {
      final skeins = double.parse((totalLength / lengthPerSkein).toStringAsFixed(2));
      _skeinsCtrl.text = skeins.toString();

      // 무게에 대해서도 비례하여 세팅 가능하면 자동 세팅
      final weightPerSkein = double.tryParse(_weightPerSkeinCtrl.text);
      if (weightPerSkein != null) {
        final totalWeight = double.parse((skeins * weightPerSkein).toStringAsFixed(2));
        _totalWeightCtrl.text = totalWeight.toString();
      }
    }
  }

  // ============================================================
  // 단위 변환 로직
  // ============================================================
  void _changeLengthUnit(String newUnit) {
    if (_lengthUnit == newUnit) return;
    setState(() {
      _lengthUnit = newUnit;
    });

    final lengthPerSkein = double.tryParse(_lengthPerSkeinCtrl.text);
    final totalLength = double.tryParse(_totalLengthCtrl.text);

    // Yards ↔ Meters 변환 (1 Yard ≈ 0.9144 Meter)
    const factor = 0.9144;
    if (newUnit == 'meters') {
      if (lengthPerSkein != null) {
        _lengthPerSkeinCtrl.text = double.parse((lengthPerSkein * factor).toStringAsFixed(2)).toString();
      }
      if (totalLength != null) {
        _totalLengthCtrl.text = double.parse((totalLength * factor).toStringAsFixed(2)).toString();
      }
    } else {
      if (lengthPerSkein != null) {
        _lengthPerSkeinCtrl.text = double.parse((lengthPerSkein / factor).toStringAsFixed(2)).toString();
      }
      if (totalLength != null) {
        _totalLengthCtrl.text = double.parse((totalLength / factor).toStringAsFixed(2)).toString();
      }
    }
  }

  void _changeWeightUnit(String newUnit) {
    if (_weightUnit == newUnit) return;
    setState(() {
      _weightUnit = newUnit;
    });

    final weightPerSkein = double.tryParse(_weightPerSkeinCtrl.text);
    final totalWeight = double.tryParse(_totalWeightCtrl.text);

    // Grams ↔ Ounces 변환 (1 Ounce ≈ 28.3495 Gram)
    const factor = 28.3495;
    if (newUnit == 'ounces') {
      if (weightPerSkein != null) {
        _weightPerSkeinCtrl.text = double.parse((weightPerSkein / factor).toStringAsFixed(2)).toString();
      }
      if (totalWeight != null) {
        _totalWeightCtrl.text = double.parse((totalWeight / factor).toStringAsFixed(2)).toString();
      }
    } else {
      if (weightPerSkein != null) {
        _weightPerSkeinCtrl.text = double.parse((weightPerSkein * factor).toStringAsFixed(2)).toString();
      }
      if (totalWeight != null) {
        _totalWeightCtrl.text = double.parse((totalWeight * factor).toStringAsFixed(2)).toString();
      }
    }
  }

  // ============================================================
  // 저장 로직
  // ============================================================
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    String? oldImagePath;
    if (widget.stashYarnId != null) {
      final existing = await appDb.getStashYarn(widget.stashYarnId!);
      oldImagePath = existing?.imagePath;
    }

    String? persistedImagePath;
    if (_imagePath == null) {
      if (oldImagePath != null) {
        await AppImageUtils.deleteImage(oldImagePath);
      }
    } else if (!_imagePath!.startsWith('/')) {
      persistedImagePath = _imagePath;
    } else {
      persistedImagePath = await AppImageUtils.persistImage(_imagePath!, subDir: 'stash_images');
      if (oldImagePath != null && oldImagePath != persistedImagePath) {
        await AppImageUtils.deleteImage(oldImagePath);
      }
    }

    final tagsJson = _selectedTagIds.isEmpty ? null : jsonEncode(_selectedTagIds.toList());

    final companion = StashYarnsCompanion(
      id: widget.stashYarnId != null ? Value(widget.stashYarnId!) : const Value.absent(),
      imagePath: Value(persistedImagePath),
      nickname: Value(_nameCtrl.text.isEmpty ? null : _nameCtrl.text),
      yarnName: Value(_yarnNameCtrl.text),
      brandName: Value(_brandCtrl.text.isEmpty ? null : _brandCtrl.text),
      colorwayName: Value(_colorwayCtrl.text.isEmpty ? null : _colorwayCtrl.text),
      dyeLot: Value(_dyeLotCtrl.text.isEmpty ? null : _dyeLotCtrl.text),
      skeins: Value(double.tryParse(_skeinsCtrl.text)),
      yarnLengthPerSkein: Value(double.tryParse(_lengthPerSkeinCtrl.text)),
      yarnWeightPerSkein: Value(double.tryParse(_weightPerSkeinCtrl.text)),
      totalLength: Value(double.tryParse(_totalLengthCtrl.text)),
      totalWeight: Value(double.tryParse(_totalWeightCtrl.text)),
      lengthUnit: Value(_lengthUnit),
      weightUnit: Value(_weightUnit),
      yarnWeight: Value(_yarnWeight),
      location: Value(_locationCtrl.text.isEmpty ? null : _locationCtrl.text),
      notes: Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
      tagIds: Value(tagsJson),
      createdAt: widget.stashYarnId == null
          ? Value(DateTime.now().toUtc())
          : const Value.absent(),
    );

    if (widget.stashYarnId == null) {
      ref.read(stashProvider.notifier).onEvent(CreateStashYarnEvent(companion, isFromSelectionSheet: widget.isFromSelectionSheet));
    } else {
      ref.read(stashProvider.notifier).onEvent(UpdateStashYarnEvent(companion));
    }

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      _nameFocus.requestFocus();
    }
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
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
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
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.imageSourceDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              _buildImageSourceButton(
                icon: Icons.camera_alt_outlined,
                label: l10n.cameraShot,
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              _buildImageSourceButton(
                icon: Icons.photo_library_outlined,
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
    required IconData icon,
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
            Icon(icon, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final Map<String, String> yarnWeightMap = {
      'Thread': l10n.weightThread,
      'Cobweb': l10n.weightCobweb,
      'Lace': l10n.weightLace,
      'Light Fingering': l10n.weightLightFingering,
      'Fingering (14 wpi)': l10n.weightFingering,
      'Sport (12 wpi)': l10n.weightSport,
      'DK (11 wpi)': l10n.weightDK,
      'Worsted (9 wpi)': l10n.weightWorsted,
      'Aran (8 wpi)': l10n.weightAran,
      'Bulky (7 wpi)': l10n.weightBulky,
      'Super Bulky (5-6 wpi)': l10n.weightSuperBulky,
      'Jumbo (0-4 wpi)': l10n.weightJumbo,
    };

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
              widget.stashYarnId == null ? l10n.newStash : l10n.editStash,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        toolbarHeight: 88,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Theme.of(context).colorScheme.outline,
            height: 0.7,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. 실 공식 이름 (제품명) [필수]
                _buildTextField(
                  label: l10n.yarnName,
                  hint: l10n.yarnNameHint,
                  controller: _yarnNameCtrl,
                  focusNode: _yarnNameFocus,
                  nextFocus: _imageFocus,
                  isRequired: true,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n.enterProjectName; // "이름을 입력해주세요" 번역 재활용
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 2. 실 이미지 업로드 영역
                _buildImageSection(l10n),
                const SizedBox(height: 24),

                // 3. 실 별칭 (이름)
                _buildTextField(
                  label: l10n.stashName,
                  hint: l10n.stashNameHint,
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  nextFocus: _brandFocus,
                ),
                const SizedBox(height: 24),

                // 4. 브랜드 / 제조사
                _buildTextField(
                  label: l10n.brandName,
                  hint: l10n.brandNameHint,
                  controller: _brandCtrl,
                  focusNode: _brandFocus,
                  nextFocus: _colorwayFocus,
                ),
                const SizedBox(height: 24),

                // 5. 색상명 (색상번호)
                _buildTextField(
                  label: l10n.colorwayName,
                  hint: l10n.colorwayNameHint,
                  controller: _colorwayCtrl,
                  focusNode: _colorwayFocus,
                  nextFocus: _dyeLotFocus,
                ),
                const SizedBox(height: 24),

                // 6. 염색 로트 (탕 번호)
                _buildTextField(
                  label: l10n.dyeLot,
                  hint: l10n.dyeLotHint,
                  controller: _dyeLotCtrl,
                  focusNode: _dyeLotFocus,
                  nextFocus: _yarnWeightFocus,
                ),
                const SizedBox(height: 24),

                // 7. 실 굵기 표준 드롭다운 (Ravelry 12종)
                _buildDropdownSection<String>(
                  label: l10n.yarnWeight,
                  value: _yarnWeight,
                  itemMap: yarnWeightMap,
                  onChanged: (val) {
                    setState(() {
                      _yarnWeight = val;
                    });
                    _skeinsFocus.requestFocus();
                  },
                  hint: l10n.selectYarnWeight,
                  focusNode: _yarnWeightFocus,
                ),
                const SizedBox(height: 24),

                // 8. 수량 & 규격 세션 (양방향 연산 폼)
                _buildQuantitySection(l10n),
                const SizedBox(height: 24),

                // 9. 보관 위치
                _buildTextField(
                  label: l10n.location,
                  hint: l10n.locationHint,
                  controller: _locationCtrl,
                  focusNode: _locationFocus,
                  nextFocus: _tagAddFocusNode,
                ),
                const SizedBox(height: 24),

                // 10. 태그 정보
                _buildTagSection(l10n),
                const SizedBox(height: 24),

                // 11. 자유 메모 (성분 비율 등 적도록 유도)
                _buildTextField(
                  label: l10n.memo,
                  hint: l10n.notesHint,
                  controller: _notesCtrl,
                  focusNode: _notesFocus,
                  maxLines: 4,
                ),
                const SizedBox(height: 48),
              ],
            ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(widget.stashYarnId == null ? l10n.addComplete : l10n.editComplete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // UI 컴포넌트 빌더들
  // ============================================================

  Widget _buildImageSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.yarnImage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 12),
        FractionallySizedBox(
          widthFactor: 2 / 3,
          alignment: Alignment.centerLeft,
          child: Focus(
            focusNode: _imageFocus,
            child: ListenableBuilder(
              listenable: _imageFocus,
              builder: (context, child) {
                final isFocused = _imageFocus.hasFocus;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isFocused ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                      width: isFocused ? 2.0 : 0.7,
                    ),
                  ),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_imagePath != null) ...[
                        // Preview Image
                        GestureDetector(
                          onTap: () => _showImageSourceSheet(context),
                          child: AppImage(imagePath: _imagePath, fit: BoxFit.cover),
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
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildImageButton(
                                    icon: Icons.close,
                                    label: l10n.reset,
                                    onTap: () => setState(() => _imagePath = null),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildImageButton(
                                    icon: Icons.upload_outlined,
                                    label: l10n.change,
                                    onTap: () => _showImageSourceSheet(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        // Empty state trigger button
                        GestureDetector(
                          onTap: () => _showImageSourceSheet(context),
                          child: Container(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/image_icon.svg'),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.addImage,
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
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.surface.withOpacity(0.2), width: 0.7),
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



  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    bool isRequired = false,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            children: [
              TextSpan(text: label),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            maxLines: maxLines,
            keyboardType: keyboardType,
            textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
            style: const TextStyle(fontSize: 15),
            onTap: () {
              if (keyboardType.toString().contains('number')) {
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              }
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              border: InputBorder.none,
              isDense: true,
            ),
            validator: validator,
            onChanged: (_) => onChanged?.call(),
            onFieldSubmitted: (_) {
              if (nextFocus != null) {
                nextFocus.requestFocus();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSection<T>({
    required String label,
    required T? value,
    required Map<T, String> itemMap,
    required ValueChanged<T?> onChanged,
    required String hint,
    required FocusNode focusNode,
  }) {
    final displayText = value != null ? itemMap[value] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (dropdownContext) {
            return Focus(
              focusNode: focusNode,
              child: ListenableBuilder(
                listenable: focusNode,
                builder: (context, child) {
                  final isFocused = focusNode.hasFocus;
                  return GestureDetector(
                    onTap: itemMap.isEmpty
                        ? null
                        : () async {
                            final renderBox = dropdownContext.findRenderObject() as RenderBox;
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
                        border: isFocused 
                            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5) 
                            : Border.all(color: Colors.transparent, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayText ?? hint,
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
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuantitySection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 타이틀 & 단위 선택
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quantityAndSpec,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildUnitSelector(
                    current: _lengthUnit,
                    options: {'yards': l10n.yards, 'meters': l10n.meters},
                    onChanged: _changeLengthUnit,
                  ),
                  const SizedBox(width: 8),
                  _buildUnitSelector(
                    current: _weightUnit,
                    options: {'grams': l10n.grams, 'ounces': l10n.ounces},
                    onChanged: _changeWeightUnit,
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),

          // 1. 보유 볼 수 (Skeins)
          _buildTextField(
            label: l10n.skeins,
            hint: l10n.skeinsHint,
            controller: _skeinsCtrl,
            focusNode: _skeinsFocus,
            nextFocus: _lengthPerSkeinFocus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: _onSkeinsOrSpecChanged,
          ),
          const SizedBox(height: 16),

          // 2. 1볼당 길이 & 1볼당 무게 (Row 배치)
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: l10n.yarnLengthPerSkein,
                  hint: '0.0',
                  controller: _lengthPerSkeinCtrl,
                  focusNode: _lengthPerSkeinFocus,
                  nextFocus: _weightPerSkeinFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _onSkeinsOrSpecChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: l10n.yarnWeightPerSkein,
                  hint: '0.0',
                  controller: _weightPerSkeinCtrl,
                  focusNode: _weightPerSkeinFocus,
                  nextFocus: _totalLengthFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _onSkeinsOrSpecChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. 총 보유 길이 & 총 보유 무게 (Row 배치)
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: l10n.totalLength,
                  hint: '0.0',
                  controller: _totalLengthCtrl,
                  focusNode: _totalLengthFocus,
                  nextFocus: _totalWeightFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _onTotalLengthChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: l10n.totalWeight,
                  hint: '0.0',
                  controller: _totalWeightCtrl,
                  focusNode: _totalWeightFocus,
                  nextFocus: _locationFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: _onTotalWeightChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelector({
    required String current,
    required Map<String, String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F5),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          isDense: true,
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          items: options.entries.map((e) {
            return DropdownMenuItem<String>(
              value: e.key,
              child: Text(e.value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTagSection(AppLocalizations l10n) {
    final selectedTags = _getSelectedTags();

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
                  (tag) => _ColoredStashTagChip(
                    tag: tag,
                    showDeleteButton: true,
                    onDeleted: () {
                      setState(() {
                        _selectedTagIds.remove(tag.id);
                      });
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        Focus(
          focusNode: _tagAddFocusNode,
          child: ListenableBuilder(
            listenable: _tagAddFocusNode,
            builder: (context, child) {
              final isFocused = _tagAddFocusNode.hasFocus;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isFocused ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
                    width: isFocused ? 2.0 : 0.7,
                  ),
                ),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<Set<int>>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => StashTagSelectionSheet(
                    initialSelectedIds: _selectedIdsCopy(),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _selectedTagIds = result;
                  });
                  _loadTags();
                }
                _tagAddFocusNode.requestFocus();
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
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
          ),
        ),
      ],
    );
  }

  Set<int> _selectedIdsCopy() => {..._selectedTagIds};

  List<StashTag> _getSelectedTags() {
    return _allStashTags.where((t) => _selectedTagIds.contains(t.id)).toList();
  }
}

class _ColoredStashTagChip extends StatelessWidget {
  const _ColoredStashTagChip({
    required this.tag,
    this.onDeleted,
    this.showDeleteButton = false,
  });

  final StashTag tag;
  final VoidCallback? onDeleted;
  final bool showDeleteButton;

  @override
  Widget build(BuildContext context) {
    final tagColorValue = tag.color;
    final tagColor = Color(tagColorValue);
    
    final presetTextColor = TagColorPreset.getTextColor(tagColorValue);
    final textColor = presetTextColor ?? (ThemeData.estimateBrightnessForColor(tagColor) == Brightness.dark
            ? Theme.of(context).colorScheme.surface
            : Colors.black87);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5, vertical: 2.5),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag.name,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
          ),
          if (showDeleteButton) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(
                Icons.close,
                size: 12,
                color: textColor,
              ),
            )
          ]
        ],
      ),
    );
  }
}
