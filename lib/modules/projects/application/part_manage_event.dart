import '../../../../db/app_db.dart';

sealed class PartManageEvent {
  const PartManageEvent();
}

class LoadParts extends PartManageEvent {
  final int projectId;
  const LoadParts(this.projectId);
}

class PartsUpdated extends PartManageEvent {
  final List<Part> parts;
  const PartsUpdated(this.parts);
}

class CreatePart extends PartManageEvent {
  final int projectId;
  final String name;
  const CreatePart(this.projectId, this.name);
}

class UpdatePart extends PartManageEvent {
  final int partId;
  final String name;
  const UpdatePart(this.partId, this.name);
}

class ReorderParts extends PartManageEvent {
  final int projectId;
  final List<int> partIds;
  const ReorderParts(this.projectId, this.partIds);
}

class DeletePart extends PartManageEvent {
  final int partId;
  const DeletePart(this.partId);
}

class ShowPartManageError extends PartManageEvent {
  final String message;
  const ShowPartManageError(this.message);
}
