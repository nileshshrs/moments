import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/features/auth/presentation/view/registration_screen.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  final Color primaryColor = const Color(0xFF63C57A);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameOrEmailController =
        TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                    controller: usernameOrEmailController,
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
                    controller: passwordController,
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
                      final usernameOrEmail = usernameOrEmailController.text;
                      final password = passwordController.text;
                      context.read<LoginBloc>().add(
                            LoginUserEvent(
                              context: context,
                              username: usernameOrEmail,
                              password: password,
                            ),
                          );

                      // Dispatch the login event
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
                        // Dispatch event to navigate to RegistrationScreen
                        context.read<LoginBloc>().add(
                              NavigateToRegisterScreenEvent(
                                context: context,
                                destination: RegistrationScreen(),
                              ),
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
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
