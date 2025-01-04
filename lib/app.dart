import 'package:flutter/material.dart';
import 'package:moments/core/app_theme/app_theme.dart';
import 'package:moments/features/splashscreen/splash_screen.dart';
// import 'package:moments/features/splashscreen/splash_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: getApplicationTheme(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
