import '../../../db/app_db.dart';

/// 태그 관리 이벤트
sealed class TagsEvent {
  const TagsEvent();
}

// ============================================================
// 내부 이벤트
// ============================================================

/// 태그 목록 업데이트 (stream에서 발행)
class TagsUpdated extends TagsEvent {
  final List<Tag> tags;
  const TagsUpdated(this.tags);
}

/// 에러 발생
class ShowTagError extends TagsEvent {
  final String message;
  const ShowTagError(this.message);
}

// ============================================================
// 공개 이벤트
// ============================================================

/// 태그 목록 로드
class LoadTags extends TagsEvent {
  const LoadTags();
}

/// 태그 검색
class SearchTags extends TagsEvent {
  final String query;
  const SearchTags(this.query);
}

/// 태그 선택/해제 토글
class ToggleTagSelection extends TagsEvent {
  final int tagId;
  const ToggleTagSelection(this.tagId);
}

/// 모든 태그 선택 해제
class ClearTagSelection extends TagsEvent {
  const ClearTagSelection();
}

/// 태그 생성
class CreateTag extends TagsEvent {
  final String name;
  final int color;
  const CreateTag({required this.name, required this.color});
}

/// 태그 수정
class UpdateTag extends TagsEvent {
  final int tagId;
  final String? newName;
  final int? newColor;
  const UpdateTag({required this.tagId, this.newName, this.newColor});
}

/// 태그 삭제
class DeleteTag extends TagsEvent {
  final int tagId;
  const DeleteTag(this.tagId);
}