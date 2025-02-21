part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final UserEntity? user;
  final List<PostApiModel>? posts;
  final UserEntity? userByID;
  final List<PostApiModel>? postsByUserID;

  const ProfileState({
    required this.isLoading,
    required this.isSuccess,
    this.user,
    this.posts,
    this.userByID,
    this.postsByUserID,
  });

  ProfileState.initial()
      : isLoading = false,
        isSuccess = false,
        user = null,
        posts = [],
        userByID = null,
        postsByUserID = [];

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    UserEntity? user,
    List<PostApiModel>? posts, // Fixed: changed to List<PostApiModel>
    UserEntity? userByID,
    List<PostApiModel>? postsByUserID, // Fixed: changed to List<PostApiModel>
  }) {
    return ProfileState(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        user: user ?? this.user,
        posts: posts ?? this.posts, // Fixed: Included posts
        userByID: userByID ?? this.userByID,
        postsByUserID: postsByUserID ?? this.postsByUserID);
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        user,
        posts,
        userByID,
        postsByUserID
      ]; // Fixed: Included posts
}
