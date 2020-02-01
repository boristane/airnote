import 'package:airnote/components/primary-flat-button.dart';
import 'package:airnote/components/secondary-flat-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteDialogInfo extends StatefulWidget {
  final String title;
  final String content;
  final Function onPressed;

  AirnoteDialogInfo({Key key, this.title, this.content, this.onPressed})
      : super(key: key);

  @override
  State<AirnoteDialogInfo> createState() => _AirnoteDialogInfoState();
}

class _AirnoteDialogInfoState extends State<AirnoteDialogInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
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

class AirnoteDialogQuestion extends StatefulWidget {
  final String title;
  final String content;
  final Function onYes;
  final Function onNo;

  AirnoteDialogQuestion(
      {Key key, this.title, this.content, this.onYes, this.onNo})
      : super(key: key);

  @override
  State<AirnoteDialogQuestion> createState() => _AirnoteDialogQuestion();
}

class _AirnoteDialogQuestion extends State<AirnoteDialogQuestion> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      title: Container(alignment: Alignment.center, child: Text(widget.title)),
      content: Text(widget.content),
      actions: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AirnotePrimaryFlatButton(
              text: "Yes",
              onPressed: widget.onYes,
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
            child: AirnoteSecondaryFlatButton(
              text: "No",
              onPressed: widget.onNo,
            ),
          ),
        ),
      ],
    );
  }
}
