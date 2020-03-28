import 'package:airnote/models/entry.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/entry.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class EntryViewModel extends BaseViewModel {
  List<Entry> _entries;
  String _message;
  Entry _currentEntry;
  String _currentEntryRecording = "";
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<Entry> get entries => _entries;
  Entry get currentEntry => _currentEntry;
  String get currentEntryRecording => _currentEntryRecording;

  final _entryService = locator<EntryService>();

  Future<void> getEntries() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _entryService.setupClient();
      final response = await _entryService.getEntries();
      final List<dynamic> data = response.data["entries"] ?? [];
      _entries = List<Entry>.from(data.map((n) => Entry.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      _message = data["message"] ?? AirnoteMessage.unknownError;
    }
    setStatus(ViewStatus.READY);
  }

  Future<bool> getEntry(int id) async {
    setStatus(ViewStatus.LOADING);
    bool success = false;
    try {
      _message = "";
      _entryService.setupClient();
      final response = await _entryService.getSingleEntry(id);
      _currentEntry = Entry.fromJson(response.data);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => setStatus(ViewStatus.READY));
    }
    setStatus(ViewStatus.READY);
    return success;
  }

  Future<bool> getEntryByRoutine(int id) async {
    setStatus(ViewStatus.LOADING);
    bool success = false;
    try {
      _message = "";
      _entryService.setupClient();
      final response = await _entryService.getSingleEntryByRoutine(id);
      _currentEntry = Entry.fromJson(response.data);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => setStatus(ViewStatus.READY));
    }
    setStatus(ViewStatus.READY);
    return success;
  }

  Future<bool> createEntry(Map<String, String> formData, String email, String encryptionKey) async {
    setStatus(ViewStatus.LOADING);

    Response response;
    try {
      response = await _entryService.postEntry(formData, email, encryptionKey);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => {});
    }

    setStatus(ViewStatus.READY);
    return response?.statusCode == 200;
  }

  Future<void> deleteEntry(int id) async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      _entryService.setupClient();
      await _entryService.deleteEntry(id);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => setStatus(ViewStatus.READY));
    }
    setStatus(ViewStatus.READY);
  }

  Future<void> updateIsLocked(int id, bool newValue) async {
    try {
      _message = "";
      _entryService.setupClient();
      await _entryService.updateIsLockedEntry(id, newValue);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = (data is String) ? AirnoteMessage.unknownError : data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () {});
    }
  }

  Future<void> getRecording(int id, bool isEncrypted, String email, String encryptionKey) async {
    try {
      _message = "";
      _entryService.setupClient();
      final path = await _entryService.loadRecording(id, isEncrypted, email, encryptionKey);
      _currentEntryRecording= path;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = (data is String || data is ResponseBody) ? AirnoteMessage.unknownError : data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () {});
      _currentEntryRecording= "";
    }
  }
}