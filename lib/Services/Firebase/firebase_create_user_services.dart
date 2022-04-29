import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';

createUser({
  required userEmail,
  required name,
  required profilePic,
}) async {
  try {
    await firebaseFirestore.collection("Users").doc(userEmail).set({
      "name": name,
      "profilePic": profilePic,
      "email": userEmail,
    });
    await createRequestCollection(userEmail: userEmail);
    await createTrackingCollection(userEmail: userEmail);
    await uploadDeviceTokenToFirebase(userEmail: userEmail);
  } catch (e) {
    print("generating error from create user method");
    print(e.toString());
  }
}

createRequestCollection({required userEmail}) async {
  try {
    await firebaseFirestore
        .collection("AccessRequests")
        .doc(userEmail)
        .collection("Requests")
        .add({});
  } catch (e) {
    print("generating error from create request collection method");
    print(e.toString());
  }
}

createTrackingCollection({required userEmail}) async {
  try {
    await firebaseFirestore
        .collection("Tracking")
        .doc(userEmail)
        .collection("Users")
        .add({});
  } catch (e) {
    print("generating error from create tracking collection method");
    print(e.toString());
  }
}
