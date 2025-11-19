/// 프로젝트 목록 화면 사이드 이펙트 (네비게이션, 토스트 등)
sealed class ProjectsEffect {
  const ProjectsEffect();
}

/// 프로젝트 상세 화면으로 이동
class NavigateToProjectDetail extends ProjectsEffect {
  final int projectId;
  const NavigateToProjectDetail(this.projectId);
}

/// 태그 지정 다이얼로그 표시
class ShowAssignTagsDialog extends ProjectsEffect {
  final int projectId;
  final List<int> currentTagIds;
  const ShowAssignTagsDialog(this.projectId, this.currentTagIds);
}

/// 에러 메시지 표시
class ShowErrorMessage extends ProjectsEffect {
  final String message;
  const ShowErrorMessage(this.message);
}

/// 성공 메시지 표시
class ShowSuccessMessage extends ProjectsEffect {
  final String message;
  const ShowSuccessMessage(this.message);
}
