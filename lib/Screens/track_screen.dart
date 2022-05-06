import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/map_screen.dart';
import 'package:kids_tracking_app/Screens/request_track_access_screen.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_messaging_services.dart';
import 'package:kids_tracking_app/Widgets/app_drawer.dart';

class TrackScreen extends StatefulWidget {
  TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen>
    // with AutomaticKeepAliveClientMixin<TrackScreen>
     {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
  var textStyle = TextStyle();
  String searchText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Track",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              children: [
                SizedBox(
                  height: 13,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(50)),
                  child: TextField(
                    style: textStyle.copyWith(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search someone...',
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
                  height: 13,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RequestTrackAccessScreen();
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add Family Member",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  "Add your family member so that you can track his realtime location later",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: firebaseFirestore
                        .collection("Tracking")
                        .doc(firebaseAuth.currentUser!.email)
                        .collection("Users")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          child: Text(
                            "Loading...",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                          ),
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
                          // if (searchText == '') {
                          var widget = ListTile(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MapScreen(
                                  userEmail: i.id,
                                );
                              }));
                            },
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
                            subtitle: StreamBuilder<DocumentSnapshot>(
                                stream: firebaseFirestore
                                    .collection("Coordinates")
                                    .doc(i.id)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("0, 0");
                                  }
                                  var documentSnapshot =
                                      snapshot.data!.data() as Map;
                                  return Text(
                                      "${documentSnapshot["latitude"]}, ${documentSnapshot["longitude"]}");
                                }),
                            trailing: Icon(Icons.location_on_outlined),
                          );
                          if (searchText == '') {
                            widgetList.add(widget);
                          } else {
                            if (documentSnapshot["email"]
                                    .contains(searchText) ||
                                documentSnapshot["name"].contains(searchText)) {
                              widgetList.add(widget);
                            }
                          }
                        }
                      }
                      if (listEquals(widgetList, [])) {
                        return Container(
                          child: Center(
                              child: Text(
                            "No Data Available",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                          )),
                        );
                      }
                      return Column(
                        children: widgetList,
                      );
                    })
              ],
            ),
          ),
        ),
        drawer: AppDrawer(scaffoldKey: _scaffoldKey,));
  }
}
