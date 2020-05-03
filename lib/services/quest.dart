import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

typedef void OnError(Exception exception);

class QuestService {
  Dio _apiClient;
  static final String _baseUrl = _getEndpoint();
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  QuestService() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> getQuests() async {
    const url = "/";
    final response = await _apiClient.get(url);
    return response;
  }

  Future<Response> getSingleQuest(int id) async {
    final url = "/$id";
    final response = await _apiClient.get(url);
    return response;
  }

  Future<Response> joinQuest(int id) {
    final url = "/join/$id";
    final response = _apiClient.post(url, data: {"id": id});
    return response;
  }

  Future<void> setupClient() async {
    await _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "https://va0lnfcg4a.execute-api.eu-west-2.amazonaws.com/prod/quests";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080/quests";
      } else {
        return "http://localhost:8080/quests";
      }
    }
  }
}
