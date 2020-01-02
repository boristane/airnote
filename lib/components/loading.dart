import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: CircularProgressIndicator(
          strokeWidth: 5,
          valueColor: AlwaysStoppedAnimation(AirnoteColors.primary),
        ),
      ),
    );
  }
}