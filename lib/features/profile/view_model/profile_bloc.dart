import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/use_case/get_user_profile_usecase.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_by_user_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUsecase _userProfileUsecase;
  final GetPostsByUserUsecase _getPostsByUserUsecase;

  ProfileBloc({
    required GetUserProfileUsecase userProfileUsecase,
    required GetPostsByUserUsecase getPostsByUserUsecase,
  })  : _userProfileUsecase = userProfileUsecase,
        _getPostsByUserUsecase = getPostsByUserUsecase,
        super(ProfileState.initial()) {
    on<LoadProfile>(_loadProfile);
    on<LoadUserPosts>(_loadUserPosts);

    add(LoadProfile()); // Automatically loads the profile on initialization
    add(LoadUserPosts()); // Automatically loads the posts on initialization
  }

  Future<void> _loadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final result = await _userProfileUsecase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (user) =>
          emit(state.copyWith(isLoading: false, isSuccess: true, user: user)),
    );
  }

  Future<void> _loadUserPosts(
      LoadUserPosts event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final result = await _getPostsByUserUsecase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (posts) => emit(state.copyWith(isLoading: false, isSuccess: true, posts: posts)),
    );
  }
}
