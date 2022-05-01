import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Provider/data_provider.dart';
import 'package:kids_tracking_app/Screens/home_screen.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';
import 'package:provider/provider.dart';

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

  runApp(const InitApp());
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

onForegroundNotification(context) {
  // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
  //   print("payload received");
  //   if (message != null) {
  //     if (message.data['isMessage'] == 'true'){
  //       Future.delayed(Duration.zero, () {
  //       var dataProvider = Provider.of<DataProvider>(context, listen: false);
  //       dataProvider.isMessageReceived = true;
  //     });
  //     }
  //   }
  // });
  try {
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher'
            // '@mipmap/ic_launcher'
            );
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin!.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(message.data['isMessage']);
      print("payload received");
      if (!(message.data['isMessage'] == 'true')) {
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
                  icon: 'ic_launcher',
                ),
              ));
        }
      } else {
        Future.delayed(Duration.zero, () {
          var dataProvider = Provider.of<DataProvider>(context, listen: false);
          dataProvider.isMessageReceived = true;
        });
      }
    });
  } catch (e) {
    print("generating error in onForegroundNotification Method");
    print(e.toString());
  }
}

class InitApp extends StatefulWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => DataProvider()),
    ], child: MaterialApp(
      
       debugShowCheckedModeBanner: false,
      title: 'Kid Tracking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp()));
  }
}

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
    onForegroundNotification(context);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.data['isMessage'] == 'true') {
        Future.delayed(Duration.zero, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ControllerScreen(
              initPageIndex: 1,
            );
          }));
        });
      }
    });

    uploadDeviceTokenToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return 
    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: 
      (firebaseAuth.currentUser != null)
          ? ControllerScreen()
          : LoginScreen()
    //       ,
    // )
    ;
  }
}
