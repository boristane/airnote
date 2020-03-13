import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteSmallerHeader extends StatelessWidget {
  final String text;
  final String subText;

  AirnoteSmallerHeader({Key key, this.text, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AirnoteColors.grey,
                letterSpacing: 1.0,),
          ),
          subText != null ? Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              subText,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AirnoteColors.inactive,
                  letterSpacing: 1.0,),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}