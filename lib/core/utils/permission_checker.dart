import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {
  static Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }
}
