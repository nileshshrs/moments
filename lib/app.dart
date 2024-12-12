import 'package:flutter/material.dart';
import 'package:moments/features/login/views/login_screen.dart';
import 'package:moments/features/registration/view/registration_screen.dart';
import 'package:moments/features/splashscreen/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
