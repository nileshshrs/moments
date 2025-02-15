import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moments/app/shared_prefs/shared_prefs.dart';
import 'package:moments/core/network/api_service.dart';
import 'package:moments/core/network/hive_service.dart';
import 'package:moments/core/network/socket_service.dart';
import 'package:moments/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:moments/features/auth/data/repository/user_remote_repository.dart';
import 'package:moments/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:moments/features/auth/domain/use_case/get_all_user_usecase.dart';
import 'package:moments/features/auth/domain/use_case/get_user_profile_usecase.dart';
import 'package:moments/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:moments/features/auth/domain/use_case/update_user_usecase.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/conversation/data/data_source/remote_datasource/conversation_remote_datasource.dart';
import 'package:moments/features/conversation/data/data_source/remote_datasource/message_remote_datasource.dart';
import 'package:moments/features/conversation/data/repository/conversation_remote_repository.dart';
import 'package:moments/features/conversation/data/repository/message_remote_repository.dart';
import 'package:moments/features/conversation/domain/use_case/create_conversation_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/create_message_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_connections_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_conversations_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_messages_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/update_conversation_usecase.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/posts/data/data_source/remote_datasource/post_remote_datasource.dart';
import 'package:moments/features/posts/data/repository/post_remote_repository/post_remote_repository.dart';
import 'package:moments/features/posts/domain/use_case/create_post_usecase.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_by_user_usecase.dart';
import 'package:moments/features/posts/domain/use_case/get_posts_usecase.dart';
import 'package:moments/features/posts/domain/use_case/upload_image_usecase.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';
import 'package:moments/features/profile/view_model/profile_bloc.dart';
import 'package:moments/features/search/view_model/search_bloc.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initDependency() async {
  await _initApiService();
  await _initHiveDependencies();
  await _initSharedPreferences();
  await _initSocketService();
  // Initialize home dependencies first
  await _initHomeDependencies();

  // Initialize registration and login dependencies after home
  await _initRegisterDependencies();
  await _initLoginDependencies();

  // Initialize splash screen dependencies after login and registration
  await _initSplashScreenDependencies();

  await _initPostDependencies();
  await initSearchDependencies(); // Move this outside the other function
  await initUserProfileDependencies();
  await _initConversationDependencies();
}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initHiveDependencies() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(
      Dio(), // Pass SharedPrefs to ApiService
    ).dio,
  );
}

Future<void> _initSocketService() async {
  getIt.registerLazySingleton<SocketService>(() => SocketService());
}

Future<void> _initHomeDependencies() async {
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(),
  );
}

Future<void> _initRegisterDependencies() async {
  // Register RegistrationBloc and inject LoginBloc into it
  //local repository uncomment if needed
  // if (!getIt.isRegistered<UserLocalDatasource>()) {
  //   getIt.registerFactory<UserLocalDatasource>(
  //     () => UserLocalDatasource(getIt()),
  //   );
  // }
  //local repository uncomment if needed

  //remote data source
  if (!getIt.isRegistered<UserRemoteDatasource>()) {
    getIt.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasource(getIt<Dio>()),
    );
  }

  //local repository uncomment if needed
  // getIt.registerLazySingleton<UserLocalRepository>(() =>
  //     UserLocalRepository(userLocalDataSource: getIt<UserLocalDatasource>()));
  //local repository uncomment if needed

  // remote repository
  getIt.registerLazySingleton<UserRemoteRepository>(
    () => UserRemoteRepository(getIt<UserRemoteDatasource>()),
  );

  //local repository uncomment if needed
  // getIt.registerLazySingleton<CreateUserUsecase>(
  //     () => CreateUserUsecase(userRepository: getIt<UserLocalRepository>()));
  //local repository uncomment if needed

  getIt.registerLazySingleton<CreateUserUsecase>(
      () => CreateUserUsecase(userRepository: getIt<UserRemoteRepository>()));

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      createUserUsecase: getIt<CreateUserUsecase>(),
    ), // Inject LoginBloc
  );
}

Future<void> _initLoginDependencies() async {
  //local repository uncomment if needed
  // getIt.registerLazySingleton<LoginUserUsecase>(
  //     () => LoginUserUsecase(userRepository: getIt<UserLocalRepository>()));
  //local repository uncomment if needed
  getIt.registerLazySingleton<SharedPrefs>(
      () => SharedPrefs(getIt<SharedPreferences>()));

  getIt.registerLazySingleton<LoginUserUsecase>(
    () => LoginUserUsecase(
        userRepository: getIt<UserRemoteRepository>(),
        sharedPrefs: getIt<SharedPrefs>()),
  );
  // Register LoginBloc after RegistrationBloc is already registered
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      dashboardCubit: DashboardCubit(), // Inject RegistrationBloc
      loginUserUsecase: getIt<LoginUserUsecase>(),
    ),
  );
}

Future<void> _initSplashScreenDependencies() async {
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<LoginBloc>()),
  );
}

Future<void> _initPostDependencies() async {
  // Register remote data source
  if (!getIt.isRegistered<PostRemoteDatasource>()) {
    getIt.registerLazySingleton<PostRemoteDatasource>(
      () => PostRemoteDatasource(getIt<Dio>()),
    );
  }

  // Register remote repository
  getIt.registerLazySingleton<PostRemoteRepository>(
    () => PostRemoteRepository(getIt<PostRemoteDatasource>()),
  );

  // Register use cases
  getIt.registerLazySingleton<CreatePostUsecase>(
    () => CreatePostUsecase(getIt<PostRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<PostRemoteRepository>()),
  );

  getIt.registerLazySingleton<GetPostsUsecase>(
    () => GetPostsUsecase(getIt<PostRemoteRepository>()),
  );

  getIt.registerLazySingleton<GetPostsByUserUsecase>(
    () => GetPostsByUserUsecase(
      repository: getIt<PostRemoteRepository>(),
    ),
  );
  // Register PostBloc
  getIt.registerFactory<PostBloc>(
    () => PostBloc(
        createPostUsecase: getIt<CreatePostUsecase>(),
        uploadImageUsecase: getIt<UploadImageUsecase>(),
        getPostUsecase: getIt<GetPostsUsecase>()),
  );
}

Future<void> initSearchDependencies() async {
  if (!getIt.isRegistered<UserRemoteDatasource>()) {
    getIt.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasource(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<UserRemoteRepository>()) {
    getIt.registerLazySingleton<UserRemoteRepository>(
      () => UserRemoteRepository(getIt<UserRemoteDatasource>()),
    );
  }

  getIt.registerLazySingleton<GetAllUserUsecase>(
    () => GetAllUserUsecase(userRepository: getIt<UserRemoteRepository>()),
  );

  getIt.registerFactory<SearchBloc>(
    () => SearchBloc(getAllUserUsecase: getIt<GetAllUserUsecase>()),
  );
}

Future<void> initUserProfileDependencies() async {
  if (!getIt.isRegistered<UserRemoteDatasource>()) {
    getIt.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasource(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<UserRemoteRepository>()) {
    getIt.registerLazySingleton<UserRemoteRepository>(
      () => UserRemoteRepository(getIt<UserRemoteDatasource>()),
    );
  }

  if (!getIt.isRegistered<GetUserProfileUsecase>()) {
    getIt.registerLazySingleton<GetUserProfileUsecase>(
      () => GetUserProfileUsecase(
        userRepository: getIt<UserRemoteRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<UpdateUserUsecase>()) {
    getIt.registerLazySingleton<UpdateUserUsecase>(
      () => UpdateUserUsecase(repository: getIt<UserRemoteRepository>()),
    );
  }

  // Register ProfileBloc with the correct Usecase
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      userProfileUsecase: getIt<GetUserProfileUsecase>(),
      getPostsByUserUsecase: getIt<GetPostsByUserUsecase>(),
      updateUserUsecase: getIt<UpdateUserUsecase>(),
    ),
  );
}

Future<void> _initConversationDependencies() async {
  //  Register Conversation Dependencies
  if (!getIt.isRegistered<ConversationRemoteDatasource>()) {
    getIt.registerLazySingleton<ConversationRemoteDatasource>(
      () => ConversationRemoteDatasource(getIt<Dio>()),
    );
  }

  getIt.registerLazySingleton<ConversationRemoteRepository>(
    () => ConversationRemoteRepository(getIt<ConversationRemoteDatasource>()),
  );

  getIt.registerLazySingleton<GetConversationsUsecase>(
    () => GetConversationsUsecase(repository: getIt<ConversationRemoteRepository>()),
  );

  getIt.registerLazySingleton<GetConnectionsUsecase>(
    () => GetConnectionsUsecase(repository: getIt<ConversationRemoteRepository>()),
  );

  getIt.registerLazySingleton<CreateConversationUsecase>(
    () => CreateConversationUsecase(getIt<ConversationRemoteRepository>()),
  );

  // ✅ Register UpdateConversationUsecase
  getIt.registerLazySingleton<UpdateConversationUsecase>(
    () => UpdateConversationUsecase(getIt<ConversationRemoteRepository>()),
  );

  //  Register Message Dependencies
  if (!getIt.isRegistered<MessageRemoteDatasource>()) {
    getIt.registerLazySingleton<MessageRemoteDatasource>(
      () => MessageRemoteDatasource(getIt<Dio>()),
    );
  }

  getIt.registerLazySingleton<MessageRemoteRepository>(
    () => MessageRemoteRepository(getIt<MessageRemoteDatasource>()),
  );

  getIt.registerLazySingleton<GetMessagesUsecase>(
    () => GetMessagesUsecase(getIt<MessageRemoteRepository>()),
  );

  //  Register `CreateMessageUsecase` to ensure `.call(params)` works
  getIt.registerLazySingleton<CreateMessageUsecase>(
    () => CreateMessageUsecase(getIt<MessageRemoteRepository>()),
  );

  //  Register ConversationBloc with message fetching, creation & update support
  getIt.registerFactory<ConversationBloc>(
    () => ConversationBloc(
      getConversationUsecase: getIt<GetConversationsUsecase>(),
      getConnectionsUsecase: getIt<GetConnectionsUsecase>(),
      createConversationUsecase: getIt<CreateConversationUsecase>(),
      getMessagesUsecase: getIt<GetMessagesUsecase>(),
      createMessageUsecase: getIt<CreateMessageUsecase>(),
      updateConversationUsecase: getIt<UpdateConversationUsecase>(), // ✅ Injected Here
      socketService: getIt<SocketService>(),
    ),
  );
}

