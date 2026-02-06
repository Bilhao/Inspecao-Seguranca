import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.status;

  if (status.isDenied || status.isRestricted) {
    status = await Permission.storage.request();
  }
}

Future<void> requestCameraPermission() async {
  PermissionStatus status = await Permission.camera.status;

  if (status.isDenied || status.isRestricted) {
    status = await Permission.camera.request();
  }
}