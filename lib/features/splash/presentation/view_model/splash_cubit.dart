import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/auth/presentation/view/login_screen.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/dashboard/presentation/dashboard_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._loginBloc) : super(null);

  final LoginBloc _loginBloc;

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () async {
      // Check SharedPreferences for required tokens
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = prefs.getString('refreshToken') ?? '';
      final userID = prefs.getString('userID') ?? '';

      // Navigate to Dashboard only if all tokens are available and non-empty
      if (context.mounted) {
        if (accessToken.isNotEmpty && refreshToken.isNotEmpty && userID.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardView(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: _loginBloc,
                child: const LoginScreen(),
              ),
            ),
          );
        }
      }
    });
  }
}
