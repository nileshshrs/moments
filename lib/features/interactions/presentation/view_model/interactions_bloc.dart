import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';
import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/domain/usecase/comment_usecase/create_comment_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/comment_usecase/delete_comment_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/comment_usecase/get_comments_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/create_follow_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/get_followers_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/get_followings_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/follow_usecase/unfollow_user_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/like_usecase/get_likes_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/like_usecase/toggle_like_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'interactions_event.dart';
part 'interactions_state.dart';

class InteractionsBloc extends Bloc<InteractionsEvent, InteractionsState> {
  final ToggleLikeUsecase _toggleLikeUsecase;
  final GetLikesUsecase _getLikesUsecase;
  final CreateCommentUsecase _createCommentUsecase;
  final GetCommentsUsecase _getCommentsUsecase;
  final DeleteCommentUsecase _deleteCommentUsecase;
  final GetFollowersUsecase _getFollowersUsecase;
  final GetFollowingsUsecase _getFollowingsUsecase;
  final CreateFollowUsecase _createFollowUsecase;
  final UnfollowUserUsecase _unfollowUserUsecase;

  InteractionsBloc({
    required ToggleLikeUsecase toggleLikeUsecase,
    required GetLikesUsecase getLikesUsecase,
    required CreateCommentUsecase createCommentUsecase,
    required GetCommentsUsecase getCommentsUsecase,
    required DeleteCommentUsecase deleteCommentUsecase,
    required GetFollowersUsecase getFollowersUsecase,
    required GetFollowingsUsecase getFollowingsUsecase,
    required CreateFollowUsecase createFollowUsecase,
    required UnfollowUserUsecase unfollowUserUsecase,
  })  : _toggleLikeUsecase = toggleLikeUsecase,
        _getLikesUsecase = getLikesUsecase,
        _createCommentUsecase = createCommentUsecase,
        _getCommentsUsecase = getCommentsUsecase,
        _deleteCommentUsecase = deleteCommentUsecase,
        _getFollowersUsecase = getFollowersUsecase,
        _getFollowingsUsecase = getFollowingsUsecase,
        _createFollowUsecase = createFollowUsecase,
        _unfollowUserUsecase = unfollowUserUsecase,
        super(InteractionsState.initial()) {
    on<ToggleLikes>(_toggleLikes);
    on<GetPostLikes>(_getPostLikes);
    on<CreateComments>(_createComment);
    on<FetchComments>(_fetchComments);
    on<FetchCommentCount>(_fetchCommentCount); //  Added comment count fetching
    on<DeleteComment>(_deleteComment);
    on<FetchFollowers>(_fetchFollowers);
    on<FetchFollowings>(_fetchFollowings);
    on<CreateFollow>(_createFollow);
    on<UnfollowUser>(_unfollowUser);
  }

  Future<void> _toggleLikes(
      ToggleLikes event, Emitter<InteractionsState> emit) async {
    state.copyWith(isSuccess: false);
    final params = ToggleLikeParams(userID: event.userID, postID: event.postID);

    final results = await _toggleLikeUsecase.call(params);

    results.fold((failure) {
      print(failure);
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (_) {
      add(GetPostLikes(postID: event.postID));
      emit(state.copyWith(isLoading: false, isSuccess: true));
    });
  }

  Future<void> _getPostLikes(
      GetPostLikes event, Emitter<InteractionsState> emit) async {
    final params = GetLikesParams(id: event.postID);
    final results = await _getLikesUsecase.call(params);

    results.fold(
      (failure) {
        print(
            'Failed to fetch likes for post: ${event.postID} - Error: $failure');
      },
      (likes) {
        final updatedLikes = Map<String, LikeDTO>.from(state.likes);
        updatedLikes[event.postID] = likes;
        emit(state.copyWith(likes: updatedLikes));
      },
    );
  }

  Future<void> _createComment(
      CreateComments event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final params =
        CreateCommentParams(postID: event.postId, comment: event.comment);

    final results = await _createCommentUsecase.call(params);
    results.fold((failure) {
      print('failure $failure');
      emit(state.copyWith(isSuccess: false));
    }, (comment) {
//  Update count after creating a comment
      emit(state.copyWith(
          isSuccess: true,
          comment: comment,
          comments: [...state.comments!, comment]));
    });
    add(FetchComments(postId: event.postId));
  }

  Future<void> _fetchComments(
      FetchComments event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final params = GetCommentsParams(id: event.postId);
    final results = await _getCommentsUsecase.call(params);

    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (comments) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        comments: comments,
      ));

      add(FetchCommentCount(
          postId: event.postId)); //  Update count after fetching comments
    });
  }

  Future<void> _fetchCommentCount(
      FetchCommentCount event, Emitter<InteractionsState> emit) async {
    final params = GetCommentsParams(id: event.postId);
    final results = await _getCommentsUsecase.call(params);

    results.fold((failure) {
      print('Failed to fetch comment count: $failure');
    }, (comments) {
      final updatedCounts = Map<String, int>.from(state.commentsCount);
      updatedCounts[event.postId] = comments.length;

      emit(
          state.copyWith(commentsCount: updatedCounts)); //  Store comment count
    });
  }

  Future<void> _deleteComment(
      DeleteComment event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isSuccess: false));
    final params = DeleteCommentParams(id: event.commentId);
    final results = await _deleteCommentUsecase.call(params);
    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (_) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
      ));
      add(FetchComments(postId: event.postId));
      add(FetchCommentCount(
          postId: event.postId)); //  Update count after fetching comments
    });
  }

  Future<void> _fetchFollowers(
      FetchFollowers event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final params = GetFollowerParams(id: event.id);
    final results = await _getFollowersUsecase.call(params);

    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (followers) {
      emit(state.copyWith(
          isLoading: false, isSuccess: true, followers: followers));
    });
  }

  Future<void> _fetchFollowings(
      FetchFollowings event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final params = GetFollowerParams(id: event.id);
    final results = await _getFollowingsUsecase.call(params);

    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (followings) {
      emit(state.copyWith(
          isLoading: false, isSuccess: true, followings: followings));
    });
  }

  Future<void> _createFollow(
      CreateFollow event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final params = CreateFollowParams(id: event.id);
    final results = await _createFollowUsecase.call(params);

    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (_) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(FetchFollowers(id: event.userId));
      add(FetchFollowers(id: event.id));
      add(FetchFollowings(id: event.id));
      add(FetchFollowings(id: event.userId));
    });
  }

  Future<void> _unfollowUser(
      UnfollowUser event, Emitter<InteractionsState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final params = UnfollowUserParams(
        followerID: event.followerID, followingID: event.followingID);

    final results = await _unfollowUserUsecase.call(params);
    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isLoading: false, isSuccess: false));
    }, (_) {
      emit(state.copyWith(isLoading: false, isSuccess: true));
      add(FetchFollowers(id: event.followerID));
      add(FetchFollowers(id: event.followingID));
      add(FetchFollowings(id: event.followerID));
      add(FetchFollowings(id: event.followingID));
    });
  }
}
