import 'package:airnote/models/quest.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/quest.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class QuestViewModel extends BaseViewModel {
  List<Quest> _quests;
  String _message;
  Quest _currentQuest;
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<Quest> get quests => _quests;
  Quest get currentQuest => _currentQuest;

  final _questService = locator<QuestService>();

  Future<void> getQuests() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _questService.setupClient();
      final response = await _questService.getQuests();
      final List<dynamic> data = response.data["quests"] ?? [];
      _quests = List<Quest>.from(data.map((n) => Quest.fromJson(n)));
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      _message = data["message"] ?? AirnoteMessage.unknownError;
    }
    setStatus(ViewStatus.READY);
  }

  Future<bool> getQuest(int id) async {
    setStatus(ViewStatus.LOADING);
    bool success = false;
    try {
      _message = "";
      _questService.setupClient();
      final response = await _questService.getSingleQuest(id);
      _currentQuest = Quest.fromJson(response.data);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => setStatus(ViewStatus.READY));
    }
    setStatus(ViewStatus.READY);
    return success;
  }

  Future<void> joinQuest(int id) async {
    try {
      _message = "";
      _questService.setupClient();
      await _questService.joinQuest(id);
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = (data is String) ? AirnoteMessage.unknownError : data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () {});
    }
  }
}