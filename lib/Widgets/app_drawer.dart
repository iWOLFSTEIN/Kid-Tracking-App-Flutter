import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

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
                      Row(
                        children: [
                          Text(
                            "12 ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Tracking",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "0 ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Trackers",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                        ],
                      ),
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
            onTap: () {
              Navigator.pop(context);
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
