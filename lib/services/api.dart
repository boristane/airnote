import 'package:airnote/utils/auth.dart';
import 'package:dio/dio.dart';

class ApiService {
  final baseUrl;
  Dio client;

  ApiService({this.baseUrl}) {
    this.client = Dio();
    this.client.options.baseUrl = baseUrl;
  }

  void setToken(String token) {
    client.options.headers["Authorization"] = token;
  }

  Future<void> clientSetup() async {
    final token = await AuthHelper.getToken();
    if (token.isEmpty) return;
    setToken(token);
  }
}