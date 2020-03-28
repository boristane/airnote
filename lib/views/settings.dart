import 'package:airnote/components/flat-button.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:airnote/views/routine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  static const routeName = "settings";
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: AirnoteColors.grey);
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: ListView(shrinkWrap: true, children: <Widget>[
            ListTile(
                title: Text("Account", style: style),
                leading: Icon(Icons.person_outline),
                onTap: () {
                  print("Account");
                  // Navigator.of(context).pushNamed(SettingsView.routeName);
                }),
            ListTile(
                title: Text("Privacy", style: style),
                leading: Icon(Icons.security),
                onTap: () {
                  print("Privacy");
                }),
                ListTile(
                title: Text("Notifications", style: style),
                leading: Icon(Icons.notifications_none),
                onTap: () {
                  print("Notifications");
                }),
                ListTile(
                title: Text("Payment Details", style: style),
                leading: Icon(Icons.credit_card),
                onTap: () {
                  print("Payment");
                }),
          ]),
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
    );
  }
}
