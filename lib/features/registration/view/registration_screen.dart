// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:moments/features/login/views/login_screen.dart';
// ignore: depend_on_referenced_packages

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final Color primaryColor = Color(0xFF63C57A);
  final Color bgColor = Color(0xFF121212);
  final Color textMutedColor = Colors.grey;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void register(username, email, password) {
    print('username: $username, email: $email, password: $password');
    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>),
      // );
    }
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
              ),
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.asset(
                  "assets/images/logo-dark.png",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                child: Text(
                  "Connect with the world around you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily:
                        'Cedarville', // Use the font family defined in pubspec.yaml
                    color: textMutedColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 45.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: "Email",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    hintStyle: TextStyle(
                        color: textMutedColor, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: textMutedColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 45.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _usernameController,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    hintText: "Username",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    hintStyle: TextStyle(
                        color: textMutedColor, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: textMutedColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 45.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _passwordController,
                  cursorColor: primaryColor,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(
                        color: textMutedColor, fontWeight: FontWeight.w300),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: textMutedColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    register(_usernameController.text, _emailController.text,
                        _passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Register",
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "OR",
                      style: TextStyle(color: textMutedColor),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: textMutedColor),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to LoginScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all<Color>(
                          Colors.transparent), // Disable highlight color
                    ),
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
