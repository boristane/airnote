import 'package:airnote/components/primary-flat-button.dart';
import 'package:airnote/components/secondary-flat-button.dart';
import 'package:airnote/components/text-input-field.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(widget.title),
      content: Text(
        widget.content,
        style: TextStyle(color: AirnoteColors.grey),
      ),
      actions: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Container(alignment: Alignment.center, child: Text(widget.title)),
      content: Text(
        widget.content,
        style: TextStyle(color: AirnoteColors.grey),
      ),
      actions: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: AirnotePrimaryFlatButton(
              text: "Yes",
              onPressed: widget.onYes,
            ),
          ),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.only(bottom: 15, left: 30, right: 30),
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

class AirnoteDialogInput extends StatefulWidget {
  final String title;
  final String content;
  final String inputHint;
  final Icon inputSuffix;
  final Function onPressed;
  final Function inputValidator;
  final bool isLoading;

  AirnoteDialogInput(
      {Key key,
      @required this.title,
      @required this.content,
      @required this.onPressed,
      @required this.inputSuffix,
      @required this.inputHint,
      @required this.inputValidator,
      this.isLoading})
      : super(key: key);

  @override
  State<AirnoteDialogInput> createState() => _AirnoteInputQuestion();
}

class _AirnoteInputQuestion extends State<AirnoteDialogInput> {
  String input;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Container(alignment: Alignment.center, child: Text(widget.title)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              widget.content,
              style: TextStyle(color: AirnoteColors.grey),
            ),
            AirnoteTextInputField(
                hint: widget.inputHint,
                suffix: widget.inputSuffix,
                label: "",
                validator: widget.inputValidator,
                save: _setPassphrase)
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: widget.isLoading
                ? SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AirnoteColors.white),
                    ),
                  )
                : AirnotePrimaryFlatButton(
                    text: "Submit",
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (!form.validate()) return;
                      form.save();
                      widget.onPressed(input);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  _setPassphrase(value) {
    setState(() {
      input = value;
    });
  }
}
