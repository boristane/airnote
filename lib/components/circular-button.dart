import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteCircularButton extends StatelessWidget {
  final Widget icon;
  final Function onTap;
  final bool isLarge;

  AirnoteCircularButton({Key key, this.icon, this.onTap, this.isLarge = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: this.onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? 15 : 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AirnoteColors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
                color: AirnoteColors.primary.withOpacity(.5),
                offset: Offset(1.0, 10.0),
                blurRadius: 10.0),
          ],
        ),
        child: icon,
      ),
    );
  }
}