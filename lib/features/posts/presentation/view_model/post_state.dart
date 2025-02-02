part of 'post_bloc.dart';

class PostState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<String>? images;

  const PostState({
    required this.isLoading,
    required this.isSuccess,
    this.images,
  });

  const PostState.initial()
      : isLoading = false,
        isSuccess = false,
        images = null;

  PostState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<String>? images,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, images];
}
