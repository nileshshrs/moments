import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moments/app/app.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode (normal)
    DeviceOrientation.portraitDown, // Portrait mode (upside down)
  ]);

  SystemChannels.platform.invokeMethod('HapticFeedback.vibrate');
  await Firebase.initializeApp();
  await HiveService().init();
  await initDependency();
  runApp(const App());
}
