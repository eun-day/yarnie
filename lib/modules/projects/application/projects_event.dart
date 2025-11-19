import '../../../db/app_db.dart';
import 'projects_state.dart';

/// 프로젝트 목록 화면 이벤트
sealed class ProjectsEvent {
  const ProjectsEvent();
}

// ============================================================
// 내부 이벤트 (stream 콜백용)
// ============================================================

/// 프로젝트 목록 업데이트 (stream에서 발행)
class ProjectsUpdated extends ProjectsEvent {
  final List<Project> projects;
  const ProjectsUpdated(this.projects);
}

/// 에러 발생 (stream에서 발행)
class ShowError extends ProjectsEvent {
  final String message;
  const ShowError(this.message);
}

// ============================================================
// 공개 이벤트 (UI에서 호출)
// ============================================================

/// 초기 로드
class LoadProjects extends ProjectsEvent {
  const LoadProjects();
}

/// 뷰 모드 변경
class ChangeViewMode extends ProjectsEvent {
  final ProjectViewMode viewMode;
  const ChangeViewMode(this.viewMode);
}

/// 태그 필터 토글 (선택/해제)
class ToggleTagFilter extends ProjectsEvent {
  final int tagId;
  const ToggleTagFilter(this.tagId);
}

/// 모든 필터 초기화
class ClearFilters extends ProjectsEvent {
  const ClearFilters();
}

/// 프로젝트 열기
class OpenProject extends ProjectsEvent {
  final int projectId;
  const OpenProject(this.projectId);
}

/// 프로젝트 복사
class DuplicateProject extends ProjectsEvent {
  final int projectId;
  const DuplicateProject(this.projectId);
}

/// 프로젝트에 태그 지정
class AssignTagsToProject extends ProjectsEvent {
  final int projectId;
  final List<int> tagIds;
  const AssignTagsToProject(this.projectId, this.tagIds);
}

/// 태그 지정 다이얼로그 열기
class OpenAssignTagsDialog extends ProjectsEvent {
  final int projectId;
  const OpenAssignTagsDialog(this.projectId);
}
