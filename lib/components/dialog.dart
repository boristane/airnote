import 'package:airnote/components/primary-flat-button.dart';
import 'package:flutter/material.dart';

class AirnoteDialog extends StatefulWidget {
  final String title;
  final String content;
  final Function onPressed;

  AirnoteDialog({Key key, this.title, this.content, this.onPressed})
      : super(key: key);

  @override
  State<AirnoteDialog> createState() => _AirnoteDialogState();
}

class _AirnoteDialogState extends State<AirnoteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(widget.title),
      content: Text(widget.content),
      actions: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: AirnotePrimaryFlatButton(
              text: "OK",
              onPressed: widget.onPressed,
            ),
          ),
        ),
      ],
    );
  }
}
