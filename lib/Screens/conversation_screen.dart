import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Widgets/message_container.dart';

import '../ResponsiveDesign/dimensions.dart';

class ConversationScreen extends StatefulWidget {
  ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageText = TextEditingController();
  var textStyle = TextStyle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Adam",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(
                  horizontal: width(context) * 4 / 100,
                  vertical: height(context) * 2.5 / 100),
              children: [
                for (int i = 0; i < 20; i++)
                  MessageContainer(
                    text:
                        "Hello World, There was an idea to bring to gether a group of remarkable people",
                    sender: "Talha",
                    height: height(context),
                    width: width(context),
                    isSender: (i % 2 == 0) ? true : false,
                  ),
                
              ],
            ),
          ),
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
                        color: Color(0xFF14213D),
                        borderRadius: BorderRadius.circular(50)),
                    child: TextField(
                      controller: messageText,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      style: textStyle.copyWith(color: Colors.white),
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
                          color: Colors.white.withOpacity(0.6),
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
                    // // try {
                    // //   if (messageText.text != null &&
                    // //       messageText.text != '') {
                    // //     var message = messageText.text;
                    // //     messageText.text = '';

                    // //     await backendServices.sendMessage(
                    // //       senderEmail: _auth.currentUser.email,
                    // //       receiverEmail: widget.userData['email'],
                    // //       messageText: message,
                    // //       imageAdress: '',
                    // //     );

                    // //     backendServices.updateConversationEmail(
                    // //       senderEmail: _auth.currentUser.email,
                    // //       receiverEmail: widget.userData['email'],
                    // //       lastMessage: message,
                    // //     );
                    // //     // if (messageSent) {}
                    // //   }
                    // } catch (e) {
                    //   // CoolAlert.show(
                    //   //     context: context,
                    //   //     type: CoolAlertType.error,
                    //   //     text: 'An error occured.'
                    //   //     //  e.toString()
                    //   //     );
                    // }
                  },
                  child: Icon(Icons.send_rounded,
                      size: 30, color: Color(0xFF15354E)),
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
