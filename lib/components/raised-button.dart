import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteRaisedButton extends Container {
  final String text;
  final Function onPressed;
  final bool shadow;
  AirnoteRaisedButton({Key key, this.text, this.onPressed, this.shadow = true})
      : super(key: key);

  _getShadow() {
    if (shadow) {
      return BoxShadow(
          color: AirnoteColors.grey.withOpacity(.4),
          offset: Offset(3.0, 5.0),
          blurRadius: 5.0);
    }
    return BoxShadow();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 47,
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [_getShadow()],
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
