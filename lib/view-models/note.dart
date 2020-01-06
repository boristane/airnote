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
      _noteService.setupClient();
      final response = await _noteService.getNotes();
      final List<dynamic> data = response.data ?? [];
      _notes = List<Note>.from(data.map((n) => Note.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      _message = data["message"] ?? AirnoteMessage.UnknownError;
    }
    setStatus(ViewStatus.READY);
  }

  Future<void> getCurrentNote(int id) async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      _noteService.setupClient();
      final response = await _noteService.getSingleNote(id);
      _currentNote = Note.fromJson(response.data);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showDialog("Ooops!", message, () => _dialogService.dialogCompleted);
    }
    setStatus(ViewStatus.READY);
  }

}