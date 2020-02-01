import 'package:airnote/models/note.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/note.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class NoteViewModel extends BaseViewModel {
  List<Note> _notes;
  String _message;
  Note _currentNote;
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<Note> get notes => _notes;
  Note get currentNote => _currentNote;

  final _noteService = locator<NotesService>();

  Future<void> getNotes() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _noteService.setupClient();
      final response = await _noteService.getNotes();
      final List<dynamic> data = response.data["notes"] ?? [];
      _notes = List<Note>.from(data.map((n) => Note.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      _message = data["message"] ?? AirnoteMessage.UnknownError;
    }
    setStatus(ViewStatus.READY);
  }

  Future<bool> getCurrentNote(int id) async {
    setStatus(ViewStatus.LOADING);
    bool success = false;
    try {
      _message = "";
      _noteService.setupClient();
      final response = await _noteService.getSingleNote(id);
      _currentNote = Note.fromJson(response.data);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showInfoDialog(title: "Ooops!", content: message, onPressed: () => {});
    }
    setStatus(ViewStatus.READY);
    return success;
  }

  Future<void> deleteCurrentNote(int id) async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      _noteService.setupClient();
      await _noteService.deleteNote(id);
      // _currentNote = null;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showInfoDialog(title: "Ooops!", content: message, onPressed: () => {});
    }
    setStatus(ViewStatus.READY);
  }

}