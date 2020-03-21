import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteBadge extends StatelessWidget {
  final String text;
  final Widget child;
  final bool isDark;
  AirnoteBadge({Key key, this.text, this.isDark = false, this.child})
      : assert(!(child != null && text != null)),
        super(key: key);

  Widget _buildChild(String text, Widget child) {
    if (text != null) {
      return Text(
        text,
        style: TextStyle(
            color: isDark ? AirnoteColors.white : AirnoteColors.primary),
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AirnoteColors.primary.withOpacity(0.9)
            : AirnoteColors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildChild(text, child),
      ),
    );
  }
}
