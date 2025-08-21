import 'package:flutter/material.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _lotNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['뜨개', '자수', '퀼트', '기타'];

  String? _selectedNeedleType;
  String? _selectedNeedleSize;

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
      '10.0mm'
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
      '10/0호 (6.0mm)'
    ],
  };

  final FocusNode _projectNameFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();
  final FocusNode _needleTypeFocusNode = FocusNode();
  final FocusNode _needleSizeFocusNode = FocusNode();
  final FocusNode _lotNumberFocusNode = FocusNode();
  final FocusNode _notesFocusNode = FocusNode();

  Future<void> _ensureVisible(FocusNode node) async {
    // 키보드 인셋 적용 타이밍 대기
    await Future.delayed(const Duration(milliseconds: 220));
    // FocusNode가 붙어있는 BuildContext 획득 (없으면 현재 포커스에서 보조 획득)
    final ctx = node.context ?? FocusManager.instance.primaryFocus?.context;
    if (!mounted || ctx == null) return;

    await Scrollable.ensureVisible(
      // ignore: use_build_context_synchronously
      ctx,
      alignment: 0.2, // 너무 위로 붙지 않게
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  String? _projectNameErrorText;

  @override
  void initState() {
    super.initState();
    _projectNameFocusNode.addListener(() {
      if (_projectNameFocusNode.hasFocus) _ensureVisible(_projectNameFocusNode);
    });
    _categoryFocusNode.addListener(() {
      if (_categoryFocusNode.hasFocus) _ensureVisible(_categoryFocusNode);
    });
    _needleTypeFocusNode.addListener(() {
      if (_needleTypeFocusNode.hasFocus) _ensureVisible(_needleTypeFocusNode);
    });
    _needleSizeFocusNode.addListener(() {
      if (_needleSizeFocusNode.hasFocus) _ensureVisible(_needleSizeFocusNode);
    });
    _lotNumberFocusNode.addListener(() {
      if (_lotNumberFocusNode.hasFocus) _ensureVisible(_lotNumberFocusNode);
    });
    _notesFocusNode.addListener(() {
      if (_notesFocusNode.hasFocus) _ensureVisible(_notesFocusNode);
    });
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _lotNumberController.dispose();
    _notesController.dispose();
    _projectNameFocusNode.dispose();
    _categoryFocusNode.dispose();
    _needleTypeFocusNode.dispose();
    _needleSizeFocusNode.dispose();
    _lotNumberFocusNode.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('새 프로젝트 생성')),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // 빈 공간 탭도 감지
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
                focusNode: _projectNameFocusNode,
                decoration: InputDecoration(
                  labelText: '프로젝트 이름',
                  border: const OutlineInputBorder(),
                  errorText: _projectNameErrorText,
                ),
                onChanged: (value) {
                  if (_projectNameErrorText != null) {
                    setState(() {
                      _projectNameErrorText = null;
                    });
                  }
                },
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_categoryFocusNode),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                focusNode: _categoryFocusNode,
                hint: const Text('카테고리 선택'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).requestFocus(_needleTypeFocusNode);
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((
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
                value: _selectedNeedleType,
                focusNode: _needleTypeFocusNode,
                hint: const Text('바늘 종류 선택'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNeedleType = newValue;
                    _selectedNeedleSize = null;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).requestFocus(_needleSizeFocusNode);
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
                value: _selectedNeedleSize,
                focusNode: _needleSizeFocusNode,
                hint: const Text('바늘 사이즈 선택'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: _selectedNeedleType == null
                    ? null
                    : (String? newValue) {
                        setState(() {
                          _selectedNeedleSize = newValue;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_lotNumberFocusNode);
                        });
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
                focusNode: _lotNumberFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Lot Number',
                  border: OutlineInputBorder(),
                ),
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_notesFocusNode),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _notesController,
                focusNode: _notesFocusNode,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: '메모',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_projectNameController.text.trim().isEmpty) {
                    setState(() {
                      _projectNameErrorText = '이름을 작성해주세요';
                    });
                    FocusScope.of(context).requestFocus(_projectNameFocusNode);
                  } else {
                    appDb.createProject(
                      name: _projectNameController.text,
                      category: _selectedCategory,
                      needleType: _selectedNeedleType,
                      needleSize: _selectedNeedleSize,
                      lotNumber: _lotNumberController.text,
                      memo: _notesController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('프로젝트 생성'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
