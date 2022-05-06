import 'package:cool_alert/cool_alert.dart';

errorAlert(context, {errorMessage='An error occured.'}) => CoolAlert.show(
    context: context, type: CoolAlertType.error, text: errorMessage);

successAlert(context, {message='Operation successful.'}) => CoolAlert.show(
    context: context, type: CoolAlertType.success, text: message);

warningAlert(context, {message='Request cannot be processed at this moment.'}) => CoolAlert.show(
    context: context, type: CoolAlertType.warning, text: message);