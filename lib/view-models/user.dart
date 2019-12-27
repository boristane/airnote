import 'package:airnote/services/locator.dart';
import 'package:airnote/services/user.dart';
import 'package:airnote/utils/auth.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class UserViewModel extends BaseViewModel {
  final _userService = locator<UserService>();

  Future<bool> login(Map<String, String> formData) async {
    setStatus(ViewStatus.LOADING);

    Response response;
    try {
      print("Logging In");
      response = await _userService.login(formData);
      final String token = response.data["token"] ?? "";
      if (token.isEmpty) {
        setStatus(ViewStatus.READY);
        return false;
      }
      AuthHelper.saveToken(token);
    } on DioError catch (e) {
      final data = e.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      print("Dialog $message");
    }
    setStatus(ViewStatus.READY);
    return response?.statusCode == 200;
  }
}
