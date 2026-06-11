sealed class PartManageEffect {
  const PartManageEffect();
}

class ShowErrorEffect extends PartManageEffect {
  final String message;
  const ShowErrorEffect(this.message);
}

class ShowLocalizedErrorEffect extends PartManageEffect {
  final String Function(dynamic l10n) messageBuilder;
  const ShowLocalizedErrorEffect(this.messageBuilder);
}

class PartCreatedEffect extends PartManageEffect {
  final int partId;
  const PartCreatedEffect(this.partId);
}
