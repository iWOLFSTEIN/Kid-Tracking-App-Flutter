import 'package:kids_tracking_app/Constants/network_objects.dart';

requestAccess({
  required requestTo,
}) async {
  try {
    await firebaseFirestore
        .collection("AccessRequests")
        .doc(requestTo)
        .collection("Requests")
        .doc(firebaseAuth.currentUser!.email)
        .set({
      "name": firebaseAuth.currentUser!.displayName,
      "profilePic": firebaseAuth.currentUser!.photoURL,
      "email": firebaseAuth.currentUser!.email,
      "isAccessGranted": false,
    });
  } catch (e) {
    print("generating error from request access method");
    print(e.toString());
  }
}

deleteRequest({required requestTo}) async {
  try {
    await firebaseFirestore
        .collection("AccessRequests")
        .doc(requestTo)
        .collection("Requests")
        .doc(firebaseAuth.currentUser!.email)
        .delete();
    print("document deleted");
  } catch (e) {
    print("generating error from delete request method");
    print(e.toString());
  }
}
