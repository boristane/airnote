import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteHeader extends StatelessWidget {
  final String text;
  final String subText;

  AirnoteHeader({Key key, this.text, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AirnoteColors.primary,
              letterSpacing: 1.0,),
        ),
        Text(
          subText,
          style: TextStyle(
              fontSize: 20,
              color: AirnoteColors.grey,
              letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}