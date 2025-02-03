part of 'post_bloc.dart';

class PostState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore; // New flag for pagination loading
  final bool isSuccess;
  final String? error;
  final List<String>? images;
  final List<PostDTO>? posts;
  final int currentPage; // Tracks pagination
  final bool hasMore; // Determines if more posts are available

  const PostState({
    required this.isLoading,
    required this.isLoadingMore,
    required this.isSuccess,
    this.images,
    this.error,
    this.posts,
    required this.currentPage,
    required this.hasMore,
  });

  factory PostState.initial() {
    return PostState(
      isLoading: false,
      isLoadingMore: false,
      isSuccess: false,
      images: [],
      posts: [],
      currentPage: 1,
      hasMore: true,
    );
  }

  PostState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSuccess,
    List<String>? images,
    String? error,
    List<PostDTO>? posts,
    int? currentPage,
    bool? hasMore,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSuccess: isSuccess ?? this.isSuccess,
      images: images ?? this.images,
      error: error ?? this.error,
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isLoadingMore, isSuccess, images, error, posts, currentPage, hasMore];
}
