import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Screens/home_screen.dart';

import '../Utils/alerts.dart';
import '../Utils/dimensions.dart';

class ProminentDisclosureScreen extends StatefulWidget {
  ProminentDisclosureScreen({Key? key}) : super(key: key);

  @override
  State<ProminentDisclosureScreen> createState() =>
      _ProminentDisclosureScreenState();
}

class _ProminentDisclosureScreenState extends State<ProminentDisclosureScreen> {
  @override
  Widget build(BuildContext context) {
    //  Navigator.pushAndRemoveUntil(context,
    //                             MaterialPageRoute(builder: (context) {
    //                           return ControllerScreen();
    //                         }), (route) => false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Disclosure',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(
            //   height: 15,
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                'D-Way Locator collects location data to enable the tracking of your kids, updating their live location coordinates and show them on map even when app is closed or not in use. \n',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      // try {
                      //   User? user =
                      //       await googleSignInServices.signInWithGoogle();

                      //   if (user != null) {
                      //     var isLocationPermissionGranted =
                      //         await Permission.location.isGranted;
                      //     if (isLocationPermissionGranted) {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return ControllerScreen();
                      }), (route) => false);
                      //     }
                      //     else{
                      //        Navigator.pushAndRemoveUntil(context,
                      //           MaterialPageRoute(builder: (context) {
                      //         return ProminentDisclosureScreen();
                      //       }), (route) => false);
                      //     }
                      //   }
                      // } catch (e) {
                      //   print(e.toString());
                      //   errorAlert(context);
                      // }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.black
                        // Color(0xFF14213D),
                        ),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        // Image.asset(
                        //   "images/google_logo.png",
                        //   height: 23,
                        //   width: 23,
                        // ),
                        // // Expanded(child: Container()),
                        // Container(
                        //   width: 15,
                        // ),
                        Text(
                          "Continue",
                          style:
                              // GoogleFonts.montserrat(
                              //   textStyle:
                              TextStyle(fontSize: 17.5, color: Colors.white),
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        )
                        // ),
                        // Container(
                        //   width: width(context) * 2 / 100,
                        // ),
                        // Expanded(child: Container()),
                      ],
                    )),
              ),
            ),
            // SizedBox(
            //   height: 15,
            // ),
          ],
        ),
      ),
    );
  }
}
