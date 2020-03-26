import 'dart:async';
import 'dart:io' show Platform;

import 'package:airnote/components/dialog.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AppManager extends StatefulWidget {
  final Widget child;

  AppManager({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  DialogService _dialogService = locator<DialogService>();
  SnackBarService _snackBarService = locator<SnackBarService>();
  FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    _dialogService.setOnShowListener(_showDialogInfo, _showDialogQuestion);
    _snackBarService.setOnShowListener(_showSnackbar);
    initPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void initPushNotifications() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showDialogInfo(
            content: message['notification']['body'],
            title: message['notification']['title'],
            onPressed: () {});
        //TODO optional
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
        _saveDeviceToken();
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }
  }

  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      print("Saving token to database $fcmToken");
      _showDialogInfo(content: fcmToken, title: "Token", onPressed: () {});
      // TODO save in backend
    }
  }

  void _showDialogInfo({String title, String content, Function onPressed}) {
    void onPressedEdited() async {
      await onPressed();
      Navigator.of(context, rootNavigator: true).pop();
      _dialogService.dialogCompleted();
    }

    final dialog = AirnoteDialogInfo(
        title: title, content: content, onPressed: onPressedEdited);
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  void _showDialogQuestion(
      {String title, String content, Function onYes, Function onNo}) {
    void onYesEdited() async {
      await onYes();
      Navigator.of(context, rootNavigator: true).pop();
      _dialogService.dialogCompleted();
    }

    void onNoEdited() async {
      await onNo();
      Navigator.of(context, rootNavigator: true).pop();
      _dialogService.dialogCompleted();
    }

    final dialog = AirnoteDialogQuestion(
        title: title, content: content, onYes: onYesEdited, onNo: onNoEdited);
    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  void _showSnackbar({Icon icon, String text}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(text),
          )
        ],
      ),
    ));
  }
}
