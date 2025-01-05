import 'package:get_it/get_it.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/home/presentation/view_model/home_cubit.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependency() async {
  // Initialize home dependencies first
  await _initHomeDependencies();

  // Initialize registration and login dependencies after home
  await _initRegisterDependencies();
  await _initLoginDependencies();

  // Initialize splash screen dependencies after login and registration
  await _initSplashScreenDependencies();
}

Future<void> _initHomeDependencies() async {
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

Future<void> _initRegisterDependencies() async {
  // Register RegistrationBloc and inject LoginBloc into it
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(), // Inject LoginBloc
  );
}

Future<void> _initLoginDependencies() async {
  // Register LoginBloc after RegistrationBloc is already registered
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: HomeCubit(), // Inject RegistrationBloc
    ),
  );
}

Future<void> _initSplashScreenDependencies() async {
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<LoginBloc>()),
  );
}
