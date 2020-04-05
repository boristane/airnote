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
import 'package:path/path.dart' as path;

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

  Future<Response> getSingleEntryByRoutine(int id) async {
    final url = "/routine/$id";
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
    final fileName = path.basename(data["recording"]);
    await _saveRecordingToS3(data["recording"]);
    final requestBody = {
      "title": data["title"],
      "duration": data["duration"],
      "routine": data["routine"],
      "recording": fileName,
      "isEncrypted": isEncrypted,
    };

    final response = await _apiClient.post(url, data: requestBody);
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

  Future<String> _getWriteS3Url(String filename, String fileType, int fileSize) async {
    return (await this
            ._apiClient
            .get("/put-url/1", queryParameters: {"filePath": filename, "fileType": fileType, "fileSize": fileSize}))
        .data["url"];
  }

  Future<void> _saveRecordingToS3(localFilePath) async{
    final file = new File(localFilePath);
    final fileName = path.basename(file.path);
    final fileSize = await file.length();
    final fileType = MediaType("audio", "aac").type;
    final s3Url = await this._getWriteS3Url(fileName, fileType, fileSize);
    await Dio().put(
      s3Url,
      data: file.openRead(),
      options: Options(
        headers: {
          "content-length": fileSize,
          "content-Type": fileType,
        },
      ),
    );
  }

  static String _getEndpoint() {
    if (kReleaseMode) {
      return "https://3v02oweo38.execute-api.eu-west-1.amazonaws.com/dev/entries";
    } else {
      if (Platform.isAndroid) {
        return "https://3v02oweo38.execute-api.eu-west-1.amazonaws.com/dev/entries";
      } else {
        return "http://localhost:8080/entries";
      }
    }
  }
}
