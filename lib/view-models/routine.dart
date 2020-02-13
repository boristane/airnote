import 'package:airnote/models/routine.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/routine.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class RoutineViewModel extends BaseViewModel {
  List<RoutineItem> _routine;
  String _message;
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<RoutineItem> get routine => _routine;

  final _routineService = locator<RoutineService>();

  Future<void> getRoutine() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _routineService.setupClient();
      final response = await _routineService.getRoutine();
      final dynamic data = response.data["routine"] ?? [];
      _routine = List<RoutineItem>.from(data.map((n) => RoutineItem.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = (data is String || data is ResponseBody) ? AirnoteMessage.UnknownError : data["message"] ?? AirnoteMessage.UnknownError;
      _dialogService.showInfoDialog(title: "Ooops!", content: message, onPressed: () {});
    }
    setStatus(ViewStatus.READY);
  }
}