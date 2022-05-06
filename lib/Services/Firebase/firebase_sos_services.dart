import 'package:kids_tracking_app/Constants/network_objects.dart';

deleteSOSReceiver({required receiverEmail}) async {
  try {
    await firebaseFirestore
        .collection("SOSReceivers")
        .doc(firebaseAuth.currentUser!.email)
        .collection('Receivers')
        .doc(receiverEmail)
        .delete();
  } catch (e) {
    print("error is generated in deleteSOSReceiver method");
    print(e.toString());
  }
}

addSOSReceiver(
    {required receiverEmail,
    required receiverName,
    required receiverProfilePic}) async {
  try {
    await firebaseFirestore
        .collection("SOSReceivers")
        .doc(firebaseAuth.currentUser!.email)
        .collection('Receivers').doc(receiverEmail)
        .set({
      "name": receiverName,
      "email": receiverEmail,
      "profilePic": receiverProfilePic
    });
  } catch (e) {
    print("error is generated in deleteSOSReceiver method");
    print(e.toString());
  }
}
