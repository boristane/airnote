import 'package:airnote/components/flat-button.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:airnote/views/routine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectEntryType extends StatefulWidget {
  static const routeName = "create-entry-intro";
  @override
  _SelectEntryTypeState createState() => _SelectEntryTypeState();
}

class _SelectEntryTypeState extends State<SelectEntryType> {
  @override
  Widget build(BuildContext context) {
    final AirnoteRaisedButton _assistedButton = AirnoteRaisedButton(
        text: "Guided entry",
        onPressed: () => Navigator.of(context)
            .pushNamed(RoutineView.routeName, arguments: 0));
    final AirnoteFlatButton _soloButton = AirnoteFlatButton(
        text: "Free flow",
        onPressed: () {
          final routineViewModel = Provider.of<RoutineViewModel>(context);
          routineViewModel.reset();
          Navigator.of(context).pushNamed(RecordEntry.routeName);
        });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _assistedButton,
                _soloButton,
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: AirnoteOptionButton(
                  icon: Icon(Icons.arrow_downward),
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
