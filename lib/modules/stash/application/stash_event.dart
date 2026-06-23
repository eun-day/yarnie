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

class ClearFilters extends StashEvent {
  const ClearFilters();
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
