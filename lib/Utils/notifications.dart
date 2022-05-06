import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';

sendRequestTrackAccessNotification({required senderName, required receiverEmail, required senderEmail}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: receiverEmail);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: "Track Request",
        body: "$senderName sent you a track request",
        data: {'isMessage': false,  'senderEmail': senderEmail, 'isSOS': false});

    await sendPushMessage(fcmPayload: fcmPayload);
  }

  sendAcceptedTrackRequestNotification({required senderName, required receiverEmail, required senderEmail}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: receiverEmail);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: "Request Accepted",
        body: "$senderName accepted your track request",
        data: {'isMessage': false, 'senderEmail': senderEmail, 'isSOS': false});

    await sendPushMessage(fcmPayload: fcmPayload);
  }



sendSOSAlertNotification({required senderName, required receiverEmail, required senderEmail}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: receiverEmail);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: "SOS Alert",
        body: "$senderName sent you an SOS alert. Click to track them.",
        data: {'isMessage': false, 'senderEmail': senderEmail, 'isSOS': true});

    await sendPushMessage(fcmPayload: fcmPayload);
  }




  sendMessageNotification({required senderName, required receiverEmail, required senderEmail}) async {
    var receiverToken = await getDeviceTokenFromFirebase(userEmail: receiverEmail);
    if (receiverToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    var fcmPayload = constructFCMPayload(receiverToken,
        title: senderName, body: "sent you a message", data: {'isMessage': true, 'senderEmail': senderEmail, 'isSOS': false});

    await sendPushMessage(fcmPayload: fcmPayload);
  }