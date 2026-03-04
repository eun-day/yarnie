sealed class PartManageEffect {
  const PartManageEffect();
}

class ShowErrorEffect extends PartManageEffect {
  final String message;
  const ShowErrorEffect(this.message);
}

class PartCreatedEffect extends PartManageEffect {
  final int partId;
  const PartCreatedEffect(this.partId);
}
