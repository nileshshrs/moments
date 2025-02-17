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
