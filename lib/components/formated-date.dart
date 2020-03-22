import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntryDate extends StatelessWidget {
  final String date;
  EntryDate({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(date);
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(dateTime);
    return Text(
      dateString,
      style: TextStyle(
        color: AirnoteColors.grey,
        fontSize: 14,
      ),
    );
  }
}