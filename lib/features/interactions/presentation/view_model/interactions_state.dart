part of 'interactions_bloc.dart';

class InteractionsState extends Equatable {
  final bool isLoading;
  final bool isSuccess;

  const InteractionsState({
    required this.isLoading,
    required this.isSuccess,
  });

  factory InteractionsState.initial() {
    return const InteractionsState(isLoading: false, isSuccess: false);
  }

  InteractionsState copyWith({
    bool? isLoading,
    bool? isSuccess,
  }) {
    return InteractionsState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess];
}
