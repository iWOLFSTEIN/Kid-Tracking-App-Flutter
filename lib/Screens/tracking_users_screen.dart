import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/map_screen.dart';

class TrackingUserScreen extends StatefulWidget {
  TrackingUserScreen({Key? key}) : super(key: key);

  @override
  State<TrackingUserScreen> createState() => _TrackingUserScreenState();
}

class _TrackingUserScreenState extends State<TrackingUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Tracking",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore
              .collection("Tracking")
              .doc(firebaseAuth.currentUser!.email)
              .collection("Users")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                    child: Text(
                  "Loading...",
                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                )),
              );
            }

            List<Widget> widgetList = [];

            for (var i in snapshot.data!.docs) {
              var documentSnapshot = i.data() as Map;

              String? userEmail;

              try {
                userEmail = documentSnapshot["email"];
              } catch (e) {
                print(e.toString());
                continue;
              }
              if (userEmail != null) {
                var widget = ListTile(
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
                          color: Color(0xFF68B3DF),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: TextButton(
                          onPressed: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MapScreen(
                                userEmail: i.id,
                              );
                            }));
                          },
                          child: Text(
                            "Track",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ))),
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
}
