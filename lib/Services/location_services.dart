import 'package:flutter/services.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_location_services.dart';
import 'package:kids_tracking_app/Services/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

getLocation() async {
  bool isPermissionGranted = false;
  try {
    isPermissionGranted = await getPermission(Permission.location);
    location.changeSettings(
        interval: 1000, accuracy: loc.LocationAccuracy.high);
  } catch (e) {
    print("generating error from getLocation method");
    print(e);
  }
  enableBackgroundMode();
  try {
    // var locationData;

    // location.enableBackgroundMode(enable: true);

    if (isPermissionGranted) {
      // locationData = await location.getLocation();
      location.onLocationChanged.listen((LocationData currentLocation) async {
        await updateUserLocationToFirebase(currentLocation: currentLocation);
      });
    }

    // return locationData;
  } catch (e) {
    print("generating error from getLocation method");
    print(e);
  }
}

Future<bool> enableBackgroundMode() async {
  bool _bgModeEnabled = await location.isBackgroundModeEnabled();
  if (_bgModeEnabled) {
    return true;
  } else {
    try {
      await location.enableBackgroundMode();
    } catch (e) {
      print(e.toString());
    }
    try {
      _bgModeEnabled = await location.enableBackgroundMode();
    } catch (e) {
      print(e.toString());
    }
    print(_bgModeEnabled); //True!
    return _bgModeEnabled;
  }
}

Future<bool> isLocationEnabled() async {
  bool _bgModeEnabled = false;
  try {
    _bgModeEnabled = await Permission.location.isGranted;
  } catch (e) {
    print(e.toString());
  }
  try {
    _bgModeEnabled = await Permission.location.isGranted;
  } catch (e) {
    print(e.toString());
  }
  return _bgModeEnabled;
}
