import 'package:flutter/material.dart';

class AirnoteRaisedButton extends Container {
  final String text;
  final Function onPressed;
  AirnoteRaisedButton({Key key, this.text, this.onPressed}) : super(key: key);

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
              color: Color(0xFF3C4858).withOpacity(.4),
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
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        color: Color(0xFF3C4858),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
