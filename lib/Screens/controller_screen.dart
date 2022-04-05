import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/networking_objects.dart';
import 'package:kids_tracking_app/Screens/chats_screen.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';

class ControllerScreen extends StatefulWidget {
  ControllerScreen({Key? key}) : super(key: key);

  @override
  _ControllerScreenState createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  final PageController controller = PageController(initialPage: 0);
  var pageIndex = 0;
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          Container(
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
                        return LoginScreen();
                      }), (route) => false);
                      googleSignInServices.signOutGoogle();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
          ChatsScreen()
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
          elevation: 16,
          currentIndex: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
              controller.animateToPage(pageIndex,
                  duration: Duration(milliseconds: 800),
                  curve: Curves.linearToEaseOut);
            });
          },
          iconSize: 29,
          items: [
            CustomNavigationBarItem(icon: Icon(Icons.map)),
            CustomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
            )
          ]),
    );
  }
}
