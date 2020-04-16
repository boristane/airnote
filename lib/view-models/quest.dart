import 'package:airnote/models/quest.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/quest.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/view-models/base.dart';
import 'package:dio/dio.dart';

class QuestViewModel extends BaseViewModel {
  List<Quest> _quests;
  List<Quest> _userQuests;
  String _message;
  Quest _currentQuest;
  Quest _topPickQuest;
  final _dialogService = locator<DialogService>();

  String get message => _message;
  List<Quest> get quests => _quests;
  List<Quest> get userQuests => _userQuests;
  Quest get currentQuest => _currentQuest;
  Quest get topPickQuest => _topPickQuest;

  final _questService = locator<QuestService>();

  Future<void> getQuests() async {
    setStatus(ViewStatus.LOADING);
    try {
      _message = "";
      await _questService.setupClient();
      final response = await _questService.getQuests();
      final List<dynamic> quests = response.data["quests"] ?? [];
      final List<dynamic> userQuests = response.data["userQuests"] ?? [];
      final dynamic topPickQuest = response.data["topPickQuest"] ?? [];
      _quests = List<Quest>.from(quests.map((n) => Quest.fromJson(n)));
      _userQuests = List<Quest>.from(userQuests.map((n) => Quest.fromJson(n)));
      _topPickQuest = Quest.fromJson(topPickQuest);
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
      _currentQuest = Quest.fromJson(response.data["quest"]);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () => setStatus(ViewStatus.READY));
    }
    setStatus(ViewStatus.READY);
    return success;
  }

  clearCurrentQuest() {
    _currentQuest = null;
  }

  Future<bool> joinQuest(int id) async {
    bool success = false;
    try {
      _message = "";
      _questService.setupClient();
      await _questService.joinQuest(id);
      success = true;
    } on DioError catch(err) {
      final data = err.response?.data ?? {};
      final message = (data is String) ? AirnoteMessage.unknownError : data["message"] ?? AirnoteMessage.unknownError;
      _dialogService.showInfoDialog(title: AirnoteMessage.defaultErrorDialogTitle, content: message, onPressed: () {});
    }
    return success;
  }
}