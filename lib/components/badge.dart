import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteBadge extends StatelessWidget {
  final String text;
  final bool isDark;
  AirnoteBadge({Key key, this.text, this.isDark}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
              color: isDark ? AirnoteColors.primary : AirnoteColors.white,
              borderRadius: BorderRadius.circular(550),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text, style: TextStyle(color: isDark ? AirnoteColors.white :  AirnoteColors.primary),),
            ),
    );
  }
}