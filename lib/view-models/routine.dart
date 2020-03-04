import 'package:airnote/models/prompt.dart';
import 'package:airnote/models/routine.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/routine.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class RoutineViewModel extends BaseViewModel {
  List<Prompt> _prompts;
  Routine _routine;
  String _message;
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<Prompt> get prompts => _prompts;
  Routine get routine => _routine;

  final _routineService = locator<RoutineService>();

  Future<void> getRoutine() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _routineService.setupClient();
      final response = await _routineService.getRoutine();
      final dynamic data = response.data["routine"] ?? [];
      _routine = Routine.fromJson(data);
      _prompts = _routine.prompts;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = (data is String || data is ResponseBody) ? AirnoteMessage.unknownError : data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () {});
    }
    setStatus(ViewStatus.READY);
  }
}