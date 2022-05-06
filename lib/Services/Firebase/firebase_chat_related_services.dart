import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Utils/alerts.dart';

class FirebaseChatRelatedServices {
  sendMessage({var receiverEmail, var messageText, var imageAdress}) async {
    bool sent = false;
    var senderEmail = firebaseAuth.currentUser!.email;
    var time = DateTime.now();

    var currentTime = time;
    // try {
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
    // } catch (e) {
    //   print("error is generated from send message method...");
    //   print(e.toString());
    // }

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

  updateLastMessageSenderEmail({var receiverEmail, var lastMessage}) async {
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

  deleteAllChats() async {
    try {
      await firebaseFirestore
          .collection('Messages')
          .doc(firebaseAuth.currentUser!.email)
          .collection('AllMessages')
          .orderBy('timestamp', descending: true)
          .get()
          .then((value) async {
        for (var data in value.docs) {
          await firebaseFirestore
              .collection('Messages')
              .doc(firebaseAuth.currentUser!.email)
              .collection('AllMessages')
              .doc(data.data()['sentTo'])
              .collection('Conversation')
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
        }
        await firebaseFirestore
            .collection('LastMessage')
            .doc(firebaseAuth.currentUser!.email)
            .collection('AllChatsLastMessages')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      }).whenComplete(() async {
        await firebaseFirestore
            .collection('Messages')
            .doc(firebaseAuth.currentUser!.email)
            .collection('AllMessages')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
      });
    } catch (e) {
      print("Error is occurred in deleteAllChats method");
      print(e.toString());
    }
  }
}

deleteUserChat({required userEmail}) async {
  try {
    await firebaseFirestore
        .collection('Messages')
        .doc(firebaseAuth.currentUser!.email)
        .collection('AllMessages')
        .doc(userEmail)
        .collection('Conversation')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    await firebaseFirestore
        .collection('LastMessage')
        .doc(firebaseAuth.currentUser!.email)
        .collection('AllChatsLastMessages')
        .doc(userEmail)
        .get()
        .then((snapshot) {
      if (snapshot.exists) snapshot.reference.delete();
    }).whenComplete(() async {
      await firebaseFirestore
          .collection('Messages')
          .doc(firebaseAuth.currentUser!.email)
          .collection('AllMessages')
          .doc(userEmail)
          .get()
          .then((snapshot) {
        if (snapshot.exists) snapshot.reference.delete();
      });
    });
  } catch (e) {
    print("Error is occurred in deleteUserChat method");
    print(e.toString());
  }
}
