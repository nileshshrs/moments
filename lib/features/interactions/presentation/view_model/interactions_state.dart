part of 'interactions_bloc.dart';

class InteractionsState extends Equatable {
  final Map<String, LikeDTO> likes;
  final bool isLoading;
  final bool isSuccess;
  final CommentDTO? comment;
  final List<CommentDTO>? comments;
  final Map<String, int> commentsCount; // ✅ Stores comment count per post
  final List<FollowDTO>? followers;
  final List<FollowDTO>? followings;
  final List<NotificationDTO>? notifications;

  const InteractionsState({
    required this.likes,
    required this.isLoading,
    required this.isSuccess,
    this.comment,
    this.comments,
    required this.commentsCount,
    this.followers,
    this.followings,
    this.notifications,
  });

  factory InteractionsState.initial() {
    return InteractionsState(
        likes: {},
        isLoading: false,
        isSuccess: false,
        comment: null,
        comments: [],
        commentsCount: {}, // ✅ Initialize empty map to store counts
        followers: [],
        followings: [],
        notifications: []);
  }

  InteractionsState copyWith({
    Map<String, LikeDTO>? likes,
    bool? isLoading,
    bool? isSuccess,
    CommentDTO? comment,
    List<CommentDTO>? comments,
    Map<String, int>? commentsCount, // ✅ Ensure comment count updates correctly
    List<FollowDTO>? followers,
    List<FollowDTO>? followings,
    List<NotificationDTO>? notifications,
  }) {
    return InteractionsState(
      likes: likes ?? this.likes,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      comment: comment ?? this.comment,
      comments: comments ?? this.comments,
      commentsCount: commentsCount ?? this.commentsCount, // ✅ Store new counts
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [
        likes,
        isLoading,
        isSuccess,
        comment,
        comments,
        commentsCount,
        followers,
        followings,
        notifications
      ];
}
