import 'package:flutter/material.dart';
import 'package:moments/features/login/views/login_screen.dart';
import 'package:moments/utils/custom_textformfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final Color primaryColor = const Color(0xFF63C57A);
  final Color bgColor = const Color(0xFF121212);
  final Color textMutedColor = Colors.grey;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Key for form validation

  // Regex patterns
  final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  final _passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,24}$');

  // Register method with validation
  void register(String username, String email, String password) {
    if (_formKey.currentState!.validate()) {
      print('username: $username, email: $email, password: $password');
      // Navigate to the next screen if necessary
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Attach form key
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 90),
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
                        fontFamily: 'Cedarville', // Custom font
                        color: textMutedColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextFormField(
                    controller: _emailController,
                    hintText: "Email",
                    regex: _emailRegex,
                    errorMessage: "Enter a valid email address.",
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextFormField(
                    controller: _usernameController,
                    hintText: "Username",
                    regex: _usernameRegex,
                    errorMessage:
                        "username allows letters, numbers, and underscores only.",
                  ),
                  const SizedBox(height: 25.0),
                  CustomTextFormField(
                    controller: _passwordController,
                    hintText: "Password",
                    regex: _passwordRegex,
                    obscureText: true,
                    errorMessage:
                        "password should be 8 chars, 1 digit and 1 uppercase.",
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        register(
                          _usernameController.text,
                          _emailController.text,
                          _passwordController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 25.0),
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
                  const SizedBox(height: 50),
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
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
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
          ),
        ),
      ),
    );
  }
}
