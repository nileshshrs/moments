import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/home/presentation/view_model/home_cubit.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc _registerBloc;
  final HomeCubit _homeCubit;

  LoginBloc({
    required RegisterBloc registerBloc,
    required HomeCubit homeCubit,
  })  : _registerBloc = registerBloc,
        _homeCubit = homeCubit,
        super(LoginState.initial()) {
    // Navigate to the Register Screen
    on<NavigateToRegisterScreenEvent>((event, emit) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: _registerBloc,
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
          builder: (context) => BlocProvider.value(
            value: _homeCubit,
            child: event.destination,
          ),
        ),
      );
    });

    // Handle Login Event
    on<LoginUserEvent>((event, emit) async {
      // Set loading state
      emit(state.copyWith(isLoading: true, errorMessage: null));

      try {
        // Simulate a login validation process (e.g., API call)
        await Future.delayed(const Duration(seconds: 2)); // Simulate network delay

        if (event.username == "admin" && event.password == "admin123") {
          // Successful login
          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          // Login failed
          emit(state.copyWith(
            isLoading: false,
            isSuccess: false,
            errorMessage: "Invalid email or password.",
          ));
        }
      } catch (e) {
        // Handle unexpected errors
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: "An unexpected error occurred.",
        ));
      }
    });
  }
}