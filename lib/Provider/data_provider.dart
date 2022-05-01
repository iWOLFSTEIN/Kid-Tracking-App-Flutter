import 'package:flutter/cupertino.dart';

class DataProvider with ChangeNotifier {
  bool _isMessageReceived = false;
   bool get isMessageReceived => _isMessageReceived;
  set isMessageReceived(bool value) {
    _isMessageReceived = value;
    notifyListeners();
  }
}
