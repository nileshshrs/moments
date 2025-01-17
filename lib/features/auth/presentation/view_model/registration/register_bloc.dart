import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:moments/app/widgets/flushbar_utils.dart';
import 'package:moments/features/auth/domain/use_case/create_user_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CreateUserUsecase _createUserUsecase;

  RegisterBloc({required CreateUserUsecase createUserUsecase})
      : _createUserUsecase = createUserUsecase,
        super(RegisterState.initial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  // Handle the RegisterUser event
  Future<void> _onRegisterUser(
      RegisterUser event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(isLoading: true)); // Set loading state

    // Prepare parameters for use case
    final params = CreateUserParams(
        email: event.email, username: event.username, password: event.password);

    try {
      // Call the use case to create the user
      final results = await _createUserUsecase(params);

      // Handle success or failure based on the results
      results.fold(
        (failure) {
          emit(state.copyWith(
              isLoading: false, isSuccess: false)); // Failure case
        },
        (success) {
          emit(state.copyWith(
              isLoading: false, isSuccess: true)); // Success case
          print("registered");
          FlushbarUtil.showMessage(
            context: event.context,
            message: "Registration successful.!", // Use failure.message here
            backgroundColor: Color(0xFF63C57A),
            messageColor: Colors.white,
          );
        },
      );
    } catch (e) {
      // Handle any errors during the process
      emit(state.copyWith(isLoading: false, isSuccess: false)); // Error case
    }
  }
}
