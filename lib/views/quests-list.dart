import 'package:airnote/components/loading.dart';
import 'package:airnote/components/quest-list-item.dart';
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
          final size = MediaQuery.of(context).size;
          final double itemHeight = 280;
          final double itemWidth = size.width / 2;
          return Container(
            margin: EdgeInsets.all(15),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              shrinkWrap: true,
              childAspectRatio: (itemWidth / itemHeight),
              children: List.generate(quests.length, (index) {
                return AirnoteQuestListItem(quest: quests[index],);
                
              }),
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