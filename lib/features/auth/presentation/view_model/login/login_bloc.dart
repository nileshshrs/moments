import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/app/widgets/flushbar_utils.dart';
import 'package:moments/core/network/socket_service.dart';
import 'package:moments/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/dashboard/presentation/dashboard_view.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';
import 'package:moments/features/posts/presentation/view_model/post_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final DashboardCubit _dashboardCubit;
  final LoginUserUsecase _loginUserUsecase;

  LoginBloc({
    required RegisterBloc registerBloc,
    required DashboardCubit dashboardCubit,
    required LoginUserUsecase loginUserUsecase,
  })  : _dashboardCubit = dashboardCubit,
        _loginUserUsecase = loginUserUsecase,
        super(LoginState.initial()) {
    // Navigate to the Register Screen
    on<NavigateToRegisterScreenEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RegisterBloc>()),
              BlocProvider.value(value: _dashboardCubit),
            ],
            child: event.destination,
          ),
        ),
      );
    });

    // Navigate to the Home Screen
    on<NavigateHomeScreenEvent>((event, emit) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<RegisterBloc>()),
              BlocProvider.value(value: _dashboardCubit),
              BlocProvider.value(value: getIt<PostBloc>())
            ],
            child: event.destination,
          ),
        ),
      );
    });

    // Handle Login Event
    on<LoginUserEvent>((event, emit) async {
      emit(state.copyWith(
          isLoading: true, isSuccess: false)); // Set loading state

      await Future.delayed(Duration(seconds: 2));
      // Simulate a login validation process (e.g., API call)
      final params =
          LoginParams(username: event.username, password: event.password);

      final result = await _loginUserUsecase.call(params);

      result.fold(
        (failure) {
          // On failure, update state
          emit(state.copyWith(isLoading: false, isSuccess: false));
          print("Login failed: ${failure.message}");
          FlushbarUtil.showMessage(
            context: event.context,
            message:
                "Invalid credentials, please try again!", // Use failure.message here
            backgroundColor: Color(0xFFF06360),
            messageColor: Colors.white,
          );
        },
        (token) {
          // On success, update state and navigate
          emit(state.copyWith(isLoading: false, isSuccess: true));
          final socketService = getIt<SocketService>();
          socketService.connect();

          add(NavigateHomeScreenEvent(
            context: event.context,
            destination: DashboardView(),
          ));
        },
      );
    });
  }
}
