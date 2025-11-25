sealed class ProjectFormEffect {
  const ProjectFormEffect();
}

/// 프로젝트 폼 닫기 (저장 성공 시)
class CloseProjectForm extends ProjectFormEffect {
  final int projectId;
  const CloseProjectForm(this.projectId);
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