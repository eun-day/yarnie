import '../../../../db/app_db.dart';

class PartManageState {
  final List<Part> parts;
  final bool isLoading;
  final String? error;

  const PartManageState({
    this.parts = const [],
    this.isLoading = false,
    this.error,
  });

  PartManageState copyWith({
    List<Part>? parts,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PartManageState(
      parts: parts ?? this.parts,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
