import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteDotIndicator extends StatelessWidget {
  final bool active;
  AirnoteDotIndicator({this.active});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AirnoteColors.primary : AirnoteColors.inactive,
      ),
    );
  }
}