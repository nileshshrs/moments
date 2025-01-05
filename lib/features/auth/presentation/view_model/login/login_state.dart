part of 'login_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
  });

  // Initial state definition
  LoginState.initial()
      : isLoading = false,
        isSuccess = false,
        errorMessage = null;

  // Simplified copyWith for state updates
  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}