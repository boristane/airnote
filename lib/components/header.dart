import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteHeader extends StatelessWidget {
  final String text;
  final String subText;

  AirnoteHeader({Key key, this.text, this.subText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AirnoteColors.grey,
                  letterSpacing: 1.0,),
            ),
          ),
          Text(
            subText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                color: AirnoteColors.grey.withOpacity(0.8),
                letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}