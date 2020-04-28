import 'dart:async';

import 'package:flutter/material.dart';

class DialogService {
  Completer _dialogInfoCompleter;
  Completer _dialogQuestionCompleter;
  Completer _dialogInputCompleter;
  Function _onShowInfoListener;
  Function _onShowQuestionListener;
  Function _onShowInputListener;

  void setOnShowListener(Function onShowInfoListener,
      Function onShowQuestionListener, Function onShowInputListener) {
    _onShowInfoListener = onShowInfoListener;
    _onShowQuestionListener = onShowQuestionListener;
    _onShowInputListener = onShowInputListener;
  }

  Future showInfoDialog({String title, String content, Function onPressed}) {
    _dialogInfoCompleter = Completer();
    _onShowInfoListener(title: title, content: content, onPressed: onPressed);
    return _dialogInfoCompleter.future;
  }

  Future showQuestionDialog(
      {String title, String content, Function onYes, Function onNo}) {
    _dialogQuestionCompleter = Completer();
    _onShowQuestionListener(
        title: title, content: content, onYes: onYes, onNo: onNo);
    return _dialogQuestionCompleter.future;
  }

  Future showInputDialog(
      {@required String title,
      @required String content,
      @required Function onPressed,
      @required Function inputValidator,
      @required String inputHint,
      @required Icon inputSuffix,
      bool isLoading, }) {
    _dialogInputCompleter = Completer();
    _onShowInputListener(
        title: title,
        content: content,
        onPressed: onPressed,
        inputValidator: inputValidator,
        inputHint: inputHint,
        inputSuffix: inputSuffix,
        isLoading: isLoading);
    return _dialogInputCompleter.future;
  }

  void dialogCompleted() {
    _dialogInfoCompleter?.complete();
    _dialogInfoCompleter = null;
    _dialogQuestionCompleter?.complete();
    _dialogQuestionCompleter = null;
    _dialogInputCompleter?.complete();
    _dialogInputCompleter = null;
  }
}
