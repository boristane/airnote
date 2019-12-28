import 'package:airnote/components/flat-button.dart';
import 'package:flutter/material.dart';

class AirnoteDialog extends StatefulWidget {
  final String title;
  final String content;
  final Function onPressed;

  AirnoteDialog({Key key, this.title, this.content, this.onPressed}): super(key: key);

  @override
  State<AirnoteDialog> createState() => _AirnoteDialogState();
}

class _AirnoteDialogState extends State<AirnoteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Text(widget.content),
      ),
      actions: <Widget>[
        Container(
          child: AirnoteFlatButton(
            text: "OK",
            onPressed: () {
              // Navigator.of(context, rootNavigator: true).pop();
              widget.onPressed();
            }
          ),
        ),
      ],
    );
  }
}