part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final UserEntity? user;
  final List<PostApiModel>? posts;

  const ProfileState({
    required this.isLoading,
    required this.isSuccess,
    this.user,
    this.posts,
  });

  ProfileState.initial()
      : isLoading = false,
        isSuccess = false,
        user = null,
        posts = [];

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    UserEntity? user,
    List<PostApiModel>? posts, // Fixed: changed to List<PostApiModel>
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user,
      posts: posts ?? this.posts, // Fixed: Included posts
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, user, posts]; // Fixed: Included posts
}
