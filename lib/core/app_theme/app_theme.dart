import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "OpenSans",

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        // shadowColor: Colors.grey,
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
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF63C57A),
      ),

      // TextFormField Global Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        hintStyle: const TextStyle(
            color: Color.fromARGB(255, 73, 73, 73),
            fontWeight: FontWeight.w300),
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
            color: Color(0xFF63C57A),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFF06360),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFF06360),
            width: 2.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFF06360),
          fontWeight: FontWeight.w500,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: const Color(0xFF63C57A),
        selectionColor: const Color(0xFF63C57A).withOpacity(0.5),
        selectionHandleColor: const Color(0xFF63C57A),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF63C57A),
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(
          size: 28,
        ),
        unselectedIconTheme: IconThemeData(
          size: 24,
        ),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        elevation: 4,
      )).copyWith(
    splashFactory: NoSplash.splashFactory, // Removes the splash effect
    highlightColor: Colors.transparent, // Removes the highlight effect,
  );
}
