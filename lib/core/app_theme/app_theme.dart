import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "OpenSans",

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: const Color(0xFF63C57A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    // TextFormField Global Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100], // Background color for input field
      hintStyle: const TextStyle(
          color: Color.fromARGB(255, 73, 73, 73), fontWeight: FontWeight.w300),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 12.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF63C57A), // Focused border color
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFF06360), // Error border color
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFF06360), // Focused error border color
          width: 2.0,
        ),
      ),
      errorStyle: const TextStyle(
        color: Color(0xFFF06360), // Error text color
        fontWeight: FontWeight.w500,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: const Color(0xFF63C57A), // Cursor color
      selectionColor:
          const Color(0xFF63C57A).withOpacity(0.5), // Text selection color
      selectionHandleColor: const Color(0xFF63C57A), // Handle color
    ),
  );
}
