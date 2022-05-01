import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';

sendRequestTrackAccessNotification({required name, required email}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: email);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: "Track Request",
        body: "$name sent you a track request",
        data: {'isMessage': false});

    await sendPushMessage(fcmPayload: fcmPayload);
  }

  sendAcceptedTrackRequestNotification({required name, required email}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: email);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: "Request Accepted",
        body: "$name accepted your track request",
        data: {'isMessage': false});

    await sendPushMessage(fcmPayload: fcmPayload);
  }

  sendMessageNotification({required name, required email}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: email);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: name, body: "sent you a message", data: {'isMessage': true});

    await sendPushMessage(fcmPayload: fcmPayload);
  }