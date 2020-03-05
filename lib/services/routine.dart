import 'dart:io' show Platform;

import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

class RoutineService {
  Dio _apiClient;
  static final String _baseUrl = _getEndpoint();
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
    const url = "/1";
    final response = await _apiClient.get(url);
    return response;
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "http://ec2-3-8-125-65.eu-west-2.compute.amazonaws.com/routines";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080/routines";
      } else {
        return "http://localhost:8080/routines";
      }
    }
  }
}
