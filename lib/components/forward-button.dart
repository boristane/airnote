import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteForwardButton extends StatelessWidget {
  final String text;
  final Function onTap;
  AirnoteForwardButton({Key key, this.text, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AirnoteColors.primary,
          borderRadius: BorderRadius.circular(550),
          boxShadow: [
            BoxShadow(
                color: AirnoteColors.grey.withOpacity(.5),
                offset: Offset(1.0, 3.0),
                blurRadius: 5.0),
          ],
        ),
        child: Material(
          color: AirnoteColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(550.0),
          ),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(550.0),
            ),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    text,
                    style:
                        TextStyle(fontSize: 15.0, color: AirnoteColors.white),
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
              ),
            ),
          ),
        ));
  }
}
