import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteSmallerHeader extends StatelessWidget {
  final String text;

  AirnoteSmallerHeader({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AirnoteColors.grey,
            letterSpacing: 1.0,
            fontFamily: "Raleway"),
      ),
    );
  }
}