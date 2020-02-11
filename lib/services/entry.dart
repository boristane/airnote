import 'dart:typed_data';

import 'package:airnote/services/api.dart';
import 'package:airnote/services/file-encryption.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/passphrase.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

typedef void OnError(Exception exception);

class EntryService {
  Dio _apiClient;
  // static final String _baseUrl =
  //     "http://ec2-3-8-125-65.eu-west-2.compute.amazonaws.com:8080/entries";
  static final String _baseUrl = "http://10.0.2.2:8080/entries";
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

  Future<Response> postEntry(Map<String, String> data, String email) async {
    final url = "/";
    final fileEncryptionService = locator<FileEncryptionService>();
    final passPhraseService = locator<PassPhraseService>();
    final passPhrase = await passPhraseService.getPassPhrase(email);
    bool isEncrypted = false;
    if (passPhrase != null) {
      await fileEncryptionService.encryptFile(data["recording"], passPhrase);
      isEncrypted = true;
    }
    final FormData formData = FormData.fromMap({
      "title": data["title"],
      "duration": data["duration"],
      "recording": await MultipartFile.fromFile(data["recording"],
          contentType: MediaType("audio", "aac")),
      "isEncrypted": isEncrypted
    });

    final response = _apiClient.post(url, data: formData);
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

  Future<String> loadRecording(int id) async {
    final bytes = await _streamRecordingBytes(id);

    final dir = await getTemporaryDirectory();
    final file = new File('${dir.path}/audio.aac');
    final sink = file.openWrite();
    bytes.listen((data) => sink.add(data),
        onDone: () => sink.close(), onError: (_) => sink.close());

    if (await file.exists()) {
      return file.path;
    }
    return "";
  }

  Future<Stream<Uint8List>> _streamRecordingBytes(int id) async {
    Stream<Uint8List> bytes;
    Response<ResponseBody> rs = await this._apiClient.get<ResponseBody>(
          "/recording/$id",
          options: Options(responseType: ResponseType.stream),
        );
    bytes = rs.data.stream;
    return bytes;
  }
}
