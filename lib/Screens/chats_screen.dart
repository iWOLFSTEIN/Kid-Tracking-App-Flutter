import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kids_tracking_app/Screens/conversation_screen.dart';

import '../ResponsiveDesign/dimensions.dart';
import '../Widgets/chat_element.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Widget> chatsList = [
    for (int i = 0; i < 5; i++)
      Builder(builder: (context) {
        return
            //  Column(
            //   children: [
            //     Slidable(
            //       key: GlobalKey(),
            //       endActionPane: ActionPane(motion: ScrollMotion(),
            //           // dismissible: DismissiblePane(onDismissed: () {
            //           //   // setState(() {
            //           //   //   chatsList.removeAt(i);
            //           //   // });
            //           // }),
            //           children: [
            //             SlidableAction(
            //               onPressed: (context) {},
            //               backgroundColor:
            //                   //Colors.blue,
            //                   // Color(0xFF21B7CA),
            //                   Colors.white,
            //               foregroundColor: Color(0xFF21B7CA),
            //               icon: Icons.block,
            //               label: 'Block',
            //             ),
            //             SlidableAction(
            //               onPressed: (context) {},
            //               backgroundColor: Colors.white,
            //               foregroundColor: Colors.red,
            //               icon: Icons.delete,
            //               label: 'Delete',
            //             ),
            //           ]),
            //       child:
            Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Container(
            // width: width(context),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
                // color: Color(0xFFDAE9E4),
                // borderRadius: BorderRadius.all(Radius.circular(20))
                ),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ConversationScreen();
                }));
              },
              child: Row(
                children: [
                  ChatElement(
                    sellerName: 'Talha Ashraf',
                    bottomCredential: 'This is a dummy message',
                    profilePic: null,
                    avatarRadius: 23.0,
                    heightBetween: height(context) * 0.9 / 100,
                    nameWeight: FontWeight.w400,
                    newMessageTime: Text(
                      '09:12 AM',
                      style: TextStyle(
                          fontSize: 14, color: Colors.black.withOpacity(0.4)),
                    ),
                    newMessageIndicator: CircleAvatar(
                      backgroundColor: Colors.green.shade400,
                      radius: 8,
                      child: Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    nameFontSize: 17.5,
                    credentialFontSize: 15.5,
                  ),
                ],
              ),
            ),
          ),
        )
            //     ),
            //     Divider(
            //       // key: Key(i.toString()),
            //       height: 0,
            //       thickness: 1,
            //     )
            //   ],
            // )
            ;
      })
  ];
  final animatedListStateKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    // chatsList = [

    // ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body:
          // SingleChildScrollView(
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 0, left: 0, top: 4, bottom: 4),
          //     child: Column(
          //       children: chatsList,
          //     ),
          //   ),
          // ),
          AnimatedList(
              key: animatedListStateKey,
              initialItemCount: chatsList.length,
              itemBuilder: (context, index, animation) {
                return Column(
                  children: [
                    Slidable(
                        key: GlobalKey(),
                        endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              chatsList.removeAt(index);
                              AnimatedList.of(context).removeItem(
                                  index,
                                  (context, animation) =>
                                      chatsList.elementAt(index));
                            }),
                            children: [
                              // SlidableAction(
                              //   onPressed: (context) {},
                              //   backgroundColor:

                              //       Colors.white,
                              //   foregroundColor: Color(0xFF21B7CA),
                              //   icon: Icons.block,
                              //   label: 'Block',
                              // ),
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ]),
                        child: chatsList.elementAt(index)),
                    // Divider(
                    //   // key: Key(i.toString()),
                    //   height: 0,
                    //   thickness: 1,
                    // )
                  ],
                );
              }),
    );
  }
}

