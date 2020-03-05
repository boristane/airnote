import 'package:airnote/services/api.dart';
import 'package:airnote/services/file-encryption.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/passphrase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'dart:io' show Platform;

typedef void OnError(Exception exception);

class EntryService {
  Dio _apiClient;
  static final String _baseUrl = _getEndpoint();
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  EntryService() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> getEntries() async {
    const url = "/";
    final response = await _apiClient.get(url);
    return response;
  }

  Future<Response> getSingleEntry(int id) async {
    final url = "/$id";
    final response = await _apiClient.get(url);
    return response;
  }

  Future<Response> postEntry(
      Map<String, String> data, String email, String encryptionKey) async {
    final url = "/";
    final fileEncryptionService = locator<FileEncryptionService>();
    final passPhraseService = locator<PassPhraseService>();
    final passPhrase = await passPhraseService.getPassPhrase(email);
    bool isEncrypted = false;
    if (passPhrase != null) {
      await fileEncryptionService.encryptFile(
          data["recording"], passPhrase, encryptionKey);
      isEncrypted = true;
    }
    final fileName = data["recording"].split("cache/")[1];
    await _saveRecordingToS3(data["recording"]);
    final requestBody = {
      "title": data["title"],
      "duration": data["duration"],
      "recording": fileName,
      "isEncrypted": isEncrypted,
    };

    final response = _apiClient.post(url, data: requestBody);
    return response;
  }

  Future<Response> deleteEntry(int id) {
    final url = "/$id";
    final response = _apiClient.delete(url);
    return response;
  }

  Future<Response> updateIsLockedEntry(int id, bool lock) {
    final url = "/lock/$id";
    final response = _apiClient.post(url, data: {"isLocked": lock});
    return response;
  }

  Future<void> setupClient() async {
    await _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<String> loadRecording(
      int id, bool isEncrypted, String email, String encryptionKey) async {
    final dir = await getTemporaryDirectory();
    final url = await this._getReadS3Url(id);
    await Dio().download(url, "${dir.path}/audio.aac");
    final file = new File("${dir.path}/audio.aac");
    if (await file.exists()) {
      if (isEncrypted) {
        final passPhraseService = locator<PassPhraseService>();
        final encryptionService = locator<FileEncryptionService>();
        final passPhrase = await passPhraseService.getPassPhrase(email);
        await encryptionService.decryptFile(
            file.path, passPhrase, encryptionKey);
      }
      return file.path;
    }
    return "";
  }

  Future<String> _getReadS3Url(int id) async {
    return (await this._apiClient.get("/recording/$id")).data["url"];
  }

  Future<String> _getWriteS3Url(String filename) async {
    return (await this
            ._apiClient
            .get("/put-url/1", queryParameters: {"filePath": filename}))
        .data["url"];
  }

  Future<void> _saveRecordingToS3(localFilePath) async{
    final file = new File(localFilePath);
    final fileName = localFilePath.split("cache/")[1];
    final s3Url = await this._getWriteS3Url(fileName);
    await Dio().put(
      s3Url,
      data: file.openRead(),
      options: Options(
        headers: {
          Headers.contentLengthHeader: await file.length(),
          Headers.contentTypeHeader: MediaType("audio", "aac"),
        },
      ),
    );
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "http://ec2-3-8-125-65.eu-west-2.compute.amazonaws.com/entries";
    } else {
      if (Platform.isAndroid) {
        return "http://10.0.2.2:8080/entries";
      } else {
        return "http://localhost:8080/entries";
      }
    }
  }
}
