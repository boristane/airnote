import 'package:airnote/components/flat-button.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:airnote/views/routine.dart';
import 'package:flutter/material.dart';

class SelectEntryType extends StatefulWidget {
  static const routeName = "create-entry-intro";
  @override
  _SelectEntryTypeState createState() => _SelectEntryTypeState();
}

class _SelectEntryTypeState extends State<SelectEntryType> {
  @override
  Widget build(BuildContext context) {
    final AirnoteRaisedButton _assistedButton = AirnoteRaisedButton(
        text: "Start a routine",
        onPressed: () =>
            Navigator.of(context).pushNamed(RoutineView.routeName, arguments: 1));
    final AirnoteFlatButton _soloButton = AirnoteFlatButton(
        text: "Free flow",
        onPressed: () =>
            Navigator.of(context).pushNamed(RecordEntry.routeName, arguments: 1));
    return Align(
        alignment: Alignment.center,
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _assistedButton,
            _soloButton,
          ],
        ),
      
    );
  }
}
