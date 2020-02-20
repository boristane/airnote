import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class RoutineService {
  Dio _apiClient;
  // static final String _baseUrl = "http://10.0.2.2:8080/routines";
  static final String _baseUrl = "http://localhost:8080/routines";
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  RoutineService() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<void> setupClient() async {
    await _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> getRoutine() async {
    const url = "/";
    final now = new DateTime.now().toIso8601String();
    final response = await _apiClient.get(url, queryParameters: {"now": now});
    return response;
  }
}
