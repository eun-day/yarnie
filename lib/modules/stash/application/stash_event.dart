import 'package:drift/drift.dart';
import '../../../db/app_db.dart';
import 'stash_state.dart';

sealed class StashEvent {
  const StashEvent();
}

class LoadStash extends StashEvent {
  const LoadStash();
}

class StashUpdatedEvent extends StashEvent {
  final List<StashYarn> yarns;
  const StashUpdatedEvent(this.yarns);
}

class ToggleTagFilter extends StashEvent {
  final int tagId;
  const ToggleTagFilter(this.tagId);
}

class SearchYarns extends StashEvent {
  final String query;
  const SearchYarns(this.query);
}

/// 보관함 태그 목록 업데이트 (stream에서 발행: 태그 이름·색 변경, 삭제 반영)
class StashTagsUpdated extends StashEvent {
  final List<StashTag> tags;
  const StashTagsUpdated(this.tags);
}

/// 굵기 필터 (null이면 전체)
class FilterYarnWeight extends StashEvent {
  final String? yarnWeight;
  const FilterYarnWeight(this.yarnWeight);
}

/// 정렬 기준 변경
class ChangeSortOrder extends StashEvent {
  final StashSortOrder sortOrder;
  const ChangeSortOrder(this.sortOrder);
}

class ClearFilters extends StashEvent {
  const ClearFilters();
}

/// 태그 선택만 해제 ("전체" 칩, 검색어·굵기 필터는 유지)
class ClearTagFilters extends StashEvent {
  const ClearTagFilters();
}

class ChangeViewMode extends StashEvent {
  final StashViewMode viewMode;
  const ChangeViewMode(this.viewMode);
}

class CreateStashYarnEvent extends StashEvent {
  final StashYarnsCompanion companion;
  final bool isFromSelectionSheet;
  const CreateStashYarnEvent(this.companion, {this.isFromSelectionSheet = false});
}

class UpdateStashYarnEvent extends StashEvent {
  final StashYarnsCompanion companion;
  const UpdateStashYarnEvent(this.companion);
}

class DeleteStashYarnEvent extends StashEvent {
  final int id;
  const DeleteStashYarnEvent(this.id);
}

class QuickAdjustSkeins extends StashEvent {
  final int yarnId;
  final double offset; // 예: +1.0 또는 -1.0, +0.1 등
  const QuickAdjustSkeins(this.yarnId, this.offset);
}

class DuplicateStashYarnEvent extends StashEvent {
  final int yarnId;
  final String suffix;
  const DuplicateStashYarnEvent(this.yarnId, this.suffix);
}

class AssignTagsToStashYarnEvent extends StashEvent {
  final int yarnId;
  final List<int> tagIds;
  const AssignTagsToStashYarnEvent(this.yarnId, this.tagIds);
}

class OpenAssignStashTagsDialog extends StashEvent {
  final int yarnId;
  const OpenAssignStashTagsDialog(this.yarnId);
}
