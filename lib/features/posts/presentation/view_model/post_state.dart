part of 'post_bloc.dart';

class PostState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<String>? images;
  final List<PostDTO>? posts;


  const PostState({
    required this.isLoading,
    required this.isSuccess,
    this.images,
    this.error,
    this.posts,

  });

  factory PostState.initial() {
    return PostState(
      isLoading: false,
      isSuccess: false,
      images: [],
      posts: [],
    );
  }

  PostState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<String>? images,
    String? error,
    List<PostDTO>? posts,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      images: images ?? this.images,
      error: error ?? this.error,
      posts: posts ?? this.posts,

    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isSuccess, images, error, posts,];
}
