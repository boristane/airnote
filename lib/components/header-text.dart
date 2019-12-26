import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteHeaderText extends StatelessWidget {
  final String text;

  AirnoteHeaderText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: AirnoteColors.grey,
          letterSpacing: 1.0,
          fontFamily: "Raleway"),
    );
  }
}
