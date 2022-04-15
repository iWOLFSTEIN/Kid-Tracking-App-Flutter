


import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Screens/map_screen.dart';

class TrackScreen extends StatefulWidget {
  TrackScreen({Key? key}) : super(key: key);

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
            color: Colors.orange,
            child: Center(
              child: Container(
                height: 40,
                width: 200,
                color: Colors.blue,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return MapScreen();
                      }), (route) => false);
                      // googleSignInServices.signOutGoogle();
                    },
                    child: Text(
                      "Track",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          );
  }
}