import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_request_access_related_services.dart';

class RequestTrackAccessScreen extends StatefulWidget {
  RequestTrackAccessScreen({Key? key}) : super(key: key);

  @override
  State<RequestTrackAccessScreen> createState() =>
      _RequestTrackAccessScreenState();
}

class _RequestTrackAccessScreenState extends State<RequestTrackAccessScreen> {
  TextStyle textStyle = TextStyle();
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(50)),
                  child: TextField(
                    style: textStyle.copyWith(color: Colors.black),
                    onChanged: (text) {
                      setState(() {
                        searchText = text;
                      });
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'eg. abc@gmail.com',
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      hintStyle: textStyle.copyWith(
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                (searchText == "")
                    ? Container(
                        child: Center(
                          child: Text(
                            "No data available",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                          ),
                        ),
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: firebaseFirestore
                            .collection("Users")
                            .where(
                              "email",
                              isEqualTo: searchText,
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.4)),
                                ),
                              ),
                            );
                          }
                          List<Widget> userList = [];
                          for (var i in snapshot.data!.docs) {
                            // bool isAccessGranted = false;
                            // bool isRequestSent = false;
                            if (i.id != firebaseAuth.currentUser!.email) {
                              var documentSnapshot = i.data() as Map;

                              // try {
                              //   firebaseFirestore
                              //       .collection("AccessRequests")
                              //       .doc(i.id)
                              //       .collection("Requests")
                              //       .doc(firebaseAuth.currentUser!.email)
                              //       .get()
                              //       .then((value) {
                              //     var documentSnapshot1 = value.data()! as Map;
                              //     // setState(() {
                              //     isAccessGranted =
                              //         documentSnapshot1["isAccessGranted"];
                              //     isRequestSent = true;
                              //     // });
                              //   });
                              // } catch (e) {
                              //   print(e.toString());
                              // }
                              // print(isRequestSent);
                              // print(isAccessGranted);

                              var widget = ListTile(
                                leading: CircleAvatar(
                                  radius: 21,
                                  backgroundColor:
                                      Colors.white.withOpacity(0.0),
                                  backgroundImage: CachedNetworkImageProvider(
                                      documentSnapshot["profilePic"]),
                                ),
                                title: Text(documentSnapshot["name"]),
                                subtitle: Text(i.id),
                                trailing: StreamBuilder<QuerySnapshot>(
                                    stream: firebaseFirestore
                                        .collection("AccessRequests")
                                        .doc(i.id)
                                        .collection("Requests")
                                        .where("email",
                                            isEqualTo:
                                                firebaseAuth.currentUser!.email)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container(
                                          height: 32.5,
                                          width: 72.5,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Center(
                                            child: Text("..."),
                                          ),
                                        );
                                      }

                                      Widget? widget;

                                      for (var j in snapshot.data!.docs) {
                                        var mapData = j.data() as Map;
                                        bool isGranted =
                                            mapData["isAccessGranted"];

                                        if (isGranted) {
                                          widget = Container(
                                              height: 32.5,
                                              width: 72.5,
                                              decoration: BoxDecoration(
                                                  color: Colors.green.shade200,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Text(
                                                "Granted",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ));
                                        } else {
                                          widget = Container(
                                              height: 32.5,
                                              width: 72.5,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: TextButton(
                                                  onPressed: () async {
                                                    await deleteRequest(
                                                      requestTo: i.id,
                                                    );
                                                    // setState(() {});
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )));
                                        }
                                      }

                                      if (widget != null) {
                                        return widget;
                                      }
                                      return Container(
                                          height: 32.5,
                                          width: 72.5,
                                          decoration: BoxDecoration(
                                              color:
                                                  //  (isRequestSent)
                                                  //     ? (isAccessGranted)
                                                  //         ? Colors.green.shade200
                                                  //         : Colors.grey
                                                  //     :

                                                  Color(0xFF68B3DF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child:
                                              // (isRequestSent)
                                              //     ? (isAccessGranted)
                                              //         ? Center(
                                              //             child: Text(
                                              //               "Granted",
                                              //               style: TextStyle(
                                              //                   color: Colors.white,
                                              //                   fontSize: 12),
                                              //             ),
                                              //           )
                                              //         : TextButton(
                                              //             onPressed: () async {
                                              //               await deleteRequest(
                                              //                   requestTo: i.id);
                                              //             },
                                              //             child: Text(
                                              //               "Sent",
                                              //               style: TextStyle(
                                              //                   color: Colors.white,
                                              //                   fontSize: 12),
                                              //             ),
                                              //           )
                                              //     :

                                              TextButton(
                                                  onPressed: () async {
                                                    await requestAccess(
                                                      requestTo: i.id,
                                                    );
                                                    // setState(() {});
                                                  },
                                                  child: Text(
                                                    "Request",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )));
                                    }),
                              );
                              userList.add(widget);
                              // }
                            }
                          }
                          if (listEquals(userList, [])) {
                            userList.add(Container(
                              child: Center(
                                child: Text(
                                  "No user found",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.4)),
                                ),
                              ),
                            ));
                          }
                          return Column(
                            children: userList,
                          );
                        })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
