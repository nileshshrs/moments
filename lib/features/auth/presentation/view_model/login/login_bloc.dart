import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final RegisterBloc registrationBloc;
  LoginBloc({required this.registrationBloc}) : super(LoginInitial()) {
    on<NavigateToRegisterScreenEvent>((event, emit) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>.value(
            value: GetIt.I<LoginBloc>(), // Use LoginBloc from GetIt
            child: event.destination,
          ),
        ),
      );
    });

    // on<NavigateToLoginScreenEvent>((event, emit) {
    //   Navigator.pushReplacement(
    //     event.context,
    //     MaterialPageRoute(
    //       builder: (context) => BlocProvider<LoginBloc>.value(
    //         value: GetIt.I<LoginBloc>(), // Use LoginBloc from GetIt
    //         child: event.destination,
    //       ),
    //     ),
    //   );
    // });
  }
}
