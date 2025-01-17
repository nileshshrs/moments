import 'package:get_it/get_it.dart';
import 'package:moments/core/network/hive_service.dart';
import 'package:moments/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:moments/features/auth/data/repository/user_local_repository.dart';
import 'package:moments/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:moments/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependency() async {
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

Future<void> _initHomeDependencies() async {
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(),
  );
}

Future<void> _initRegisterDependencies() async {
  // Register RegistrationBloc and inject LoginBloc into it

  if(!getIt.isRegistered<UserLocalDatasource>()){
      getIt.registerFactory<UserLocalDatasource>(
    () => UserLocalDatasource(getIt()),
  );
  }

  getIt.registerLazySingleton<UserLocalRepository>(() =>
      UserLocalRepository(userLocalDataSource: getIt<UserLocalDatasource>()));

  getIt.registerLazySingleton<CreateUserUsecase>(
      () => CreateUserUsecase(userRepository: getIt<UserLocalRepository>()));

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(
      createUserUsecase: getIt<CreateUserUsecase>(),
    ), // Inject LoginBloc
  );
}

Future<void> _initLoginDependencies() async {

  getIt.registerLazySingleton<LoginUserUsecase>(
      () => LoginUserUsecase(userRepository: getIt<UserLocalRepository>()));
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
