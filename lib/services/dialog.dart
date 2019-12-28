import 'dart:async';

import 'package:flutter/material.dart';

class DialogService {
  Completer _dialogCompleter;
  Function _onShowListener;

  void setOnShowListener(Function onShowListener) {
    _onShowListener = onShowListener;
  }

  Future showDialog(String title, String content, Function onPressed) {
    _dialogCompleter = Completer();
    _onShowListener(title: title, content: content, onPressed: onPressed);
    return _dialogCompleter.future;
  }

  void dialogCompleted() {
    _dialogCompleter.complete();
    _dialogCompleter = null;
  }
}