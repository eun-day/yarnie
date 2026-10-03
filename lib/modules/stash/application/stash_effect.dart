import '../../../l10n/app_localizations.dart';

sealed class StashEffect {
  const StashEffect();
}

class ShowStashErrorMessage extends StashEffect {
  final String message;
  const ShowStashErrorMessage(this.message);
}

class ShowStashLocalizedErrorMessage extends StashEffect {
  final String Function(AppLocalizations l10n) messageBuilder;
  const ShowStashLocalizedErrorMessage(this.messageBuilder);
}

class ShowStashLocalizedSuccessMessage extends StashEffect {
  final String Function(AppLocalizations l10n) messageBuilder;
  const ShowStashLocalizedSuccessMessage(this.messageBuilder);
}

class StashYarnCreated extends StashEffect {
  final int yarnId;
  final bool isFromSelectionSheet;
  const StashYarnCreated(this.yarnId, {this.isFromSelectionSheet = false});
}

class StashYarnUpdated extends StashEffect {
  final int yarnId;
  const StashYarnUpdated(this.yarnId);
}

/// 실 등록/수정 실패 (폼을 닫지 않고 저장 버튼을 다시 활성화)
class StashYarnSaveFailed extends StashEffect {
  const StashYarnSaveFailed();
}

class StashYarnDeleted extends StashEffect {
  const StashYarnDeleted();
}

class ShowAssignStashTagsDialog extends StashEffect {
  final int yarnId;
  final List<int> currentTagIds;
  const ShowAssignStashTagsDialog(this.yarnId, this.currentTagIds);
}
