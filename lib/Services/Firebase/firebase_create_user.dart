import 'package:kids_tracking_app/Constants/network_objects.dart';

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
