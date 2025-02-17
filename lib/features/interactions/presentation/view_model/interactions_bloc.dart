import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/domain/usecase/get_likes_usecase.dart';
import 'package:moments/features/interactions/domain/usecase/toggle_like_usecase.dart';

part 'interactions_event.dart';
part 'interactions_state.dart';

class InteractionsBloc extends Bloc<InteractionsEvent, InteractionsState> {
  final ToggleLikeUsecase _toggleLikeUsecase;
  final GetLikesUsecase _getLikesUsecase;
  InteractionsBloc(
      {required ToggleLikeUsecase toggleLikeUsecase,
      required GetLikesUsecase getLikesUsecase})
      : _toggleLikeUsecase = toggleLikeUsecase,
        _getLikesUsecase = getLikesUsecase,
        super(InteractionsState.initial()) {
    on<ToggleLikes>(_toggleLikes);
    on<GetPostLikes>(_getPostLikes);
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
      print("toggling likes");
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
        // ✅ Ensure likes map is always initialized before updating
        final updatedLikes = Map<String, LikeDTO>.from(state.likes);
        updatedLikes[event.postID] = likes; // ✅ Store likes manually

        emit(state.copyWith(likes: updatedLikes));
      },
    );
  }
}
