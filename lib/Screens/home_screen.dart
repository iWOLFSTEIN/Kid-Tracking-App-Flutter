import 'package:badges/badges.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Constants/network_objects.dart';
import 'package:kids_tracking_app/Provider/data_provider.dart';
import 'package:kids_tracking_app/Screens/chats_screen.dart';
import 'package:kids_tracking_app/Screens/login_screen.dart';
import 'package:kids_tracking_app/Screens/map_screen.dart';
import 'package:kids_tracking_app/Screens/track_screen.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_create_user_services.dart';
import 'package:kids_tracking_app/Services/location_services.dart';
import 'package:provider/provider.dart';

class ControllerScreen extends StatefulWidget {
  ControllerScreen({Key? key, this.initPageIndex = 0}) : super(key: key);

  var initPageIndex;

  @override
  _ControllerScreenState createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  late PageController controller;
  var pageIndex =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage:widget.initPageIndex);
    getLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
          // if (index == 1) {
          // dataProvider.isMessageReceived = false;
          // }
        },
        children: [TrackScreen(), ChatsScreen()],
      ),
      bottomNavigationBar: CustomNavigationBar(
          selectedColor: Color(0xFF68B3DF),
          strokeColor: Color(0xFF68B3DF),
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
              // showBadge: dataProvider.isMessageReceived,
              // badgeCount: 1,
              icon:
                  //  (pageIndex == 1)
                  //     ? Icon(Icons.chat_bubble)
                  //     :

                  // (dataProvider.isMessageReceived)
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(right: 5, bottom: 29),
                  //         child: Badge(
                  //             badgeColor: Colors.green.shade200,
                  //             position: BadgePosition.bottomEnd(),
                  //             badgeContent: Container(
                  //               height: 1,
                  //               width: 1,
                  //             ),
                  //             child: Icon(Icons.chat_bubble)),
                  //       )
                  //     : 
                      Icon(Icons.chat_bubble),
            )
          ]),
    );
  }
}
