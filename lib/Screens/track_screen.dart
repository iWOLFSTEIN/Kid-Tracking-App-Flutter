import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/map_screen.dart';
import 'package:kids_tracking_app/Screens/request_track_access_screen.dart';
import 'package:kids_tracking_app/Widgets/app_drawer.dart';

class TrackScreen extends StatefulWidget {
  TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  var textStyle = TextStyle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(50)),
                  child: TextField(
                    style: textStyle.copyWith(color: Colors.black),
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
                  height: 15,
                ),
                Container(
                  // height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                      onPressed: () async {
                        // var latitude;
                        // var longitude;
                        // await firebaseFirestore
                        //     .collection("Coordinates")
                        //     .doc("usercoordinates")
                        //     .get()
                        //     .then((value) {
                        //   var snapshot = value.data()! as Map;
                        //   latitude = snapshot["latitude"];
                        //   longitude = snapshot["longitude"];
                        // });

                        // if (!(latitude == null || longitude == null))
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return MapScreen(

                        //       );
                        // }));

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
                ListTile(
                  onTap: () {},
                  leading: CircleAvatar(
                    radius: 21,
                    backgroundColor: Color(0xFF68B3DF),
                  ),
                  title: Text("Dummy User"),
                  subtitle: Text("34.3492023, 23.234983"),
                  trailing: Icon(Icons.location_on_outlined),
                )
              ],
            ),
          ),
        ),
        drawer: AppDrawer());
  }
}
