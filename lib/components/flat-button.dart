import 'package:flutter/material.dart';

class AirnoteFlatButton extends Container {
  final String text;
  final Function onPressed;
  AirnoteFlatButton({Key key, this.text, this.onPressed}) : super(key: key);

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
          style: TextStyle(fontSize: 18.0),
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Color(0xFFC4C4C4), width: 1.2)),
      ),
    );
  }
}
