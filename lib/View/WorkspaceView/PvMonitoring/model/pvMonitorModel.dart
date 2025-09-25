import 'package:flutter/material.dart';

class PvMonitorModel extends ChangeNotifier {
  Map<String, dynamic> _weatherdata = {};

  Map<String, dynamic> get weatherdata => _weatherdata;

  set weatherdata(Map<String, dynamic> value) {
    _weatherdata = value;
    notifyListeners();
  }
}
