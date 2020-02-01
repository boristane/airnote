import 'package:airnote/components/dialog.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:flutter/material.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.setOnShowListener(_showDialogInfo, _showDialogQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialogInfo({String title, String content, Function onPressed}) {
    void onPressedEdited() async {
      await onPressed();
      Navigator.of(context, rootNavigator: true).pop();
      _dialogService.dialogCompleted();
    }

    final dialog = AirnoteDialogInfo(
        title: title, content: content, onPressed: onPressedEdited);
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  void _showDialogQuestion(
      {String title, String content, Function onYes, Function onNo}) {
    void onYesEdited() async {
      await onYes();
      Navigator.of(context, rootNavigator: true).pop();
      _dialogService.dialogCompleted();
    }

    void onNoEdited() async {
      await onNo();
      Navigator.of(context, rootNavigator: true).pop();
      _dialogService.dialogCompleted();
    }

    final dialog = AirnoteDialogQuestion(
        title: title, content: content, onYes: onYesEdited, onNo: onNoEdited);
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }
}
