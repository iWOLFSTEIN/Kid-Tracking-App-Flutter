import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Services/Firebase/firebase_sos_services.dart';
import 'package:kids_tracking_app/Utils/dimensions.dart';

import '../Constants/network_objects.dart';

class SOSReceiversScreen extends StatefulWidget {
  SOSReceiversScreen({Key? key}) : super(key: key);

  @override
  State<SOSReceiversScreen> createState() => _SOSReceiversScreenState();
}

class _SOSReceiversScreenState extends State<SOSReceiversScreen> {
  TextStyle textStyle = TextStyle();
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'SOS Alert Receivers',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: firebaseFirestore
                .collection("SOSReceivers")
                .doc(firebaseAuth.currentUser!.email)
                .collection('Receivers')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.only(bottom: height(context) * 15 / 100),
                  height: height(context),
                  child: Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(color: Colors.black.withOpacity(0.4)),
                    ),
                  ),
                );
              }
              var queryList = snapshot.data!.docs;
              List<Widget> receiversWidgetList = [];
              List receiverEmailsIds = [];
              if (!(listEquals(queryList, [])))
                for (var i in queryList) {
                  var documentSnapshot = i.data() as Map;
                  var widget = ListTile(
                      leading: CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.white.withOpacity(0.0),
                        backgroundImage: CachedNetworkImageProvider(
                            documentSnapshot["profilePic"]),
                      ),
                      title: Wrap(
                        children: [
                          Text(documentSnapshot["name"]),
                        ],
                      ),
                      subtitle: Wrap(
                        children: [
                          Text(i.id),
                        ],
                      ),
                      trailing: Container(
                          height: 32.5,
                          width: 72.5,
                          decoration: BoxDecoration(
                              color: Colors.green.shade200,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextButton(
                              onPressed: () async {
                                deleteSOSReceiver(receiverEmail: i.id);
                              },
                              child: Text(
                                "Remove",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ))));
                  receiversWidgetList.add(widget);
                  receiverEmailsIds.add(i.id);
                }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Add A Receiver',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(50)),
                      child: TextField(
                        style: textStyle.copyWith(color: Colors.black),
                        onChanged: (text) {
                          setState(() {
                            searchText = text;
                          });
                          // print(searchText);
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'eg. abc@gmail.com',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          hintStyle: textStyle.copyWith(
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (searchText == "")
                        ? Container(
                            child: Center(
                              child: Text(
                                "Search results",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4)),
                              ),
                            ),
                          )
                        : StreamBuilder<QuerySnapshot>(
                            stream: firebaseFirestore
                                .collection("Users")
                                .where(
                                  "email",
                                  isEqualTo: searchText,
                                )
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  child: Center(
                                    child: Text(
                                      "No data available",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.4)),
                                    ),
                                  ),
                                );
                              }
                              List<Widget> userList = [];
                              for (var j in snapshot.data!.docs) {
                                if (j.id != firebaseAuth.currentUser!.email) {
                                  var documentSnapshot1 = j.data() as Map;
                                  bool isExistingReceiver = false;
                                  if (receiverEmailsIds.contains(j.id)) {
                                    isExistingReceiver = true;
                                  }
                                  var widget = ListTile(
                                      leading: CircleAvatar(
                                        radius: 21,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.0),
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                documentSnapshot1[
                                                    "profilePic"]),
                                      ),
                                      title: Wrap(
                                        children: [
                                          Text(documentSnapshot1["name"]),
                                        ],
                                      ),
                                      subtitle: Wrap(
                                        children: [
                                          Text(j.id),
                                        ],
                                      ),
                                      trailing: Container(
                                          height: 32.5,
                                          width: 72.5,
                                          decoration: BoxDecoration(
                                              color: (isExistingReceiver)
                                                  ? Colors.green.shade200
                                                  : Color(0xFF68B3DF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: TextButton(
                                              onPressed: (isExistingReceiver)
                                                  ? () async {
                                                      await deleteSOSReceiver(
                                                          receiverEmail: j.id);
                                                    }
                                                  : () async {
                                                      await addSOSReceiver(
                                                          receiverEmail: j.id,
                                                          receiverName:
                                                              documentSnapshot1[
                                                                  "name"],
                                                          receiverProfilePic:
                                                              documentSnapshot1[
                                                                  "profilePic"]);
                                                    },
                                              child: Text(
                                                (isExistingReceiver)
                                                    ? "Remove"
                                                    : "Add",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ))));
                                  userList.add(widget);
                                }
                              }
                              if (listEquals(userList, [])) {
                                userList.add(Container(
                                  child: Center(
                                    child: Text(
                                      "No user found",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.4)),
                                    ),
                                  ),
                                ));
                              }
                              return Column(
                                children: userList,
                              );
                            }),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Receivers',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (listEquals(receiversWidgetList, []))
                        ? Container(
                            child: Center(
                              child: Text(
                                "No receivers found",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4)),
                              ),
                            ),
                          )
                        : Column(
                            children: receiversWidgetList,
                          )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
