import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteCircularButton extends StatelessWidget {
  final Widget icon;
  final Function onTap;
  final bool isLarge;

  AirnoteCircularButton({Key key, this.icon, this.onTap, this.isLarge = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AirnoteColors.backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AirnoteColors.primary.withOpacity(.5),
              offset: Offset(1.0, 3.0),
              blurRadius: 5.0),
        ],
      ),
      child: Material(
        color: AirnoteColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(isLarge ? 15 : 10),
            child: icon,
          ),
        ),
      ),
    );
  }
}
