import 'package:permission_handler/permission_handler.dart';

getPermission(Permission permission) async {
  bool permissionIsGranted = false;

  var status = await permission.request();
  
  if (status.isGranted) {
    permissionIsGranted = true;
  } else if (status.isDenied ) {
    getPermission(permission);
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
  }
  
  return permissionIsGranted;
}
