import 'package:flutter/material.dart';
import 'package:moments/core/common/flushbar_utils.dart'; // Import your FlushbarUtil here
import 'package:moments/features/bottom_navigation.dart';
import 'package:moments/features/view/registration/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color primaryColor = const Color(0xFF63C57A);

  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login(String usernameOrEmail, String password) {
    print('username: $usernameOrEmail, password: $password');

    // Check for empty fields
    if (usernameOrEmail.isEmpty || password.isEmpty) {
      FlushbarUtil.showMessage(
        context: context,
        message: "Please enter both username/email and password.",
        backgroundColor: const Color(0xFFF0635D),
        messageColor: Colors.white,
      );
      return; // Early exit if fields are empty
    }

    // Check for valid credentials
    if (usernameOrEmail == "admin" && password == "admin123") {
      print('Login success');
      // Clear fields and navigate to home screen
      _usernameOrEmailController.clear();
      _passwordController.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      FlushbarUtil.showMessage(
        context: context,
        message: "Invalid credentials. Please try again.",
        backgroundColor: const Color(0xFFF0635D),
        messageColor: Colors.white,
      );
      return;
    }
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
                const SizedBox(height: 90),
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/logo-light.png",
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  child: Text(
                    "Connect with the world around you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cedarville',
                      color: Color.fromARGB(255, 73, 73, 73),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  height: 45.0,
                  child: TextFormField(
                    controller: _usernameOrEmailController,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "username or email",
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  height: 45.0,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "password",
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 73, 73, 73),
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      login(
                        _usernameOrEmailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text("Sign in"),
                  ),
                ),
                const SizedBox(height: 25.0),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 73, 73),
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all<Color>(
                          Colors.transparent), // Disable highlight color
                    ),
                    child: const Text(
                      "forgot password?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF63C57A),
                          fontSize: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to RegistrationScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all<Color>(
                            Colors.transparent), // Disable highlight color
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            color: Color(0xFF63C57A),
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
