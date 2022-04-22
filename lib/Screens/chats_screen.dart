import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/all_chat_users_screen.dart';
import 'package:kids_tracking_app/Screens/conversation_screen.dart';
import 'package:kids_tracking_app/Utils/alerts.dart';
import 'package:kids_tracking_app/Widgets/app_drawer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../Utils/dimensions.dart';
// import '../Widgets/chat_element.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin<ChatsScreen> {
  final animatedListStateKey = GlobalKey<AnimatedListState>();
  bool isDeletingAllChats = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isDeletingAllChats,
      progressIndicator: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text("Deleting Chats")
        ],
      ),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'Chats',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllChatUsersScreen();
                  }));
                },
                child: Icon(Icons.add)),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(width(context), 0, 0, 0),
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        child: Text("Delete All Chats"),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Confirm!"),
                                  content: Text(
                                      "Are you sure you want to delete all chats?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "No",
                                          style: TextStyle(fontSize: 16),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          setState(() {
                                            isDeletingAllChats = true;
                                          });
                                          try {
                                            await firebaseChatRelatedServices
                                                .deleteAllChats();
                                            setState(() {
                                              isDeletingAllChats = false;
                                            });
                                          } catch (e) {
                                            setState(() {
                                              isDeletingAllChats = false;
                                            });
                                            errorAlert(context);
                                          }
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(fontSize: 16),
                                        )),
                                  ],
                                );
                              });

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog();
                              });
                        },
                      ),
                    ],
                  );
                },
                child: Icon(Icons.more_vert)),
            SizedBox(
              width: 10,
            ),
          ],
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
                  print(snapshot.data!.docs);
                  for (var i in querySnapshot) {
                    var documentSnapshotAllMessages = i.data() as Map;
                    var widget =
                        //  Builder(builder: (context) {
                        //   return
                        Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 13, vertical: 4),
                      child: StreamBuilder2<DocumentSnapshot, DocumentSnapshot>(
                          streams: Tuple2(
                            // firebaseFirestore
                            //     .collection('Messages')
                            //     .doc(firebaseAuth.currentUser!.email)
                            //     .collection('AllMessages')
                            //     .doc(i.id)
                            //     .snapshots(),
                            firebaseFirestore
                                .collection("Users")
                                .doc(i.id)
                                .snapshots(),

                            firebaseFirestore
                                .collection('LastMessage')
                                .doc(firebaseAuth.currentUser!.email)
                                .collection('AllChatsLastMessages')
                                .doc(documentSnapshotAllMessages["sentTo"])
                                .snapshots(),
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.item1.hasData ||
                                !snapshot.item2.hasData) {
                              return Container();
                            }

                            var documentSnapshot1 =
                                snapshot.item2.data!.data() as Map;
                            var documentSnapshot2 =
                                snapshot.item1.data!.data() as Map;

                            return ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ConversationScreen(
                                      conversationEmail: i.id,
                                      name: documentSnapshot2["name"],
                                    );
                                  }));
                                },
                                leading: CircleAvatar(
                                  radius: 21,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.0),
                                  backgroundImage: CachedNetworkImageProvider(
                                      documentSnapshot2["profilePic"]),
                                ),
                                title: Wrap(
                                  children: [
                                    Text(documentSnapshot2["name"]),
                                  ],
                                ),
                                subtitle: Text(
                                  documentSnapshotAllMessages["lastMessage"],
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Opacity(
                                  opacity: (snapshot.item2.data!.data() == null)
                                      ? 1.0
                                      : (documentSnapshot1['lastMessage']
                                                  .compareTo(
                                                      documentSnapshotAllMessages[
                                                          'lastMessage']) !=
                                              0)
                                          ? 1.0
                                          : 0.0,
                                  child: CircleAvatar(
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
      ),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
