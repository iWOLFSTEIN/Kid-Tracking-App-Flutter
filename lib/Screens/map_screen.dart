import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  bool _added = false;

  Future<void> mymap({latitude, longitude}) async {
    await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 18)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: firebaseFirestore
              .collection("Coordinates")
              .doc("usercoordinates")
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder<DocumentSnapshot>(
                stream: firebaseFirestore
                    .collection("Coordinates")
                    .doc("usercoordinates")
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

                  // if (_added) {
                  //   mymap(latitude: latitude, longitude: longitude);
                  // }

                  return GoogleMap(
                    mapType: MapType.normal,
                    onCameraMove: (cameraPosition){
                       if (_added) {
                    mymap(latitude: latitude, longitude: longitude);
                  }

                    },
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

                  //  Container(
                  //   width: double.infinity,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Text("$latitude"),
                  //       Text("$longitude"),
                  //     ],
                  //   ),
                  // );
                });
          })),
    );
  }
}
