import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';

class UserService {
  Dio _apiClient;
  // static final String _baseUrl = "http://ec2-3-8-125-65.eu-west-2.compute.amazonaws.com/users";
  // static final String _baseUrl = "http://10.0.2.2:8081/users";
  static final String _baseUrl = "http://localhost:8081/users"; 
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  UserService() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> login(Map<String, String> data) async {
    final url = "/login";
    final response = await _apiClient.post(url, data: {
      "email": data["email"],
      "password": data["password"],
    });
    return response;
  }

  Future<void> setupClient() async {
    await _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> signup(Map<String, String> data) {
    final url = "/signup";
    final response = _apiClient.post(url, data: {
      "forename": data["forename"],
      "surname": data["surname"],
      "password": data["password"],
      "email": data["email"],
    });
    return response;
  }

  Future<Response> getUser() {
    final url = "/me/all";
    final response = _apiClient.get(url);
    return response;
  }
}
