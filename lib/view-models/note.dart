import 'package:airnote/models/note.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/note.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class NoteViewModel extends BaseViewModel {
  List<Note> _notes;
  String _message;

  String get message => _message;
  List<Note> get notes => _notes;

  final _noteService = locator<NotesService>();

  Future<void> getNotes() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      final response = await _noteService.getNotes();
      final List<dynamic> data = response.data ?? [];
      _notes = List<Note>.from(data.map((n) => Note.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      _message = data["message"] ?? AirnoteMessage.UnknownError;
    }
    setStatus(ViewStatus.READY);
  }

}