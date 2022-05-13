import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Provider/data_provider.dart';
import 'package:kids_tracking_app/Screens/all_chat_users_screen.dart';
import 'package:kids_tracking_app/Screens/conversation_screen.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_chat_related_services.dart';
import 'package:kids_tracking_app/Utils/alerts.dart';
import 'package:kids_tracking_app/Widgets/app_drawer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

import '../Utils/dimensions.dart';
// import '../Widgets/chat_element.dart';

class ChatsScreen extends StatefulWidget {
  ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
// with AutomaticKeepAliveClientMixin<ChatsScreen>
{
  final animatedListStateKey = GlobalKey<AnimatedListState>();
  bool isDeletingAllChats = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration.zero, () {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // var dataProvider = Provider.of<DataProvider>(context);
    // dataProvider.isMessageReceived = false;
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
        key: _scaffoldKey,
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
            SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: firebaseFirestore
                  .collection('Messages')
                  .doc(firebaseAuth.currentUser!.email)
                  .collection('AllMessages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    padding:
                        EdgeInsets.only(bottom: height(context) * 15 / 100),
                    height: height(context),
                    child: Center(
                      child: Text(
                        'Loading chats...',
                        style: TextStyle(color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  );
                }

                List<Widget> chatsList = [];
                var querySnapshot = snapshot.data!.docs;
                // print(snapshot.data!.docs);
                for (var i in querySnapshot) {
                  var documentSnapshotAllMessages = i.data() as Map;
                  var widget =
                      //  Builder(builder: (context) {
                      //   return
                      ChatContainerItem(
                          i: i,
                          documentSnapshotAllMessages:
                              documentSnapshotAllMessages);
                  // });
                  chatsList.add(widget);
                }
                if (listEquals(chatsList, [])) {
                  return Container(
                    height: height(context) - (height(context) * 17 / 100),
                    child: Center(
                        child: Text(
                      "No Chats Available",
                      style: TextStyle(color: Colors.black.withOpacity(0.4)),
                    )),
                  );
                }
                return Column(
                  children: chatsList,
                );

                // AnimatedList(
                //     key: animatedListStateKey,
                //     initialItemCount: chatsList.length,
                //     itemBuilder: (context, index, animation) {
                //       return Column(
                //         children: [
                //           Slidable(
                //               key: GlobalKey(),
                //               endActionPane: actionPane(),
                //               startActionPane: actionPane(),
                //               child: chatsList.elementAt(index)),
                //         ],
                //       );
                //     });
              }),
        ),
        drawer: AppDrawer(
          scaffoldKey: _scaffoldKey,
        ),
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

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class ChatContainerItem extends StatefulWidget {
  const ChatContainerItem({
    Key? key,
    required this.i,
    required this.documentSnapshotAllMessages,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> i;
  final Map documentSnapshotAllMessages;

  @override
  State<ChatContainerItem> createState() => _ChatContainerItemState();
}

class _ChatContainerItemState extends State<ChatContainerItem> {
  bool _isChatItemSelected = false;
  bool _isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            firebaseFirestore.collection("Users").doc(widget.i.id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          var documentSnapshot2 = snapshot.data!.data() as Map;

          return ListTile(
              enabled: !_isDeleting,
              selected: _isChatItemSelected,
              selectedTileColor: Colors.grey.withOpacity(0.4),
              contentPadding: EdgeInsets.symmetric(horizontal: 29, vertical: 4),
              onLongPress: () {
                setState(() {
                  _isChatItemSelected = !_isChatItemSelected;
                });
              },
              onTap: () {
                if (_isChatItemSelected) {
                  setState(() {
                    _isChatItemSelected = false;
                  });
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ConversationScreen(
                      conversationEmail: widget.i.id,
                      name: documentSnapshot2["name"],
                    );
                  }));
                }
              },
              leading: CircleAvatar(
                radius: 21,
                backgroundColor: Colors.white.withOpacity(0.0),
                backgroundImage:
                    CachedNetworkImageProvider(documentSnapshot2["profilePic"]),
              ),
              title: Wrap(
                children: [
                  Text(documentSnapshot2["name"]),
                ],
              ),
              subtitle: Text(
                widget.documentSnapshotAllMessages["lastMessage"],
                overflow: TextOverflow.ellipsis,
              ),
              trailing: (_isChatItemSelected)
                  ? GestureDetector(
                      onTap: () async {
                        try {
                          setState(() {
                            _isDeleting = true;
                          });
                          await deleteUserChat(userEmail: widget.i.id);
                          setState(() {
                            _isDeleting = false;
                          });
                        } catch (e) {
                          setState(() {
                            _isDeleting = false;
                          });
                          print(e.toString());
                        }
                      },
                      child: Icon(Icons.delete))
                  : StreamBuilder<DocumentSnapshot>(
                      stream: firebaseFirestore
                          .collection('LastMessage')
                          .doc(firebaseAuth.currentUser!.email)
                          .collection('AllChatsLastMessages')
                          .doc(widget.documentSnapshotAllMessages["sentTo"])
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: 1,
                          );
                        }

                        var documentSnapshot1;
                        try {
                          documentSnapshot1 = snapshot.data!.data() as Map;
                        } catch (e) {}

                        return Opacity(
                          opacity: (snapshot.data!.data() == null)
                              ? 1.0
                              : (documentSnapshot1['lastMessage'].compareTo(
                                          widget.documentSnapshotAllMessages[
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
                        );
                      }));
        });
  }
}
