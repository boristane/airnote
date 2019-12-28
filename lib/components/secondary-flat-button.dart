import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteSecondaryFlatButton extends Container {
  final String text;
  final Function onPressed;
  AirnoteSecondaryFlatButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 47,
      margin: EdgeInsets.only(top: 20.0),
      child: FlatButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 18.0, color: AirnoteColors.white),
        ),
        color: AirnoteColors.inactive,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: AirnoteColors.inactive, width: 1.2)),
      ),
    );
  }
}
