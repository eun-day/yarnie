/// 태그 관리 Side Effect
sealed class TagsEffect {
  const TagsEffect();
}

/// 성공 메시지 표시
class ShowTagSuccessMessage extends TagsEffect {
  final String message;
  const ShowTagSuccessMessage(this.message);
}

/// 에러 메시지 표시
class ShowTagErrorMessage extends TagsEffect {
  final String message;
  const ShowTagErrorMessage(this.message);
}

/// 태그 편집 다이얼로그 표시
class ShowEditTagDialog extends TagsEffect {
  final int tagId;
  final String currentName;
  const ShowEditTagDialog(this.tagId, this.currentName);
}

/// 태그 삭제 확인 다이얼로그 표시
class ShowDeleteTagConfirmDialog extends TagsEffect {
  final int tagId;
  final String tagName;
  const ShowDeleteTagConfirmDialog(this.tagId, this.tagName);
}
