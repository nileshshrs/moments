import 'package:flutter/material.dart';
import 'package:moments/features/login/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the LoginScreen after a delay of 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      // Use Navigator.pushReplacement to navigate to LoginScreen and remove the SplashScreen from the stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Image.asset(
        'assets/images/2.jpg', // Ensure the image path is correct
        width: double.infinity, // Full screen width
        height: double.infinity, // Full screen height
        fit: BoxFit.cover, // Make the image cover the full screen
      ),
    );
  }
}
