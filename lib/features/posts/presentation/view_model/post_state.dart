part of 'post_bloc.dart';

class PostState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<String>? images;
  final List<PostDTO>? posts;
  final PostDTO? post;

  const PostState({
    required this.isLoading,
    required this.isSuccess,
    this.images,
    this.error,
    this.posts,
    this.post,
  });

  factory PostState.initial() {
    return PostState(
      isLoading: false,
      isSuccess: false,
      images: [],
      posts: [],
      post: null,
    );
  }

  PostState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<String>? images,
    String? error,
    List<PostDTO>? posts,
    post
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      images: images ?? this.images,
      error: error ?? this.error,
      posts: posts ?? this.posts,
      post: post ?? this.post,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        images,
        error,
        posts,
        post
      ];
}
