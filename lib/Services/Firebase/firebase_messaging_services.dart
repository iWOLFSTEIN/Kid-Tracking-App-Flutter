import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';

uploadDeviceTokenToFirebase({userEmail}) async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print(userEmail);
    if (token != null) if (userEmail == null) {
      await firebaseFirestore
          .collection("DeviceToken")
          .doc(firebaseAuth.currentUser!.email)
          .set({
        "token": token,
      });
    } else {
      await firebaseFirestore.collection("DeviceToken").doc(userEmail).set({
        "token": token,
      });
    }
  } catch (e) {
    print("error is generated in uploadDeviceTokenToFirebase mehtod");
    print(e.toString());
  }
}

getDeviceTokenFromFirebase({required userEmail}) async {
  String? token;
  try {
    await firebaseFirestore
        .collection("DeviceToken")
        .doc(userEmail)
        .get()
        .then((value) {
      var snapshot = value.data() as Map;
      token = snapshot["token"];
    });
  } catch (e) {
    print("error is generated in getDeviceTokenFromFirebase mehtod");
    print(e.toString());
  }

  return token;
}

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String? token,
    {required title, required body, required data}) {
  return jsonEncode({
    'to': '$token',
    'data': data,
    'notification': {
      'title': title,
      'body': body,
    },
  });
}

Future<void> sendPushMessage({required fcmPayload}) async {
  var serverKey =
      "AAAAdZzW1U0:APA91bHy5FkmgKd94ltgu88W2R4msBteT_MiVgOouyxb32cN10O4OOU9POxIZpbebD1CkGv9bH4FUHg6FXVXfiwJSJp2YiCHL4nmnH0cjJFrFiXfiwOYWjUE_1jD-zKQkYZOH_PdV6QG";

// 'https://fcm.googleapis.com/fcm/send';

  try {
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$serverKey',
      },
      body: fcmPayload,
    );

    print(response.body);
    print('FCM request for device sent!');
  } catch (e) {
    print(e);
  }
}
