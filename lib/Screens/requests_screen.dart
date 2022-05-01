import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_request_access_related_services.dart';
import 'package:kids_tracking_app/Utils/notifications.dart';

class RequestsScreen extends StatefulWidget {
  RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "All User",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        bottom: TabBar(
            labelColor: Color(0xFF68B3DF),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color(0xFF68B3DF),
            controller: tabController,
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Connected",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Requests",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ]),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore
              .collection("AccessRequests")
              .doc(firebaseAuth.currentUser!.email)
              .collection("Requests")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              );
            }
            List<Widget> requestsWidgets = [];
            List<Widget> connectedWidgets = [];

            for (var i in snapshot.data!.docs) {
              var documentSnapshot = i.data() as Map;
              bool? isAccessGranted;
              Widget? widget;
              try {
                isAccessGranted = documentSnapshot["isAccessGranted"];
              } catch (e) {
                print(e.toString());
                continue;
              }
              if (isAccessGranted != null) if (!isAccessGranted) {
                widget = ListTile(
                    leading: CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white.withOpacity(0.0),
                      backgroundImage: CachedNetworkImageProvider(
                          documentSnapshot["profilePic"]),
                    ),
                    title: Wrap(
                      children: [
                        Text(documentSnapshot["name"]),
                      ],
                    ),
                    subtitle: Wrap(
                      children: [
                        Text(i.id),
                      ],
                    ),
                    trailing: Container(
                      width: 95,
                      child: Row(
                        children: [
                          Container(
                              height: 32.5,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 114, 104),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextButton(
                                  onPressed: () async {
                                    await deleteRequest(
                                        requestTo:
                                            firebaseAuth.currentUser!.email,
                                        requestFrom: i.id);
                                  },
                                  child: Text(
                                    "x",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ))),
                          SizedBox(
                            width: 2.5,
                          ),
                          Container(
                              height: 32.5,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: Color(0xFF68B3DF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: TextButton(
                                  onPressed: () async {
                                    await acceptRequest(requestFrom: i.id);
                                    await addToRequestSendersTrackingCollection(
                                        requestFrom: i.id);

                                   await sendAcceptedTrackRequestNotification(
                                        senderName: firebaseAuth
                                            .currentUser!.displayName,
                                        receiverEmail: i.id,
                                        senderEmail: firebaseAuth.currentUser!.email
                                        );
                                  },
                                  child: Text(
                                    "✓",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ))),
                        ],
                      ),
                    ));
                requestsWidgets.add(widget);
              } else {
                widget = ListTile(
                    leading: CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white.withOpacity(0.0),
                      backgroundImage: CachedNetworkImageProvider(
                          documentSnapshot["profilePic"]),
                    ),
                    title: Wrap(
                      children: [
                        Text(documentSnapshot["name"]),
                      ],
                    ),
                    subtitle: Wrap(
                      children: [
                        Text(i.id),
                      ],
                    ),
                    trailing: Container(
                        height: 32.5,
                        width: 72.5,
                        decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: TextButton(
                            onPressed: () async {
                              await deleteRequest(
                                  requestTo: firebaseAuth.currentUser!.email,
                                  requestFrom: i.id);
                              await removeFromRequestSendersTrackingCollection(
                                  requestFrom: i.id);
                            },
                            child: Text(
                              "Remove",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ))));
                connectedWidgets.add(widget);
              }
            }

            return TabBarView(controller: tabController, children: [
              (listEquals(connectedWidgets, []))
                  ? Container(
                      child: Center(
                          child: Text(
                        "No Data Available",
                        style: TextStyle(color: Colors.black.withOpacity(0.4)),
                      )),
                    )
                  : Column(
                      children: connectedWidgets,
                    ),
              (listEquals(requestsWidgets, []))
                  ? Container(
                      child: Center(
                          child: Text(
                        "No Data Available",
                        style: TextStyle(color: Colors.black.withOpacity(0.4)),
                      )),
                    )
                  : Column(
                      children: requestsWidgets,
                    ),
            ]);
          }),
    );
  }
}
