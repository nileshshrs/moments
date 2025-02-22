part of 'interactions_bloc.dart';

sealed class InteractionsEvent extends Equatable {
  const InteractionsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleLikes extends InteractionsEvent {
  final String userID;
  final String postID;
  final String postOwner;

  const ToggleLikes({
    required this.userID,
    required this.postID,
    required this.postOwner,
  });

  @override
  List<Object> get props => [userID, postID, postOwner];
}

class GetPostLikes extends InteractionsEvent {
  final String postID;

  const GetPostLikes({required this.postID});

  @override
  List<Object> get props => [postID];
}

class CreateComments extends InteractionsEvent {
  final String postId;
  final String comment;

  const CreateComments({required this.postId, required this.comment});

  @override
  List<Object> get props => [postId, comment];
}

class FetchComments extends InteractionsEvent {
  final String postId;

  const FetchComments({required this.postId});
  @override
  List<Object> get props => [postId];
}

class FetchCommentCount extends InteractionsEvent {
  final String postId;

  const FetchCommentCount({required this.postId});
  @override
  List<Object> get props => [postId];
}

class DeleteComment extends InteractionsEvent {
  final String postId;
  final String commentId;

  const DeleteComment({required this.postId, required this.commentId});

  @override
  List<Object> get props => [postId, commentId];
}

class FetchFollowers extends InteractionsEvent {
  final String id;
  const FetchFollowers({required this.id});

  @override
  List<Object> get props => [id];
}

class FetchFollowings extends InteractionsEvent {
  final String id;
  const FetchFollowings({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateFollow extends InteractionsEvent {
  final String id;
  final String userId;
  const CreateFollow({required this.id, required this.userId});
  @override
  List<Object> get props => [id, userId];
}

class UnfollowUser extends InteractionsEvent {
  final String followerID;
  final String followingID;

  const UnfollowUser({required this.followerID, required this.followingID});

  @override
  List<Object> get props => [followerID, followingID];
}

class CreateNotification extends InteractionsEvent {
  final String recipient;
  final String type;
  final String? post;

  const CreateNotification(
      {required this.recipient, required this.type, this.post});

  @override
  List<Object?> get props => [recipient, type, post];
}

class GetAllNotifications extends InteractionsEvent {}

class UpdateNotifications extends InteractionsEvent{}
