import 'package:airnote/components/loading.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/quest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestsList extends StatefulWidget {
  @override
  State<QuestsList> createState() => _QuestsListState();
}

class _QuestsListState extends State<QuestsList> {
  QuestViewModel _questViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _questViewModel = Provider.of<QuestViewModel>(context);
    if (this._questViewModel == _questViewModel) {
      return;
    }
    this._questViewModel = _questViewModel;
    Future.microtask(this._questViewModel.getQuests);
  }

  _openQuest(Quest quest) async {
    print("opening a quest");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(child: Consumer<QuestViewModel>(
        builder: (context, model, child) {
          List<Quest> quests = model.quests;
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
          if (quests.length < 1) return NoQuestFound();
          return Column(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: ListView.builder(
                      itemCount: quests.length,
                      itemBuilder: (BuildContext context, int index) {
                        final quest = quests[index];
                        return GestureDetector(
                            onTap: () async {
                              await _openQuest(quest);
                            },
                            child: Text(quest.name));
                      }),
                ),
              ),
            ],
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
