import 'package:cool_alert/cool_alert.dart';

errorAlert(context) => CoolAlert.show(
    context: context, type: CoolAlertType.error, text: 'An error occured.');
