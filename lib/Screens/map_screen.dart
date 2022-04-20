import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    //  this.latitude, this.longitude
    this.userEmail,
  }) : super(key: key);

  // var latitude;
  // var longitude;
  var userEmail;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  bool _added = false;

  // var latitude;
  // var longitude;

  // @override
  // void initState() {
  //   super.initState();
  //   firebaseFirestore
  //       .collection("Coordinates")
  //       .doc("usercoordinates")
  //       .snapshots()
  //       .listen((event) {
  //     var snapshot = event.data()! as Map;

  //     setState(() {
  //       latitude = snapshot["latitude"];
  //       longitude = snapshot["longitude"];
  //     });
  //   });

  // }

  Future<void> mymap({latitude, longitude}) async {
    // await _controller
    //     .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 18)));
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    // if (latitude == null || longitude == null) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Scaffold(
        // backgroundColor: Colors.white,
        body: StreamBuilder<DocumentSnapshot>(
            stream: firebaseFirestore
                .collection("Coordinates")
                .doc(widget.userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var snapshotData = snapshot.data! as DocumentSnapshot;

              var latitude = snapshotData["latitude"];
              var longitude = snapshotData["longitude"];

              if (_added) {
                mymap(latitude: latitude, longitude: longitude);
              }

              return GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                      position: LatLng(latitude, longitude),
                      markerId: MarkerId('id'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta)),
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude), zoom: 14.47),
                onMapCreated: (controller) async {
                  setState(() {
                    _controller = controller;
                    _added = true;
                  });
                },
              );
            }));
  }
}
