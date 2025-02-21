import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/use_case/get_user_profile_usecase.dart';
import 'package:moments/features/auth/domain/use_case/update_user_usecase.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/use_case/get_post_by_user_id_usecase.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_by_user_usecase.dart';
import 'package:moments/features/profile/domain/usecase/get_by_user_id.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUsecase _userProfileUsecase;
  final GetPostsByUserUsecase _getPostsByUserUsecase;
  final UpdateUserUsecase _updateUserUsecase;
  final GetByUserIDUsecase _getByUserIDUsecase;
  final GetPostByUserIdUsecase _getPostByUserIdUsecase;

  ProfileBloc({
    required GetUserProfileUsecase userProfileUsecase,
    required GetPostsByUserUsecase getPostsByUserUsecase,
    required UpdateUserUsecase updateUserUsecase,
    required GetByUserIDUsecase getUserByIDUsecase,
    required GetPostByUserIdUsecase getPostByUserIdUsecase,
  })  : _userProfileUsecase = userProfileUsecase,
        _getPostsByUserUsecase = getPostsByUserUsecase,
        _updateUserUsecase = updateUserUsecase,
        _getByUserIDUsecase = getUserByIDUsecase,
        _getPostByUserIdUsecase = getPostByUserIdUsecase,
        super(ProfileState.initial()) {
    on<LoadProfile>(_loadProfile);
    on<LoadUserPosts>(_loadUserPosts);
    on<UpdateProfile>(_updateProfile);
    on<LoadProfileByID>(_getUserByID);
    on<LoadPostsByUserID>(_getPostsByUserID);

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
      (posts) =>
          emit(state.copyWith(isLoading: false, isSuccess: true, posts: posts)),
    );
  }

  Future<void> _updateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    if (state.user == null) {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      return;
    }

    // Create a new UserEntity instance with updated fields
    final updatedUser = UserEntity(
        email: event.email, // Updated email
        username: event.username, // Updated username
        fullname: event.fullname, // Use existing if null
        image: event.image,
        bio: event.bio);

    final result = await _updateUserUsecase(updatedUser);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (_) => emit(
          state.copyWith(isLoading: false, isSuccess: true, user: updatedUser)),
    );
  }

  Future<void> _getUserByID(
      LoadProfileByID event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSuccess: false, isLoading: true));

    final params = GetByuserIDParams(id: event.id);
    final results = await _getByUserIDUsecase.call(params); // Await the Future

    results.fold(
      (failure) {
        print('Failure: ${failure.message}');
        emit(
            state.copyWith(isSuccess: false, isLoading: false, userByID: null));
      },
      (userByID) {
        print("✅ User loaded: ${userByID.username}");
        emit(state.copyWith(
            isLoading: false, isSuccess: true, userByID: userByID));
        add(LoadPostsByUserID(id: userByID.userId!));
      },
    );
  }

  Future<void> _getPostsByUserID(
      LoadPostsByUserID event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSuccess: false));
    print(event.id);

    final params = GetPostByUserIdParams(id: event.id);
    final results = await _getPostByUserIdUsecase(params);

    results.fold((failure) {
      print('failure: $failure');
      emit(state.copyWith(isSuccess: false));
    }, (results) {
      emit(state.copyWith(
          isLoading: false, isSuccess: true, postsByUserID: results));
    });
  }
}
