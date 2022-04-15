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
       location.onLocationChanged.listen((LocationData currentLocation) async{
           try {
                await firebaseFirestore
                    .collection("Coordinates")
                    .doc("usercoordinates")
                    .set({"latitude": currentLocation.latitude,
                      "longitude": currentLocation.latitude
                    });
              } catch (e) {
                print("generating error..");
                print(e.toString());
              }
     
    });
    }

   
    // return locationData;
  } catch (e) {
    print(e);
  }
}
