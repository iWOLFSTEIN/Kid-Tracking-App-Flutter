import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/conversation_screen.dart';
import 'package:kids_tracking_app/Widgets/app_drawer.dart';

import '../Utils/dimensions.dart';
// import '../Widgets/chat_element.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final animatedListStateKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
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
          StreamBuilder<QuerySnapshot>(
              stream: firebaseFirestore
                  .collection('Messages')
                  .doc(firebaseAuth.currentUser!.email)
                  .collection('AllMessages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    child: Center(
                        child: Text(
                      'Loading chats...',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    )),
                  );
                }

                var chatsList = [];
                var querySnapshot = snapshot.data!.docs;
                for (var i in querySnapshot) {
                  var widget =
                      //  Builder(builder: (context) {
                      //   return
                      Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: firebaseFirestore
                            .collection('Messages')
                            .doc(firebaseAuth.currentUser!.email)
                            .collection('AllMessages')
                            .doc(i.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text(""),
                            );
                          }
                          var documentSnapshot = snapshot.data!.data() as Map;
                          return ListTile(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ConversationScreen(
                                    conversationEmail: i.id,
                                    name: "Adam",
                                  );
                                }));
                              },
                              leading: CircleAvatar(
                                radius: 21,
                                backgroundColor: Color(0xFF68B3DF),
                              ),
                              title: Text(i.id),
                              subtitle: Text(documentSnapshot["lastMessage"]),
                              trailing: CircleAvatar(
                                backgroundColor: Colors.green.shade200,
                                radius: 8,
                                child: Center(
                                  child: Text(
                                    '1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ));
                        }),
                  );
                  // });
                  chatsList.add(widget);
                }
                if (listEquals(chatsList, [])) {
                  return Container(
                    child: Center(
                        child: Text(
                      "No Chats Available",
                      style: TextStyle(color: Colors.black.withOpacity(0.4)),
                    )),
                  );
                }
                return AnimatedList(
                    key: animatedListStateKey,
                    initialItemCount: chatsList.length,
                    itemBuilder: (context, index, animation) {
                      return Column(
                        children: [
                          Slidable(
                              key: GlobalKey(),
                              endActionPane: actionPane(),
                              startActionPane: actionPane(),
                              child: chatsList.elementAt(index)),
                        ],
                      );
                    });
              }),
      drawer: AppDrawer(),
    );
  }

  ActionPane actionPane() {
    return ActionPane(dragDismissible: false, motion: ScrollMotion(),
        // dismissible: DismissiblePane(onDismissed: () {
        //   // chatsList.removeAt(index);
        //   // AnimatedList.of(context).removeItem(
        //   //     index,
        //   //     (context, animation) =>
        //   //         chatsList.elementAt(index));
        // }),
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
        ]);
  }
}
