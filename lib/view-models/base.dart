


import 'package:flutter/material.dart';

enum ViewStatus {
  LOADING,
  READY,
}

class BaseViewModel extends ChangeNotifier {
  ViewStatus _status;

  ViewStatus getStatus() {
    return _status;
  }

  void setStatus(ViewStatus status) {
    _status = status;
    notifyListeners();
  }
}