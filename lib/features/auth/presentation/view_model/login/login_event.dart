part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class NavigateToRegisterScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateToRegisterScreenEvent({
    required this.context,
    required this.destination,
  });

  @override
  List<Object> get props => [context, destination];
}

class NavigateHomeScreenEvent extends LoginEvent {
  final BuildContext context;
  final Widget destination;

  const NavigateHomeScreenEvent({
    required this.context,
    required this.destination,

  });

  @override
  List<Object> get props => [context, destination];
}

class LoginUserEvent extends LoginEvent {
  final BuildContext context;
  final String username;
  final String password;

  const LoginUserEvent({
    required this.context,
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password];
}
