import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class EntryTitle extends StatelessWidget {
  final String title;

  EntryTitle({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AirnoteColors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
