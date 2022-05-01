import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';
import 'package:kids_tracking_app/Utils/alerts.dart';
import 'package:kids_tracking_app/Utils/notifications.dart';
// import 'package:kids_tracking_app/Widgets/chat_element.dart';
import 'package:kids_tracking_app/Widgets/message_container.dart';

import '../Utils/dimensions.dart';

class ConversationScreen extends StatefulWidget {
  ConversationScreen({
    Key? key,
    this.conversationEmail,
    this.name,
  }) : super(key: key);

  final conversationEmail;
  final name;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageText = TextEditingController();
  var textStyle = TextStyle();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.name);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: firebaseFirestore
                  .collection('Messages')
                  .doc(firebaseAuth.currentUser!.email)
                  .collection('AllMessages')
                  .doc(widget.conversationEmail)
                  .collection('Conversation')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Container(
                        child: Center(
                            child: Padding(
                      padding: EdgeInsets.only(top: height(context) * 2 / 100),
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ))),
                  );
                }

                var messages = snapshot.data!.docs as List;
                List<MessageContainer> messageWidget = [];
                var counter = 0;
                for (var message in messages) {
                  final sender = message.data()['sender'];
                  final text = message.data()['message'];
                  final imageAdress = message.data()['imageAdress'];

                  messageWidget.add(MessageContainer(
                      text: text,
                      sender: sender,
                      height: height(context),
                      width: width(context),
                      imageAdress: imageAdress,
                      isSender: sender == firebaseAuth.currentUser!.email
                          ? true
                          : false));
                  if (counter == 0) {
                    firebaseChatRelatedServices.updateLastMessage(
                      message: text,
                      chatPartner: widget.conversationEmail,
                    );
                  }
                  counter++;
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(
                        horizontal: width(context) * 4 / 100,
                        vertical: height(context) * 2.5 / 100),
                    children: messageWidget,
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(
              bottom: 6,
              // 0,
              // height(context) * 1 / 100,
              top: 3,
            ),
            // height(context) * 0.5 / 100),
            child: Row(
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(50)),
                    child: TextField(
                      controller: messageText,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      style: textStyle.copyWith(color: Colors.black),
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Type a message...',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        hintStyle: textStyle.copyWith(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        // prefixIcon: IconButton(
                        //   icon: Icon(Icons.image),
                        // onPressed: () async {
                        // try {
                        //   var imageUploader =
                        //       await Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   ImageHandlerScreen(
                        //                     senderEmail: _auth
                        //                         .currentUser
                        //                         .email,
                        //                     receiverEmail:
                        //                         widget.userData[
                        //                             'email'],
                        //                     isMessage: true,
                        //                     isAVI: false,
                        //                   )));

                        //   if (imageUploader == true) {}
                        // } catch (e) {
                        //   CoolAlert.show(
                        //       context: context,
                        //       type: CoolAlertType.error,
                        //       text: 'An error occured.'
                        //       //  e.toString()
                        //       );
                        // }
                        // },
                        // color: Colors.white.withOpacity(0.6),
                        // )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    try {
                      if (messageText.text != '') {
                        var message = messageText.text;
                        messageText.text = '';
                        // print("sending message...");
                        // print(message);
                        bool isMessageSent =
                            await firebaseChatRelatedServices.sendMessage(
                          receiverEmail: widget.conversationEmail,
                          messageText: message,
                          imageAdress: '',
                        );
                        // print(isMessageSent);
                        // print("message status...");
                        if (isMessageSent) {
                          firebaseChatRelatedServices
                              .updateLastMessageSenderEmail(
                            receiverEmail: widget.conversationEmail,
                            lastMessage: message,
                          );

                          await sendMessageNotification(
                              senderName: firebaseAuth.currentUser!.displayName,
                              receiverEmail: widget.conversationEmail,
                              senderEmail: firebaseAuth.currentUser!.email
                              
                              );
                        }
                        // print("message sent...");
                      }
                    } catch (e) {
                      print(
                          "generating error while clicking send message button...");
                      print(e.toString());
                      errorAlert(context);
                    }
                  },
                  child:
                      Icon(Icons.send_rounded, size: 30, color: Colors.black),
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
