import 'package:airnote/components/header.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/quest-list-item.dart';
import 'package:airnote/components/smaller-header.dart';
import 'package:airnote/components/top-pick-quest.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/notifications.dart';
import 'package:airnote/view-models/quest.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/quest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestsList extends StatefulWidget {
  @override
  State<QuestsList> createState() => _QuestsListState();
}

class _QuestsListState extends State<QuestsList> {
  QuestViewModel _questViewModel;
  UserViewModel _userViewModel;
  NotificationsViewModel _notificationsViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final questViewModel = Provider.of<QuestViewModel>(context);
    if (this._questViewModel == questViewModel) {
      return;
    }
    _questViewModel = questViewModel;
    Future.microtask(this._questViewModel.getQuests);
    final userViewModel = Provider.of<UserViewModel>(context);
    if (_userViewModel == userViewModel) {
      return;
    }
    _userViewModel = userViewModel;
    final notificationsViewModel = Provider.of<NotificationsViewModel>(context);
    if (_notificationsViewModel == notificationsViewModel) {
      return;
    }
    _notificationsViewModel = notificationsViewModel;
    Future.microtask(() async {
      await _userViewModel.getUser();
      notificationsViewModel.initNotifications(_userViewModel.user);
    });
  }

  _openQuest(Quest quest) async {
    Navigator.of(context).pushNamed(QuestView.routeName, arguments: quest.id);
  }

  Widget _displayUserQuests(List<Quest> userQuests) {
    if (userQuests.length <= 0) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 25),
            child: AirnoteSmallerHeader(
              text: "Your Quests",
              subText: "Jump back in!",
            ),
          ),
          Container(
            height: 120,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: userQuests.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        await _openQuest(userQuests[index]);
                      },
                      child: Container(
                        width: size.width * 4 / 5,
                        padding: index == 0 ? EdgeInsets.only(right: 8, left: 25) : EdgeInsets.only(right: 8),
                        child: AirnoteQuestListItem(
                          quest: userQuests[index],
                        ),
                      ));
                }),
          ),
        ],
      ),
    );
  }

  Widget _displayMoreQuests(List<Quest> quests) {
    if (quests.length <= 0) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    final double itemHeight = 280;
    final double itemWidth = size.width / 2;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AirnoteSmallerHeader(
              text: "More Quests",
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            padding: EdgeInsets.only(bottom: 5.0),
            childAspectRatio: (itemWidth / itemHeight),
            children: List.generate(quests.length, (index) {
              return GestureDetector(
                onTap: () async {
                  await _openQuest(quests[index]);
                },
                child: AirnoteQuestListItem(
                  quest: quests[index],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(child: Consumer<QuestViewModel>(
        builder: (context, model, child) {
          List<Quest> quests = model.quests;
          List<Quest> userQuests = model.userQuests;
          Quest topPick = model.topPickQuest;
          if (model.getStatus() == ViewStatus.LOADING) {
            return AirnoteLoadingScreen();
          }
          if (quests == null) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              alignment: Alignment.center,
              child: Text("Ooops ! There was a problem getting the data..."),
            );
          }
          if (quests.length < 1 && userQuests.length < 1) return NoQuestFound();
          final message = userQuests.length < 1 ? "Let's join a quest" : "Let's continue your quest";
          return Container(
            child: ListView(
              children: <Widget>[
                Container(
                  child: AirnoteHeader(text: "Hi ${_userViewModel.user.forename}!", subText: message,),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(30),
                  ),
                GestureDetector(
                  onTap: () async {
                    await _openQuest(topPick);
                  },
                  child: TopPickQuest(
                    quest: topPick,
                  ),
                ),
                _displayUserQuests(userQuests),
                _displayMoreQuests(quests),
              ],
            ),
          );
        },
      )),
    );
  }
}

class NoQuestFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          alignment: Alignment.center,
          child: Text(
            "There are no quest, yet!",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text("Press the + button to start recording"),
        )
      ],
    );
  }
}
