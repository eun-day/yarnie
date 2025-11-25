sealed class ProjectFormEffect {
  const ProjectFormEffect();
}

/// 프로젝트 상세 화면으로 이동 (생성 성공 시)
class GoToProjectDetail extends ProjectFormEffect {
  final int projectId;
  const GoToProjectDetail(this.projectId);
}

/// 프로젝트 수정 폼 닫기 (수정 성공 시)
class CloseEditForm extends ProjectFormEffect {
  const CloseEditForm();
}

/// 에러 메시지 표시
class ShowProjectFormErrorMessage extends ProjectFormEffect {
  final String message;
  const ShowProjectFormErrorMessage(this.message);
}

/// 성공 메시지 표시
class ShowProjectFormSuccessMessage extends ProjectFormEffect {
  final String message;
  const ShowProjectFormSuccessMessage(this.message);
}