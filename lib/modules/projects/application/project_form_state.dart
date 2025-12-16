import '../../../../db/app_db.dart';

/// 바늘 종류
enum NeedleType {
  knitting, // 대바늘
  crochet, // 코바늘
  // 추가될 경우 여기에 정의
}

/// 프로젝트 폼 상태 (생성/수정 화면)
class ProjectFormState {
  final int? initialProjectId; // 수정 모드일 경우 프로젝트 ID
  final Project? initialProject; // 수정 모드일 경우 초기 프로젝트 데이터

  final String name;
  final String? imagePath;
  final NeedleType? needleType;
  final String? needleSize;
  final List<String> availableNeedleSizes; // 선택된 바늘 종류에 따른 사이즈 목록
  final String? lotNumber;
  final String? memo;
  final Set<int> selectedTagIds; // 프로젝트에 지정된 태그 ID 목록
  final List<Tag> allAvailableTags; // 사용 가능한 모든 태그 목록 (검색 및 선택용)

  final bool isLoading; // 초기 데이터 로딩 중
  final bool isSaving; // 저장 중
  final String? error; // 에러 메시지
  final String? successMessage; // 성공 메시지

  const ProjectFormState({
    this.initialProjectId,
    this.initialProject,
    this.name = '',
    this.imagePath,
    this.needleType,
    this.needleSize,
    this.availableNeedleSizes = const [],
    this.lotNumber,
    this.memo,
    this.selectedTagIds = const {},
    this.allAvailableTags = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
  });

  bool get isEditMode => initialProjectId != null;
  bool get isValid => name.trim().isNotEmpty;

  // copyWith 메소드
  ProjectFormState copyWith({
    int? initialProjectId,
    Project? initialProject,
    String? name,
    String? imagePath,
    NeedleType? needleType,
    String? needleSize,
    List<String>? availableNeedleSizes,
    String? lotNumber,
    String? memo,
    Set<int>? selectedTagIds,
    List<Tag>? allAvailableTags,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
  }) {
    return ProjectFormState(
      initialProjectId: initialProjectId ?? this.initialProjectId,
      initialProject: initialProject ?? this.initialProject,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      needleType: needleType ?? this.needleType,
      needleSize: needleSize ?? this.needleSize,
      availableNeedleSizes: availableNeedleSizes ?? this.availableNeedleSizes,
      lotNumber: lotNumber ?? this.lotNumber,
      memo: memo ?? this.memo,
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      allAvailableTags: allAvailableTags ?? this.allAvailableTags,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error, // null을 전달하면 에러를 지움
      successMessage: successMessage, // null을 전달하면 성공 메시지를 지움
    );
  }
}

// TODO: 바늘 사이즈 정의 (일단 하드코딩)
final Map<NeedleType, List<String>> _needleSizes = {
  NeedleType.knitting: [
    '2.0mm', '2.25mm', '2.5mm', '2.75mm', '3.0mm', '3.25mm', '3.5mm',
    '3.75mm', '4.0mm', '4.5mm', '5.0mm', '5.5mm', '6.0mm', '6.5mm',
    '7.0mm', '8.0mm', '9.0mm', '10.0mm', '12.0mm', '15.0mm', '16.0mm',
    '19.0mm', '20.0mm', '25.0mm',
  ],
  NeedleType.crochet: [
    'B-1 (2.25mm)', 'C-2 (2.75mm)', 'D-3 (3.25mm)', 'E-4 (3.5mm)',
    'F-5 (3.75mm)', 'G-6 (4.0mm)', '7 (4.5mm)', 'H-8 (5.0mm)',
    'I-9 (5.5mm)', 'J-10 (6.0mm)', 'K-10.5 (6.5mm)', 'L-11 (8.0mm)',
    'M-13 (9.0mm)', 'N-15 (10.0mm)', 'P-16 (11.5mm)', 'Q (15.75mm)',
    'S (19.0mm)', 'T (25.0mm)',
  ],
};

List<String> getNeedleSizesForType(NeedleType? type) {
  return _needleSizes[type] ?? [];
}
