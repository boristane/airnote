import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/views/settings/account.dart';
import 'package:airnote/views/settings/notifications.dart';
import 'package:airnote/views/settings/privacy.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.only(top: 140.0),
          child: ListView(shrinkWrap: true, children: <Widget>[
            ListTile(
                title: Text("Account", style: style),
                leading: Icon(Icons.person_outline, color: AirnoteColors.primary,),
                onTap: () {
                  Navigator.of(context).pushNamed(AccountView.routeName);
                }),
            ListTile(
                title: Text("Privacy", style: style),
                leading: Icon(Icons.security, color: AirnoteColors.primary),
                onTap: () {
                  Navigator.of(context).pushNamed(PrivacyView.routeName);
                }),
            ListTile(
                title: Text("Notifications", style: style),
                leading: Icon(Icons.notifications_none, color: AirnoteColors.primary),
                onTap: () {
                  Navigator.of(context).pushNamed(NotificationsView.routeName);
                }),
            ListTile(
                title: Text("Payment Details", style: style),
                leading: Icon(Icons.credit_card, color: AirnoteColors.primary),
                onTap: () {
                  print("Payment");
                }),
          ]),
        ),
        Positioned(
          top: 100,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: AirnoteHeaderText(
              text: "Settings",
            ),
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
    );
  }
}
