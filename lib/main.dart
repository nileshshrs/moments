import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moments/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode (normal)
    DeviceOrientation.portraitDown, // Portrait mode (upside down)
  ]);
  SystemChannels.platform.invokeMethod('HapticFeedback.vibrate');
  runApp(const App());
}
