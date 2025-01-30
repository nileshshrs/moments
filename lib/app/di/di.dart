import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moments/core/network/api_service.dart';
import 'package:moments/core/network/hive_service.dart';
import 'package:moments/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:moments/features/auth/data/repository/user_remote_repository.dart';
import 'package:moments/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:moments/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependency() async {
  await _initApiService();
  await _initHiveDependencies();
  // Initialize home dependencies first
  await _initHomeDependencies();

  // Initialize registration and login dependencies after home
  await _initRegisterDependencies();
  await _initLoginDependencies();

  // Initialize splash screen dependencies after login and registration
  await _initSplashScreenDependencies();
}

_initHiveDependencies() async {
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initApiService() {
  // Remote Data Source
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
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
    getIt.registerFactory<UserRemoteDatasource>(
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
  
  getIt.registerLazySingleton<LoginUserUsecase>(
      () => LoginUserUsecase(userRepository: getIt<UserRemoteRepository>()));
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
