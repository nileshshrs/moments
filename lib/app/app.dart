import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/app_theme/app_theme.dart';
import 'package:moments/features/splash/presentation/view/splash_screen.dart';
import 'package:moments/features/splash/presentation/view_model/splash_cubit.dart';


// import 'package:moments/features/splashscreen/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getApplicationTheme(),
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: getIt<SplashCubit>(),
        child: const SplashScreen(),
      ),
    );
  }
}
