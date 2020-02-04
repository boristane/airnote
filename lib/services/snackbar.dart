import 'package:flutter/material.dart';

class SnackBarService {
  Function _onSnackBarListener;

  void setOnShowListener(Function onShowSnackBarListener) {
    _onSnackBarListener = onShowSnackBarListener;
  }

  void showSnackBar({Icon icon, String text}) {
    _onSnackBarListener(text: text, icon: icon);
  }
}
