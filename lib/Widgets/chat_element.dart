import 'package:flutter/material.dart';

import '../ResponsiveDesign/dimensions.dart';


class ChatElement extends StatelessWidget {
  ChatElement({
    Key? key,
    this.bottomCredential,
    this.profilePic,
    this.sellerName,
    this.avatarRadius,
    this.heightBetween,
    this.nameWeight,
    this.newMessageIndicator,
    this.newMessageTime,
    this.credentialFontSize,
    this.nameFontSize,
    this.isOnline = false,
  }) : super(key: key);

  var sellerName;
  var bottomCredential;
  var profilePic;
  var avatarRadius;
  var heightBetween;
  var nameWeight;
  Widget? newMessageTime;
  Widget? newMessageIndicator;
  double? nameFontSize;
  double? credentialFontSize;
  bool? isOnline;
  @override
  Widget build(BuildContext context) {
    return Row(
      // ignore: prefer_const_literals_to_create_immutables
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: Colors.blue,
        ),
        SizedBox(
          width: width(context) * 2.5 / 100,
        ),
        Column(
          // ignore: prefer_const_literals_to_create_immutables
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width(context) * 72.5 / 100,
              // color: Colors.orange,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile User',
                    style: TextStyle(
                        fontSize: nameFontSize, fontWeight: nameWeight),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height(context) * 0.3 / 100,
                        left: width(context) * 1 / 100),
                    child: CircleAvatar(
                      backgroundColor: (!isOnline!)
                          ? Colors.green.withOpacity(0.0)
                          : Colors.green,
                      radius: 4,
                    ),
                  ),
                  Expanded(child: Container()),
                  (newMessageTime == null) ? Container() : newMessageTime!,
                ],
              ),
            ),
            SizedBox(
              height: heightBetween,
            ),
            Container(
              width: width(context) * 72.5 / 100,
              // color: Colors.orange,
              child: Row(
                children: [
                  Text(
                    // 'Last online: 3 min ago',
                    bottomCredential,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: credentialFontSize),
                  ),
                  Expanded(child: Container()),
                  (newMessageIndicator == null)
                      ? Container()
                      : newMessageIndicator!,
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
