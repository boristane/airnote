import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';

class UserService {
  Dio apiClient;
  static final String _baseUrl = "http://10.0.2.2:8080/users";
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  UserService() : this.apiClient = _apiService.client;

  Future<Response> login(Map<String, String> data) async {
    final url = "/login";
    final response = await apiClient.post(url, data: {
      "email": data["email"],
      "password": data["password"],
    });
    return response;
  }

  Future<Response> signup(Map<String, String> data) {
    final url = "/signup";
    final response = _apiService.client.post(url, data: {
      "forename": data["forename"],
      "surname": data["surname"],
      "password": data["password"],
      "email": data["email"],
    });
    return response;
  }
}
