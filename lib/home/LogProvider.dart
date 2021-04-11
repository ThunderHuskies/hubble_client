import 'package:flutter/material.dart';

class LogProvider extends ChangeNotifier{
  List<String> _logList = [];

  List<String> get logList =>
      this._logList;

  set logList(List<String> value) {
    _logList = value;
    notifyListeners();
  }

  void addValue(String value){
    _logList.add(value);
    notifyListeners();
  }

  List<String> getList(){
    return this.logList;
  }

}