import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/features/interactions/domain/usecase/toggle_like_usecase.dart';

part 'interactions_event.dart';
part 'interactions_state.dart';

class InteractionsBloc extends Bloc<InteractionsEvent, InteractionsState> {
  final ToggleLikeUsecase _toggleLikeUsecase;
  InteractionsBloc({required ToggleLikeUsecase toggleLikeUsecase})
      : _toggleLikeUsecase = toggleLikeUsecase,
        super(InteractionsState.initial()) {
    on<ToggleLikes>(_toggleLikes);
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
      emit(state.copyWith(isLoading: false, isSuccess: true));
    });
  }
}
