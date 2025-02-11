import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/use_case/get_all_user_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetAllUserUsecase _getAllUserUsecase;
  SearchBloc({
    required GetAllUserUsecase getAllUserUsecase,
  })  : _getAllUserUsecase = getAllUserUsecase,
        super(SearchState.initial()) {
    on<LoadUsers>(_loadUsers);
    add(LoadUsers());
  }

  Future<void> _loadUsers(LoadUsers event, Emitter<SearchState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final results = await _getAllUserUsecase.call();

    results.fold(
        (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
        (users) {
      print(users);
      emit(state.copyWith(isLoading: false, isSuccess: true, users: users));
    });
  }
}
