part of 'interactions_bloc.dart';

sealed class InteractionsEvent extends Equatable {
  const InteractionsEvent();

  @override
  List<Object> get props => [];
}

class ToggleLikes extends InteractionsEvent {
  final String userID;
  final String postID;

  const ToggleLikes({
    required this.userID,
    required this.postID,
  });

  @override
  List<Object> get props => [userID, postID];
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


