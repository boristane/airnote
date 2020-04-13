import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

class UserService {
  Dio _apiClient;
  static final String _baseUrl = _getEndpoint();
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

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "https://cibiamj90i.execute-api.eu-west-1.amazonaws.com/dev/users";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8081/users";
      } else {
        return "http://localhost:8081/users";
      }
    }
  }
}
