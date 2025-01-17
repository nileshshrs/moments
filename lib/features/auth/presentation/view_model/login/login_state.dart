part of 'login_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
  });

  // Initial state definition
  LoginState.initial()
      : isLoading = false,
        isSuccess = false;

  // Simplified copyWith for state updates
  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
