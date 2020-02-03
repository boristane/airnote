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
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<Entry> get entries => _entries;
  Entry get currentEntry => _currentEntry;

  final _noteService = locator<EntryService>();

  Future<void> getEntries() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _noteService.setupClient();
      final response = await _noteService.getEntries();
      final List<dynamic> data = response.data["entries"] ?? [];
      _entries = List<Entry>.from(data.map((n) => Entry.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      _message = data["message"] ?? AirnoteMessage.UnknownError;
    }
    setStatus(ViewStatus.READY);
  }

  Future<bool> getCurrentEntry(int id) async {
    setStatus(ViewStatus.LOADING);
    bool success = false;
    try {
      _message = "";
      _noteService.setupClient();
      final response = await _noteService.getSingleEntry(id);
      _currentEntry = Entry.fromJson(response.data);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showInfoDialog(title: "Ooops!", content: message, onPressed: () {setStatus(ViewStatus.READY);});
    }
    setStatus(ViewStatus.READY);
    return success;
  }

  Future<void> deleteCurrentEntry(int id) async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      _noteService.setupClient();
      await _noteService.deleteEntry(id);
      // _currentEntry = null;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showInfoDialog(title: "Ooops!", content: message, onPressed: () => {});
    }
    setStatus(ViewStatus.READY);
  }

}