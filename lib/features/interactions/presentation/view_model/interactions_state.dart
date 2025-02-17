part of 'interactions_bloc.dart';

class InteractionsState {
  final Map<String, LikeDTO> likes; // ✅ Ensure likes is always a Map
  final bool isLoading;
  final bool isSuccess;

  InteractionsState({
    required this.likes,
    required this.isLoading,
    required this.isSuccess,
  });

  factory InteractionsState.initial() {
    return InteractionsState(
      likes: {}, // ✅ Initialize as an empty Map to prevent null issues
      isLoading: false,
      isSuccess: false,
    );
  }

  InteractionsState copyWith({
    Map<String, LikeDTO>? likes,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return InteractionsState(
      likes: likes ?? this.likes, // ✅ Ensure likes is never null
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [likes, isLoading, isSuccess];
}
