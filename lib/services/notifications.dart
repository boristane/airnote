import 'dart:async';

import 'dart:io' show Platform;
import 'package:airnote/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  NotificationsService() {

  }

  void initPushNotifications(User user) {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
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
        _saveDeviceToken(user);
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken(user);
    }
  }

  _saveDeviceToken(User user) async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      final os = Platform.operatingSystem;
      print("Saving token to database $fcmToken for user ${user.uuid} on $os");
      // TODO save in backend
    }
  }
}
