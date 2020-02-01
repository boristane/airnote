import 'dart:async';

class DialogService {
  Completer _dialogInfoCompleter;
  Completer _dialogQuestionCompleter;
  Function _onShowInfoListener;
  Function _onShowQuestionListener;

  void setOnShowListener(Function onShowInfoListener, Function onShowQuestionListener) {
    _onShowInfoListener = onShowInfoListener;
    _onShowQuestionListener = onShowQuestionListener;
  }

  Future showInfoDialog({String title, String content, Function onPressed}) {
    _dialogInfoCompleter = Completer();
    _onShowInfoListener(title: title, content: content, onPressed: onPressed);
    return _dialogInfoCompleter.future;
  }

  Future showQuestionDialog({String title, String content, Function onYes, Function onNo}) {
    _dialogQuestionCompleter = Completer();
    _onShowQuestionListener(title: title, content: content, onYes: onYes, onNo: onNo);
    return _dialogQuestionCompleter.future;
  }

  void dialogCompleted() {
    _dialogInfoCompleter?.complete();
    _dialogInfoCompleter = null;
    _dialogQuestionCompleter?.complete();
    _dialogQuestionCompleter = null;
  }
}