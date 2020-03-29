import 'package:airnote/models/notifications-user.dart';
import 'package:airnote/models/user.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/notifications.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class NotificationsViewModel extends BaseViewModel {
  String _message;
  final _dialogService = locator<DialogService>();
  NotificationsUser _user;

  NotificationsUser get user => _user;
  String get message => _message;

  final NotificationsService _notificationsService =
      locator<NotificationsService>();

  void initNotifications(User user) async {
    try {
      _notificationsService.initPushNotifications(user);
    } on DioError catch (err) {
      final data = err.response?.data ?? {};
      _message = (data is String || data is ResponseBody)
          ? AirnoteMessage.unknownError
          : data["message"] ?? AirnoteMessage.unknownError;
      print(_message);
    }
  }

  void updateUser(User user, bool subToDailyReminder, String reminderTime, bool subToQuotes) async {
    try {
      _notificationsService.updateNotificationsUser(user, subToDailyReminder, reminderTime, subToQuotes);
    } on DioError catch (err) {
      final data = err.response?.data ?? {};
      _message = (data is String || data is ResponseBody)
          ? AirnoteMessage.unknownError
          : data["message"] ?? AirnoteMessage.unknownError;
      print(_message);
    }
  }

  Future<void> getUser() async {
    setStatus(ViewStatus.LOADING);
    try {
      final response = await _notificationsService.getNotificationsUser();
      final dynamic data = response.data ?? {};
      _user = NotificationsUser.fromJson(data["user"]);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => {});
    }
    setStatus(ViewStatus.READY);
  }
}
