import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';
import 'dart:async';

typedef void OnError(Exception exception);

class QuestService {
  Dio _apiClient;
  // static final String _baseUrl =
  static final String _baseUrl = "http://10.0.2.2:8080/quests";
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
}