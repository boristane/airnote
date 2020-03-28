import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class EntryTitle extends StatelessWidget {
  final String title;
  final bool isLocked;

  EntryTitle({Key key, this.title, this.isLocked}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Wrap(
      children: <Widget>[
        Center(
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
        ),
        isLocked
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.lock_outline,
                    size: 24,
                    color: AirnoteColors.grey.withOpacity(0.7),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
