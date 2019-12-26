import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteRaisedButton extends Container {
  final String text;
  final Function onPressed;
  final Icon icon;
  AirnoteRaisedButton({Key key, this.text, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 47,
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
              color: AirnoteColors.primary.withOpacity(.4),
              offset: Offset(10.0, 10.0),
              blurRadius: 10.0),
        ],
      ),
      child: RaisedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: TextStyle(color: AirnoteColors.white, fontSize: 18.0),
        ),
        color: AirnoteColors.primary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
