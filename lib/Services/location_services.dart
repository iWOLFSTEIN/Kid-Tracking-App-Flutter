import 'package:kids_tracking_app/Services/Firebase/firebase_location_update.dart';
import 'package:kids_tracking_app/Services/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

getLocation() async {
  try {
    // var locationData;
    bool isPermissionGranted = await getPermission(Permission.location);
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);

    if (isPermissionGranted) {
      // locationData = await location.getLocation();
      location.onLocationChanged.listen((LocationData currentLocation) async {
       await updateUserLocationToFirebase(currentLocation: currentLocation);  
      });
    }

    // return locationData;
  } catch (e) {
    print(e);
  }
}
