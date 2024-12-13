import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final RegExp regex;
  final String errorMessage;
  final bool obscureText;

  const CustomTextFormField({super.key, 
    required this.controller,
    required this.hintText,
    required this.regex,
    required this.errorMessage,
    this.obscureText = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String? errorText;

  @override
  void initState() {
    super.initState();

    // Listen to text changes to reset error message when text is cleared
    widget.controller.addListener(() {
      setState(() {
        errorText = null; // Reset the error message when the text is changed
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: widget.controller,
      cursorColor: Color(0xFF63C57A),
      obscureText: widget.obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        if (!widget.regex.hasMatch(value)) {
          return widget.errorMessage;
        }
        return null;
      },
      onChanged: (text) {
        setState(() {
          errorText = null; // Reset error message on text change
        });
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorStyle: TextStyle(color: Color(0xFFF06360)), // Red text for error
        errorText: errorText, // Set the error text here
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Color(0xFFF06360)), // Red border for error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Color(0xFFF06360)), // Red border on focus with error
        ),
      ),
    );
  }
}
