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
        boxShadow: active
            ? [
                BoxShadow(
                    color: Colors.black.withOpacity(.6),
                    offset: Offset(1, 1),
                    blurRadius: 3)
              ]
            : null,
        color: active ? Color(0xFF3C4858) : Color(0xFFC4C4C4),
      ),
    );
  }
}