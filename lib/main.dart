// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/home_screen.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';
// import 'package:kids_tracking_app/Services/location_services.dart';
// import 'package:kids_tracking_app/Services/permission_handler.dart';
// import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:location/location.dart' as loc;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await initializeBackgroundServices();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);
  }

  runApp(const MyApp());
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("payload received");
      if (message != null) {}
    });
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("payload received");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                // channel!.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'ic_launcher',
              ),
            ));
      }
    });

    uploadDeviceTokenToFirebase();
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: (firebaseAuth.currentUser != null)
          ? ControllerScreen()
          : LoginScreen(),
    );
  }
}
