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
  UserViewModel _userViewModel;
  bool subToQuotes = false;
  bool subToDailyReminder = false;
  String reminderTime = "none";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getNotificationsUser();
    });
  }

  Future<void> _getNotificationsUser() async {
    final notificationsViewModel = Provider.of<NotificationsViewModel>(context);
    if (this._notificationsViewModel == notificationsViewModel) {
      return;
    }
    this._notificationsViewModel = notificationsViewModel;
    await this._notificationsViewModel.getUser();
    final notificationsUser = this._notificationsViewModel.user;
    final userTopics = notificationsUser.topics;
    final quoteTopic = userTopics.firstWhere((topic) => topic.name == "quotes",
        orElse: () => null);
    setState(() {
      if (quoteTopic != null) {
        subToQuotes = quoteTopic.value;
      }
      subToDailyReminder = notificationsUser.reminderTime != "none";
      reminderTime = notificationsUser.reminderTime == "none" ? "evening" : notificationsUser.reminderTime;
    });

    final userViewModel = Provider.of<UserViewModel>(context);
    if (this._userViewModel == userViewModel) {
      return;
    }
    this._userViewModel = userViewModel;
  }

  Future<bool> _onWillPop() async {
    _notificationsViewModel.updateUser(_userViewModel.user, subToDailyReminder, reminderTime, subToQuotes);
    return true;
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
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: ListView(shrinkWrap: true, children: <Widget>[
                CheckboxListTile(
                  title: Text("Daily Reminder", style: style),
                  value: subToDailyReminder,
                  onChanged: (value) {
                    setState(() {
                      subToDailyReminder = !subToDailyReminder;
                    });
                  },
                  subtitle: Text("Receive daily reminders to record your entry",
                      style: subStyle),
                  activeColor: AirnoteColors.primary,
                  checkColor: AirnoteColors.white,
                ),
                CheckboxListTile(
                  title: Text("Daily Quote", style: style),
                  value: subToQuotes,
                  onChanged: (value) {
                    setState(() {
                      subToQuotes = !subToQuotes;
                    });
                  },
                  subtitle: Text("Receive daily personalised quotes",
                      style: subStyle),
                  activeColor: AirnoteColors.primary,
                  checkColor: AirnoteColors.white,
                ),
                Divider(),
                ListTile(
                  title: Text("Daily reminder time", style: style),
                  subtitle: Text("Set the time for the daily reminder",
                      style: subStyle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: DropdownButton(
                    value: reminderTime,
                    onChanged: (String newValue) {
                      setState(() {
                        reminderTime = newValue;
                      });
                    },
                    disabledHint: Text("None"),
                    iconEnabledColor: AirnoteColors.primary,
                    isExpanded: true,
                    items: subToDailyReminder
                        ? <String>["morning", "midday", "evening"]
                            .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                  "${value[0].toUpperCase()}${value.substring(1)}",
                                  style: subStyle),
                            );
                          }).toList()
                        : null,
                  ),
                )
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
                        _onWillPop().then((value) {
                          if (value) {
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    })));
  }
}
