import 'dart:async';
import 'package:airnote/services/api.dart';
import 'dart:io' show Platform;
import 'package:airnote/models/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationsService {
  FirebaseMessaging _fcm = FirebaseMessaging();
  Dio _apiClient;
  static final String _baseUrl = _getEndpoint();
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  StreamSubscription iosSubscription;

  NotificationsService() {
    setupClient();
  }

  Future<void> setupClient() async {
    await _apiService.clientSetup();
    this._apiClient = _apiService.client;
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
        _saveDeviceToken(user);
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken(user);
    }
  }

  void updateNotificationsUser(User user, bool subToDailyReminder,
      String reminderTime, bool subToQuotes) {
    _saveDeviceToken(user,
        subToDailyReminder: subToDailyReminder,
        reminderTime: reminderTime,
        subToQuotes: subToQuotes);
  }

  void _saveDeviceToken(User user,
      {bool subToDailyReminder = true,
      String reminderTime = "evening",
      bool subToQuotes = true}) async {
    String fcmToken = await _fcm.getToken();
    if (fcmToken != null && user != null) {
      final os = Platform.operatingSystem;
      final requestBody = {
        "token": fcmToken,
        "uuid": user.uuid,
        "os": os,
        "topics": [
          {"name": "quotes", "value": subToQuotes}
        ],
        "reminderTime":
            subToDailyReminder ?? subToDailyReminder ? reminderTime : "none",
      };
      await _apiClient.post("/user", data: requestBody);
    }
  }

  Future<Response> getNotificationsUser() async {
    final response = await _apiClient.get("/user");
    return response;
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "https://3v02oweo38.execute-api.eu-west-1.amazonaws.com/dev/notifications";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080/notifications";
      } else {
        return "http://localhost:8080/notifications";
      }
    }
  }
}
