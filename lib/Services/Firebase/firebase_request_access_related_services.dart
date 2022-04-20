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

deleteRequest({required requestTo, required requestFrom}) async {
  try {
    await firebaseFirestore
        .collection("AccessRequests")
        .doc(requestTo)
        .collection("Requests")
        .doc(requestFrom)
        .delete();
    print("document deleted");
  } catch (e) {
    print("generating error from delete request method");
    print(e.toString());
  }
}

acceptRequest({required requestFrom}) async {
  try {
    await firebaseFirestore
        .collection("AccessRequests")
        .doc(firebaseAuth.currentUser!.email)
        .collection("Requests")
        .doc(requestFrom)
        .update({
      "isAccessGranted": true,
    });
  } catch (e) {
    print("generating error from accept request method");
    print(e.toString());
  }
}

addToRequestSendersTrackingCollection({required requestFrom}) async {
  try{
  await firebaseFirestore
      .collection("Tracking")
      .doc(requestFrom)
      .collection("Users")
      .doc(firebaseAuth.currentUser!.email)
      .set({
    "name": firebaseAuth.currentUser!.displayName,
    "profilePic": firebaseAuth.currentUser!.photoURL,
    "email": firebaseAuth.currentUser!.email,
  });
  }
  catch(e){
    print("generating error from addToRequestSendersTrackingCollection method");
    print(e.toString());
  }
}

removeFromRequestSendersTrackingCollection({required requestFrom})async{
  try{
  await firebaseFirestore
      .collection("Tracking")
      .doc(requestFrom)
      .collection("Users")
      .doc(firebaseAuth.currentUser!.email)
      .delete();
  }
  catch(e){
    print("generating error from removeFromRequestSendersTrackingCollection method");
    print(e.toString());
  }
}
