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
    _dialogService.setOnShowListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog({String title, String content, Function onPressed}) {
    void onPressed () {
            Navigator.of(context, rootNavigator: true).pop();
            _dialogService.dialogCompleted();
          }
    final dialog = AirnoteDialog(title: title, content: content, onPressed: onPressed);
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }
}
