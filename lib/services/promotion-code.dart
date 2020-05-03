import 'dart:io' show Platform;

import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

class PromotionCodeService {
  Dio _apiClient;
  static final String _baseUrl = _getEndpoint();
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  PromotionCodeService() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<void> setupClient() async {
    await _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> redeemCode(String code) async {
    final url = "/redeem";
    final response = await _apiClient.put(url, data: { "code": code });
    return response;
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "https://va0lnfcg4a.execute-api.eu-west-2.amazonaws.com/prod/promotions";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080/promotions";
      } else {
        return "http://localhost:8080/promotions";
      }
    }
  }
}
