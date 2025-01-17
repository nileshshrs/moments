import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/app/widgets/custom_textformfield.dart';
import 'package:moments/features/auth/presentation/view/login_screen.dart';
import 'package:moments/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:moments/features/auth/presentation/view_model/registration/register_bloc.dart';
import 'package:moments/features/dashboard/presentation/view_model/dashboard_cubit.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final Color primaryColor = const Color(0xFF63C57A);
  final Color textMutedColor = Colors.grey;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
  final _passwordRegex =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,24}$');

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(RegisterUser(
            context: context,
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                Image.asset(
                  "assets/images/logo-light.png",
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Connect with the world around you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cedarville',
                    color: Color.fromARGB(255, 73, 73, 73),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
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
                      "Username allows letters, numbers, and underscores only.",
                ),
                const SizedBox(height: 25.0),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Password",
                  regex: _passwordRegex,
                  obscureText: true,
                  errorMessage:
                      "Password must be 8-24 characters, 1 digit, 1 uppercase.",
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _register(context),
                    child: const Text("Sign up"),
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
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: getIt<LoginBloc>()),
                                BlocProvider.value(
                                    value: getIt<
                                        DashboardCubit>()), // Pass the relevant blocs
                              ],
                              child: LoginScreen(),
                            ),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
