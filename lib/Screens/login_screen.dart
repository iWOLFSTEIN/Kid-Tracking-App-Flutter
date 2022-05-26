import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_tracking_app/Screens/prominent_disclosure_screen.dart';
import 'package:kids_tracking_app/Services/location_services.dart';
import 'package:kids_tracking_app/Utils/dimensions.dart';
import 'package:kids_tracking_app/Screens/home_screen.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Utils/alerts.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var heading_style =
      // GoogleFonts.montserrat(
      //   textStyle:
      TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: Colors.black.withOpacity(0.8),
  )
      //       ,
      // )
      ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width(context) * 4 / 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        var alert = AlertDialog(
                          title: Text("Do you want to exit?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No")),
                            TextButton(
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                                child: Text("Yes")),
                          ],
                        );
                        showDialog(
                            context: context,
                            builder: (context) {
                              return alert;
                            });
                      },
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black.withOpacity(0.4),
                        size: 30,
                      ),
                    ),
                    Container(
                      height: height(context) * 3 / 100,
                    ),
                    Text("Welcome to", style: heading_style),
                    Text(
                      "D-Way Locator",
                      style: heading_style,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "images/gps-navigator.png",
                  height: height(context) * 30 / 100,
                  width: width(context) * 60 / 100,
                ),
              ),
              Wrap(
                children: [
                  Text(
                    "A tracking app that allows you to track family and friends.",
                    style:
                        // GoogleFonts.montserrat(
                        //   textStyle:
                        TextStyle(
                            fontSize: 18, color: Colors.black.withOpacity(0.4)),
                    // ),
                  )
                ],
              ),
              // SizedBox(),
              Container(
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        User? user =
                            await googleSignInServices.signInWithGoogle();

                        if (user != null) {
                          var isLocationPermissionGranted =
                              await isLocationEnabled();
                          if (isLocationPermissionGranted) {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return ControllerScreen();
                            }), (route) => false);
                          } else {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return ProminentDisclosureScreen();
                            }), (route) => false);
                          }
                        }
                      } catch (e) {
                        print(e.toString());
                        errorAlert(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.black
                        // Color(0xFF14213D),
                        ),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Image.asset(
                          "images/google_logo.png",
                          height: 23,
                          width: 23,
                        ),
                        // Expanded(child: Container()),
                        Container(
                          width: 15,
                        ),
                        Text(
                          "Continue with Google",
                          style:
                              // GoogleFonts.montserrat(
                              //   textStyle:
                              TextStyle(fontSize: 17.5, color: Colors.white),
                        ),
                        // ),
                        Container(
                          width: width(context) * 2 / 100,
                        ),
                        Expanded(child: Container()),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
