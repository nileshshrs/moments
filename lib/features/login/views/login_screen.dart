// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color primaryColor = Color(0xFF63C57A);

  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(usernameOrEmail, password) {
    print('username: $usernameOrEmail, password: $password');
    if (usernameOrEmail.isNotEmpty && password.isNotEmpty) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) =>),
      // );
    }
    _usernameOrEmailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "assets/images/logo-light.png",
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
                    color: Colors.black54,
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
                  cursorColor: primaryColor,
                  controller: _usernameOrEmailController,
                  decoration: InputDecoration(
                    hintText: "username or email",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
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
                  controller: _passwordController,
                  cursorColor: primaryColor,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "password",
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
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
                    login(_usernameOrEmailController.text,
                        _passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Login",
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all<Color>(
                          Colors.transparent), // Disable highlight color
                    ),
                    child: Text(
                      "forgot password?",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 17),
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all<Color>(
                          Colors.transparent), // Disable highlight color
                    ),
                    child: Text(
                      "Sign up",
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
