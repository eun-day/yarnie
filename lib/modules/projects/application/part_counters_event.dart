sealed class PartCountersEvent {}

class LoadPartCountersCount extends PartCountersEvent {
  final int partId;
  LoadPartCountersCount(this.partId);
}

class TotalCountUpdated extends PartCountersEvent {
  final int count;
  TotalCountUpdated(this.count);
}
