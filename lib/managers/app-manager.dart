import 'package:airnote/components/dialog.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:flutter/material.dart';

class AppManager extends StatefulWidget {
  final Widget child;

  AppManager({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  DialogService _dialogService = locator<DialogService>();
  SnackBarService _snackBarService = locator<SnackBarService>();

  @override
  void initState() {
    super.initState();
    _dialogService.setOnShowListener(_showDialogInfo, _showDialogQuestion);
    _snackBarService.setOnShowListener(_showSnackbar);
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

  void _showSnackbar({Icon icon, String text}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        children: <Widget>[icon, Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text),
        )],
      ),
    ));
  }
}
