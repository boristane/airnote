import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryDate extends StatelessWidget {
  final String date;
  EntryDate({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(date).toLocal();
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(dateTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AirnoteUtils.getIcon(date: dateTime, color: AirnoteColors.grey),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 0.0),
          child: Text(
            dateString,
            style: TextStyle(
              color: AirnoteColors.grey,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}