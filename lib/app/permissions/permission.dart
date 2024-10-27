import 'package:permission_handler/permission_handler.dart';

class PermissionMethods {
  askLocationPermission() async {
    await Permission.locationWhenInUse.isDenied.then((value) {
      if (value) {
        Permission.locationWhenInUse.request();
      }
    });
  }

  askCameraPermission() async {
    await Permission.camera.isDenied.then((value) {
      if (value) {
        Permission.camera.request();
      }
    });
  }
}
