import 'package:airnote/services/api.dart';
import 'package:dio/dio.dart';

class NotesService {
  Dio _apiClient;
  // static final String _baseUrl =
  //     "http://ec2-3-8-125-65.eu-west-2.compute.amazonaws.com:8080/notes";
  static final String _baseUrl = "http://10.0.2.2:8080/notes";
  static ApiService _apiService = ApiService(baseUrl: _baseUrl);

  NotesService() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }

  Future<Response> getNotes() async {
    const url = "/";
    final response = await _apiClient.get(url);
    return response;
  }

  Future<Response> getSingleNote(int id) async {
    final url = "/$id";
    final response = await _apiClient.get(url);
    return response;
  }

  Future<Response> postNote(Map<String, String> data) async {
    final url = "/";
    final FormData formData = FormData.fromMap({
      "title": data["title"],
      "content": data["content"],
      "image":
          await MultipartFile.fromFile(data["image"], filename: "upload.txt")
    });

    final response = _apiClient.post(url, data: formData);
    return response;
  }

  Future<Response> deleteNote(int id) {
    final url = "/$id";
    final response = _apiClient.delete(url);
    return response;
  }

  void setupClient() {
    _apiService.clientSetup();
    this._apiClient = _apiService.client;
  }
}
