class PartCountersState {
  final int totalCount;
  final bool isLoading;
  final String? error;

  const PartCountersState({
    this.totalCount = 0,
    this.isLoading = false,
    this.error,
  });

  PartCountersState copyWith({
    int? totalCount,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PartCountersState(
      totalCount: totalCount ?? this.totalCount,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
