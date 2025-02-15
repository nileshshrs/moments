import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/app_theme/app_theme.dart';
import 'package:moments/core/network/socket_service.dart';
import 'package:moments/features/splash/presentation/view/splash_screen.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = getIt<SocketService>();
    socketService.connect(); // Try connecting at startup
    return MaterialApp(
      theme: getApplicationTheme(),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt<SplashCubit>(), // Assuming getIt is your DI container
          ),
        ],
        child: const SplashScreen(),
      ),
    );
  }
}
