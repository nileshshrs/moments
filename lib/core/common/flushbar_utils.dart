import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class FlushbarUtil {
  static void showMessage({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color messageColor,
    Duration duration = const Duration(seconds: 5),
    FlushbarPosition position = FlushbarPosition.TOP,
  }) {
    Flushbar(
      message: message,
      duration: duration,
      backgroundColor: backgroundColor,
      flushbarPosition: position,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 3.0),
      borderRadius: BorderRadius.circular(10.0),
      boxShadows: const [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0),
        ),
      ],
      messageColor: messageColor,
    ).show(context);
  }
}
