import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteForwardButton extends StatelessWidget {
  final String text;
  final Function onTap;
  AirnoteForwardButton({Key key, this.text, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
              color: AirnoteColors.primary, borderRadius: BorderRadius.circular(550)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 15.0, color: AirnoteColors.white),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ],
          )),
    );
  }
}
