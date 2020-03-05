import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnotePlayerButton extends StatelessWidget {
  final Widget icon;
  final Function onTap;
  final bool isLarge;

  AirnotePlayerButton({Key key, this.icon, this.onTap, this.isLarge = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AirnoteColors.backgroundColor,
        borderRadius: BorderRadius.circular(180),
        boxShadow: [
          BoxShadow(
              color: AirnoteColors.grey.withOpacity(.5),
              offset: Offset(1.0, 3.0),
              blurRadius: 5.0),
        ],
      ),
      child: Material(
        color: AirnoteColors.backgroundColor,
        shape: CircleBorder(),
        child: InkWell(
          customBorder:  CircleBorder(),
          onTap: this.onTap,
          child: Container(
            padding: EdgeInsets.all(isLarge ? 60 : 10),
            child: icon,
          ),
        ),
      ),
    );
  }
}
