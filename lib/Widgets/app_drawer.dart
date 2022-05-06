import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';
import 'package:kids_tracking_app/Screens/requests_screen.dart';
import 'package:kids_tracking_app/Screens/sos_receivers_screen.dart';
import 'package:kids_tracking_app/Screens/tracking_users_screen.dart';
import 'package:kids_tracking_app/Utils/alerts.dart';
import 'package:kids_tracking_app/Utils/notifications.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key, this.scaffoldKey}) : super(key: key);

  var scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.centerLeft,
                color: Colors.black,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 0, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: CachedNetworkImageProvider(
                            firebaseAuth.currentUser!.photoURL!),
                        radius: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firebaseAuth.currentUser!.displayName!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            firebaseAuth.currentUser!.email!,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                        ],
                      ),
                      Container(),
                      StreamBuilder2<QuerySnapshot, QuerySnapshot>(
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
                            var trackingCount;
                            if (snapshot.item1.hasData) {
                              trackingCount = 0;
                              for (var i in snapshot.item1.data!.docs) {
                                if (i.id.contains("@")) {
                                  trackingCount++;
                                }
                              }
                            }
                            var trackerCount;
                            if (snapshot.item2.hasData) {
                              trackerCount = 0;
                              for (var i in snapshot.item2.data!.docs) {
                                if (i.id.contains("@")) {
                                  trackerCount++;
                                }
                              }
                            }

                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TrackingUserScreen();
                                    }));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        (trackingCount == null)
                                            ? "0 "
                                            : "$trackingCount ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Tracking",
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RequestsScreen();
                                    }));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        (trackerCount == null)
                                            ? "0 "
                                            : "$trackerCount ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Trackers",
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
              )),
          ListTile(
            leading: Icon(
              Icons.adjust,
              color: Colors.black,
            ),
            title: Text(
              "Send SOS Alert",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            onTap: () async {
              Navigator.pop(context);

              try {
                await firebaseFirestore
                    .collection('SOSReceivers')
                    .doc(firebaseAuth.currentUser!.email)
                    .collection('Receivers')
                    .get()
                    .then((value) async {
                  if (!(listEquals(value.docs, []))) {
                    for (var i in value.docs) {
                      print(i.id);
                      await sendSOSAlertNotification(
                          senderName: firebaseAuth.currentUser!.displayName,
                          receiverEmail: i.id,
                          senderEmail: firebaseAuth.currentUser!.email);
                    }
                    successAlert(scaffoldKey.currentContext);
                  } else {
                    warningAlert(scaffoldKey.currentContext,
                        message: "You don't have any SOS alert receivers.");
                  }
                });
              } catch (e) {
                print('generating error while sending sos alert');
                print(e.toString());
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.call_received,
              color: Colors.black,
            ),
            title: Text(
              "SOS Alert Receivers",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SOSReceiversScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.pending_actions,
              color: Colors.black,
            ),
            title: Text(
              "Requests",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RequestsScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.track_changes,
              color: Colors.black,
            ),
            title: Text(
              "Tracking",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TrackingUserScreen();
              }));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Divider(
              height: 0.5,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            onTap: () async {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }), (route) => false);
              googleSignInServices.signOutGoogle();
            },
          ),
        ],
      ),
    );
  }
}
