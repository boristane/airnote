import 'dart:async';
import 'package:airnote/services/api.dart';
import 'dart:io' show Platform;
import 'package:airnote/models/user.dart';
import 'package:airnote/utils/messages.dart';
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
    _apiService.clientSetup();
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
      final requestBody = {
        "token": fcmToken,
        "uuid": user.uuid,
        "os": os,
        "topic": "quotes"
      };
      try {
        print("Saving token to database $fcmToken for user ${user.uuid} on $os");
        final response = await _apiClient.post("/user", data: requestBody);
        return response;
      } on DioError catch (err) {
        final data = err.response?.data ?? {};    
        final message = (data is String || data is ResponseBody) ? AirnoteMessage.unknownError : data["message"] ?? AirnoteMessage.unknownError;
        print(message);
      }
    }
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "http://ec2-3-8-125-65.eu-west-2.compute.amazonaws.com/notifications";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080/notifications";
      } else {
        return "http://localhost:8080/notifications";
      }
    }
  }
}