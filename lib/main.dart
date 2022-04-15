import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/home_screen.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';
import 'package:kids_tracking_app/Services/location_services.dart';
import 'package:kids_tracking_app/Services/permission_handler.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await initializeBackgroundServices();

  runApp(const MyApp());
}

// initializeBackgroundServices() async {
//   FlutterBackgroundService flutterBackgroundService = FlutterBackgroundService();

//   await flutterBackgroundService.configure(
//       androidConfiguration:
//           AndroidConfiguration(onStart: onStart, isForegroundMode: false),
//       iosConfiguration: IosConfiguration(
//           onForeground: onStart,
//           onBackground: (serviceInstance) async {
//             return true;
//           }));

//   await flutterBackgroundService.startService();
// }

// onStart(service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

  
  
// }
// getLocationData(){
//   Timer.periodic(Duration(milliseconds: 300), (timer) async {
//      var locationData =await getLocation();

//    if(locationData != null)
//     try {
//                 await firebaseFirestore
//                     .collection("Coordinates")
//                     .doc("usercoordinates")
//                     .set({"latitude":locationData.lat,
//                       "longitude": locationData.long,
//                     });
//               } catch (e) {
//                 print("generating error..");
//                 print(e.toString());
//               }
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: (firebaseAuth.currentUser != null)
          ? ControllerScreen()
          : LoginScreen(),
    );
  }
}
