import 'package:flutter/material.dart';
import 'package:kids_tracking_app/Services/send_email_service.dart';
import 'package:kids_tracking_app/Utils/dimensions.dart';

class SendEmailScreen extends StatefulWidget {
  SendEmailScreen({Key? key}) : super(key: key);

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController bodyTextController = TextEditingController();
  var textStyle = TextStyle();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Send Email',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // height: height(context),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: height(context) * 1 / 100,
                  ),
                  Container(
                    // height: height(context) * 7 / 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      style:
                          textStyle.copyWith(color: Colors.black, fontSize: 18),
                      controller: titleTextController,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Email title',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        hintStyle: textStyle.copyWith(
                            color: Colors.black.withOpacity(0.4), fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Body',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: height(context) * 1 / 100,
                  ),
                  Container(
                    height: height(context) * 60 / 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        // border: Border.all(color: Colors.black.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: bodyTextController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 200,
                      minLines: 1,
                      style: textStyle.copyWith(color: Colors.black),
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Type a message...',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        hintStyle: textStyle.copyWith(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextButton(
                  onPressed: () {
                    if (titleTextController.text != '' ||
                        bodyTextController.text != '') {
                      sendEmail(
                          title: titleTextController.text,
                          body: bodyTextController.text);
                    }
                  },
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
