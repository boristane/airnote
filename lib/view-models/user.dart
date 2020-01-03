import 'package:airnote/models/user.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/user.dart';
import 'package:airnote/utils/auth.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class UserViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();
  User _user;

  User get user => _user;

  Future<bool> login(Map<String, String> formData) async {
    setStatus(ViewStatus.LOADING);

    Response response;
    try {
      response = await _userService.login(formData);
      final String token = response.data["token"] ?? "";
      if (token.isEmpty) {
        setStatus(ViewStatus.READY);
        return false;
      }
      AuthHelper.saveToken(token);
      _userService.setupClient();
    } on DioError catch (e) {
      final data = e.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showDialog("Ooops!", message, () => _dialogService.dialogCompleted);
    }
    setStatus(ViewStatus.READY);
    return response?.statusCode == 200;
  }

  Future<bool> signup(Map<String, String> formData) async {
    setStatus(ViewStatus.LOADING);

    Response response;
    try {
      response = await _userService.signup(formData);
      response = await _userService.login(formData);
      final String token = response.data["token"] ?? "";
      if (token.isEmpty) {
        setStatus(ViewStatus.READY);
        return false;
      }
      AuthHelper.saveToken(token);
      _userService.setupClient();
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showDialog("Ooops!", message, () => _dialogService.dialogCompleted);
    }

    setStatus(ViewStatus.READY);
    return response?.statusCode == 200;
  }

  Future<void> getUser() async {
    setStatus(ViewStatus.LOADING);
    try {
      final response = await _userService.getUser();
      final dynamic data = response.data ?? {};
      _user = User.fromJson(data["user"]);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showDialog("Ooops!", message, () => _dialogService.dialogCompleted);
    }
    setStatus(ViewStatus.READY);
  }

  void logout() async {
    await AuthHelper.deleteToken();
    await _userService.setupClient();
  }
}
