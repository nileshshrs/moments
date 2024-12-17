import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final RegExp regex;
  final String errorMessage;
  final bool obscureText;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.regex,
    required this.errorMessage,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        if (!regex.hasMatch(value)) {
          return errorMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        isDense: true, // Makes the input field more compact
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0), // Adjust vertical padding to fit within 45px
      ),
    );
  }
}
