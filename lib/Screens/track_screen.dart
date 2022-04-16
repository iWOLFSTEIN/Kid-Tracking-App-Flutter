import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/map_screen.dart';

class TrackScreen extends StatefulWidget {
  TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Track",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.orange,
        child: Center(
          child: Container(
            height: 40,
            width: 200,
            color: Colors.blue,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MapScreen(
                        // latitude: latitude,
                        // longitude: longitude,
                        );
                  }));
                  // googleSignInServices.signOutGoogle();
                },
                child: Text(
                  "Track",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
    );
  }
}
