import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/conversation_screen.dart';
import 'package:kids_tracking_app/Utils/user_data_model_class.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class AllChatUsersScreen extends StatefulWidget {
  AllChatUsersScreen({Key? key}) : super(key: key);

  @override
  State<AllChatUsersScreen> createState() => _AllChatUsersScreenState();
}

class _AllChatUsersScreenState extends State<AllChatUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Select User",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder2<QuerySnapshot, QuerySnapshot>(
          streams: Tuple2(
              firebaseFirestore
                  .collection("Tracking")
                  .doc(firebaseAuth.currentUser!.email)
                  .collection("Users")
                  .snapshots(),
              firebaseFirestore
                  .collection("AccessRequests")
                  .doc(firebaseAuth.currentUser!.email)
                  .collection("Requests")
                  .where("isAccessGranted", isEqualTo: true)
                  .snapshots()),
          builder: (context, snapshot) {
            if (!snapshot.item1.hasData || !snapshot.item2.hasData) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              );
            }
            List<Widget> widgetList = [];
            List<UserDataModelClass> userList = [];

            for (var i in snapshot.item1.data!.docs) {
              var documentSnapshot = i.data() as Map;

              String? userEmail;

              try {
                userEmail = documentSnapshot["email"];
              } catch (e) {
                print(e.toString());
                continue;
              }
              if (userEmail != null) {
                userList.add(UserDataModelClass(
                  name: documentSnapshot["name"],
                  email: documentSnapshot["email"],
                  status: "Tracking",
                  profilePic: documentSnapshot["profilePic"],
                ));
              }
            }

            for (var i in snapshot.item2.data!.docs) {
              var documentSnapshot = i.data() as Map;

              String? userEmail;

              try {
                userEmail = documentSnapshot["email"];
              } catch (e) {
                print(e.toString());
                continue;
              }
              if (userEmail != null) {
                userList.add(checkUserExist(
                    userList: userList, documentSnapshot: documentSnapshot));
              }
            }

            if (!(listEquals(userList, []))) {
              userList.sort(((a, b) => a.name.compareTo(b.name)));
              // print(userList);
              for (var i in userList) {
                var widget = ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ConversationScreen(
                        name: i.name,
                        conversationEmail: i.email,
                      );
                    }));
                  },
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white.withOpacity(0.0),
                    backgroundImage: CachedNetworkImageProvider(i.profilePic),
                  ),
                  title: Wrap(
                    children: [
                      Text(i.name),
                    ],
                  ),
                  subtitle: Wrap(
                    children: [
                      Text(i.email),
                    ],
                  ),
                  trailing: (i.status == "Tracker/Tracking")
                      ? Container(
                          // color: Colors.orange,
                          width: 115,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                i.status.split("/")[0],
                                style: TextStyle(
                                  color: (i.status.split("/")[0] == "Tracking")
                                      ? Colors.green.shade200
                                      : Color(0xFF68B3DF),
                                ),
                              ),
                              Text(
                                "/",
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                              Text(
                                i.status.split("/")[1],
                                style: TextStyle(
                                  color: (i.status.split("/")[1] == "Tracking")
                                      ? Colors.green.shade200
                                      : Color(0xFF68B3DF),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          i.status,
                          style: TextStyle(
                            color: (i.status == "Tracking")
                                ? Colors.green.shade200
                                : Color(0xFF68B3DF),
                          ),
                        ),
                );
                widgetList.add(widget);
              }
            }

            if (listEquals(widgetList, [])) {
              return Container(
                child: Center(
                    child: Text(
                  "No Data Available",
                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                )),
              );
            }
            return Column(
              children: widgetList,
            );
          }),
    );
  }

  checkUserExist(
      {required List<UserDataModelClass> userList, required documentSnapshot}) {
    int counter = 0;
    for (var j in userList) {
      if (j.email == documentSnapshot["email"]) {
        userList.removeAt(counter);
        return UserDataModelClass(
          name: documentSnapshot["name"],
          email: documentSnapshot["email"],
          status: "Tracker/Tracking",
          profilePic: documentSnapshot["profilePic"],
        );
      }
      counter++;
    }
    return UserDataModelClass(
      name: documentSnapshot["name"],
      email: documentSnapshot["email"],
      status: "Tracker",
      profilePic: documentSnapshot["profilePic"],
    );
  }
}
