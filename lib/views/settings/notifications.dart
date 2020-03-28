import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  static const routeName = "notifications";
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  UserViewModel _userViewModel;

  @override
  void didChangeDependencies() {
    final userViewModel = Provider.of<UserViewModel>(context);
    super.didChangeDependencies();
    if (this._userViewModel == userViewModel) {
      return;
    }
    this._userViewModel = userViewModel;
    Future.microtask(this._userViewModel.getUser);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: AirnoteColors.primary);
    final subStyle = TextStyle(color: AirnoteColors.grey);
    final user = this._userViewModel.user;
    if (user == null) {
      Navigator.of(context).pop();
      return AirnoteLoadingScreen();
    }
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: ListView(shrinkWrap: true, children: <Widget>[
            CheckboxListTile(
              title: Text("Daily Reminder", style: style),
              value: true,
              onChanged: (value) {
                print("changed");
              },
              subtitle: Text("Receive daily reminders to record your entry", style: subStyle),
              activeColor: AirnoteColors.primary,
              checkColor: AirnoteColors.white,
            ),
            CheckboxListTile(
              title: Text("Daily Quote", style: style),
              value: true,
              onChanged: (value) {
                print("changed");
              },
              subtitle: Text("Receive daily personalised quotes", style: subStyle),
              activeColor: AirnoteColors.primary,
              checkColor: AirnoteColors.white,
            ),
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
