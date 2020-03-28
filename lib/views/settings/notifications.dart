import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/notifications.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  static const routeName = "notifications";
  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  NotificationsViewModel _notificationsViewModel;

  @override
  void didChangeDependencies() {
    final notificationsViewModel = Provider.of<NotificationsViewModel>(context);
    super.didChangeDependencies();
    if (this._notificationsViewModel == notificationsViewModel) {
      return;
    }
    this._notificationsViewModel = notificationsViewModel;
    Future.microtask(this._notificationsViewModel.getUser);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: AirnoteColors.primary);
    final subStyle = TextStyle(color: AirnoteColors.grey);
    return SafeArea(child: Container(child:
        Consumer<NotificationsViewModel>(builder: (context, model, child) {
      if (model.getStatus() == ViewStatus.LOADING) {
        return AirnoteLoadingScreen();
      }
      final notificationsUser = model.user;
      return Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: ListView(shrinkWrap: true, children: <Widget>[
              CheckboxListTile(
                title: Text("Daily Reminder", style: style),
                value: notificationsUser.reminderTime != "none",
                onChanged: (value) {
                  print("changed");
                },
                subtitle: Text("Receive daily reminders to record your entry",
                    style: subStyle),
                activeColor: AirnoteColors.primary,
                checkColor: AirnoteColors.white,
              ),
              CheckboxListTile(
                title: Text("Daily Quote", style: style),
                value: notificationsUser.topics.indexOf("quotes") != -1,
                onChanged: (value) {
                  print("changed");
                },
                subtitle:
                    Text("Receive daily personalised quotes", style: subStyle),
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
    })));
  }
}
