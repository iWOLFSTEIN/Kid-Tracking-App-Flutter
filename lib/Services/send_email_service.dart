import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

sendEmail({required title, required body}) async {
  Email email =
      Email(subject: title, body: body, recipients: ['ddeproz@gmail.com']);

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    print(error);
  }
}
