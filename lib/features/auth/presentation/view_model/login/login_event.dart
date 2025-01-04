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
}

// class NavigateToLoginScreenEvent extends LoginEvent {
//   final BuildContext context;
//   final Widget destination;

//   const NavigateToLoginScreenEvent({
//     required this.context,
//     required this.destination,
//   });
// }
