import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  // Check if permission is already granted
  PermissionStatus status = await Permission.storage.status;

  if (status.isGranted) {
    // Permission already granted
    return;
  } else if (status.isDenied) {
    // Permission has been denied once, request again
    PermissionStatus secondStatus = await Permission.storage.request();

    if (secondStatus.isGranted) {
      // Permission granted after requesting
      return;
    }
  } else {
    // Permission has not been requested yet, request it
    PermissionStatus permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      // Permission granted after requesting
      return;
    }
  }

  // Handle cases where permission is permanently denied
  if (status.isPermanentlyDenied) {
    // Prompt the user to go to settings and enable the permission manually
    openAppSettings();
  }
}