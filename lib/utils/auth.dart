import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  LOGGED_IN,
  LOGGED_OUT,
  IS_LOADING,
}

class AuthHelper {
  static Future<AuthStatus> status() async {
    final token = await getToken();
    return token.isEmpty ? AuthStatus.LOGGED_OUT : AuthStatus.LOGGED_IN;
  }

  static Future<String> getToken() async {
    final userPreferences = await SharedPreferences.getInstance();
    final token = userPreferences.getString("auth-token") ?? "";
    return token;
  }

  static saveToken(String token) async {
    (await SharedPreferences.getInstance()).setString("auth-token", "Bearer $token");
  }

  static deleteToken() async {
    (await SharedPreferences.getInstance()).remove("auth-token");
  }
}