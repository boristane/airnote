import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';

class UserService {
  Dio apiClient;
  static const String _baseUrl = "http://localhost:8080";
  static ApiService apiService = ApiService(baseUrl: _baseUrl);

  UserService() : this.apiClient = apiService.client;

  Future<Response> login(Map<String, String> data) async {
    final url = "/login";
    return apiClient.post(url, data: {
      "email": data["email"],
      "password": data["password"],
    });
  }
}
