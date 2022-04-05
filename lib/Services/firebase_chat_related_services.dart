import 'package:kids_tracking_app/Constants/networking_objects.dart';

class FirebaseChatRelatedServices {
  sendMessage({var receiverEmail, var messageText, var imageAdress}) async {
    bool sent = false;
    var senderEmail = firebaseAuth.currentUser!.email;
    var time = DateTime.now();

    var currentTime = time;

    await firebaseFirestore
        .collection('Messages')
        .doc(senderEmail)
        .collection('AllMessages')
        .doc(receiverEmail)
        .collection('Conversation')
        .add({
      'message': messageText,
      'sender': senderEmail,
      'timestamp': currentTime,
      'imageAdress': imageAdress,
    }).whenComplete(() async {
      await firebaseFirestore
          .collection('Messages')
          .doc(receiverEmail)
          .collection('AllMessages')
          .doc(senderEmail)
          .collection('Conversation')
          .add({
        'message': messageText,
        'sender': senderEmail,
        'timestamp': currentTime,
        'imageAdress': imageAdress,
      }).whenComplete(() {
        sent = true;
      });
    });

    return sent;
  }


 updateLastMessage({message, chatPartner}) async {
   
    if (message != null) {
      await firebaseFirestore
          .collection('LastMessage')
          .doc(firebaseAuth.currentUser!.email)
          .collection('AllChatsLastMessages')
          .doc(chatPartner)
          .set({'lastMessage': message});
    }
  }


  updateLastMessageSenderEmail(
      { var receiverEmail, var lastMessage}) async {
    var time = DateTime.now();
    var senderEmail = firebaseAuth.currentUser!.email;
    var currentTime = time;
    await firebaseFirestore
        .collection('Messages')
        .doc(senderEmail)
        .collection('AllMessages')
        .doc(receiverEmail)
        .set({
      'sentTo': receiverEmail,
      'timestamp': currentTime,
      'lastMessage': lastMessage,
      //(lastMessage == '') ? 'sent a picture' : lastMessage,
    }).whenComplete(() async {
      await firebaseFirestore
          .collection('Messages')
          .doc(receiverEmail)
          .collection('AllMessages')
          .doc(senderEmail)
          .set({
        'sentTo': senderEmail,
        'timestamp': currentTime,
        'lastMessage': lastMessage
        // (lastMessage == '') ? 'sent a picture' : lastMessage,
      });
    });
  }
}
