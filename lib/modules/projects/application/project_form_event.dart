sealed class ProjectFormEvent {
  const ProjectFormEvent();
}

/// 초기 데이터 로드 (수정 모드일 경우)
class LoadProjectData extends ProjectFormEvent {
  final int? projectId; // null이면 생성 모드
  const LoadProjectData(this.projectId);
}

/// 프로젝트 이름 변경
class ProjectNameChanged extends ProjectFormEvent {
  final String name;
  const ProjectNameChanged(this.name);
}

/// 바늘 종류 변경
class NeedleTypeChanged extends ProjectFormEvent {
  final String? needleType;
  const NeedleTypeChanged(this.needleType);
}

/// 바늘 사이즈 변경
class NeedleSizeChanged extends ProjectFormEvent {
  final String? needleSize;
  const NeedleSizeChanged(this.needleSize);
}

/// 로트 번호 변경
class LotNumberChanged extends ProjectFormEvent {
  final String? lotNumber;
  const LotNumberChanged(this.lotNumber);
}

/// 메모 변경
class MemoChanged extends ProjectFormEvent {
  final String? memo;
  const MemoChanged(this.memo);
}

/// 이미지 경로 변경
class ImagePathChanged extends ProjectFormEvent {
  final String? imagePath;
  const ImagePathChanged(this.imagePath);
}

/// 태그 선택/해제 토글
class ToggleTagSelected extends ProjectFormEvent {
  final int tagId;
  const ToggleTagSelected(this.tagId);
}

/// 프로젝트 저장 (생성 또는 업데이트)
class SaveProject extends ProjectFormEvent {
  const SaveProject();
}

/// 태그 선택 화면에서 반환된 태그 ID들로 상태 업데이트
class UpdateSelectedTags extends ProjectFormEvent {
  final Set<int> tagIds;
  const UpdateSelectedTags(this.tagIds);
}