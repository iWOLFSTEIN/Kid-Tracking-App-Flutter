import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_tracking_app/ResponsiveDesign/dimensions.dart';
import 'package:kids_tracking_app/Screens/controller_screen.dart';
import 'package:kids_tracking_app/Constants/constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var heading_style = GoogleFonts.montserrat(
    textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 30,
        color: Colors.black.withOpacity(0.8)),
  );
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
                      "Child Tracking App",
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
                    "Child Tracking App allows you to track your kids on the Google Map. Parents can track their kids and see their realtime locations. Kids can chat to parents and send an SOS alert in case of emergency.",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontSize: 18, color: Colors.black.withOpacity(0.4)),
                    ),
                  )
                ],
              ),
              Container(
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        User? user =
                            await googleSignInServices.signInWithGoogle();

                        if (user != null) {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return ControllerScreen();
                          }), (route) => false);
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF14213D),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Container()),
                        Image.asset(
                          "images/google_logo.png",
                          height: 25,
                          width: 25,
                        ),
                        // Expanded(child: Container()),
                        Container(
                          width: 15,
                        ),
                        Text(
                          "Continue with Google",
                          style: GoogleFonts.montserrat(
                            textStyle:
                                TextStyle(fontSize: 19, color: Colors.white),
                          ),
                        ),
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
