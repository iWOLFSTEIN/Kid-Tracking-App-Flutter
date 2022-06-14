import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Screens/send_email_screen.dart';
import 'package:kids_tracking_app/Services/send_email_service.dart';

class ContactSupportScreen extends StatefulWidget {
  ContactSupportScreen({Key? key}) : super(key: key);

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Contact Support',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
              'Here is 24/7 email for contact support',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  '●  ',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SelectableText(
                  'ddeproz@gmail.com',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'To send a direct email, click on the question mark below',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade200,
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return SendEmailScreen();
          // }));
          sendEmail(title: '', body: '');
        },
        child: CircleAvatar(
          backgroundColor: Colors.green,
          radius: 22,
          child: Icon(
            Icons.question_mark,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
