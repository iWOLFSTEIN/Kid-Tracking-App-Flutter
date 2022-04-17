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
    });
  } catch (e) {
    print(e.toString());
  }
}
