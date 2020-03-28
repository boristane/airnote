import 'package:airnote/components/checkbox.dart';
import 'package:airnote/components/forward-button.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/models/routine.dart';
import 'package:airnote/services/local-auth.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/view-models/quest.dart';
import 'package:airnote/views/home.dart';
import 'package:airnote/views/routine.dart';
import 'package:airnote/views/view-entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestView extends StatefulWidget {
  static const routeName = "quest";
  @override
  _QuestViewState createState() => _QuestViewState();
}

class _QuestViewState extends State<QuestView> {
  QuestViewModel _questViewModel;
  final LocalAuthService _localAuth = locator<LocalAuthService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getQuest();
    });
  }

  _getQuest() async {
    final questViewModel = Provider.of<QuestViewModel>(context);
    if (this._questViewModel == questViewModel) {
      return;
    }
    this._questViewModel = questViewModel;
    final id = ModalRoute.of(context).settings.arguments;
    final success = await this._questViewModel.getQuest(id);
    if (!success && Navigator.of(context).canPop()) {
      return Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<QuestViewModel>(builder: (context, model, child) {
        if (model.getStatus() == ViewStatus.LOADING) {
          return AirnoteLoadingScreen();
        }
        final quest = model.currentQuest;
        if (quest == null) {
          return AirnoteLoadingScreen();
        }
        final routines = quest.routines;
        final heroTag = "quest-image-${quest.id}";
        return Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    EntryHeader(
                      imageUrl: quest.imageUrl,
                      heroTag: heroTag,
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.only(top: 100),
                      height: 250,
                      alignment: Alignment.center,
                      child: Text(
                        quest.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AirnoteColors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(top: 220),
                          child: Text(quest.description,
                              softWrap: true,
                              style: TextStyle(
                                  color: AirnoteColors.grey, fontSize: 15)),
                        ),
                        _getCompletionStatus(quest),
                        ListTile(
                            contentPadding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            leading: Icon(Icons.show_chart),
                            title: Text(
                              "${routines.length} days",
                              style: TextStyle(color: AirnoteColors.grey),
                            )),
                        ListTile(
                            contentPadding: EdgeInsets.fromLTRB(50, 0, 50, 10),
                            leading: Icon(Icons.input),
                            title: Text(
                              "${routines.map((routine) => routine.prompts.length).fold(0, (t, e) => t + e)} prompts",
                              style: TextStyle(color: AirnoteColors.grey),
                            )),
                        ListTile(
                            contentPadding: EdgeInsets.fromLTRB(50, 0, 50, 50),
                            leading: Icon(Icons.timer),
                            title: Text(
                              "${(routines.map((routine) => routine.prompts.fold(0, (t, e) => t + e.duration)).fold(0, (t, e) => t + e) / 60000).round()} minutes",
                              style: TextStyle(color: AirnoteColors.grey),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: AirnoteOptionButton(
                    icon: Icon(Icons.arrow_downward),
                    onTap: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Home.routeName, (Route<dynamic> route) => false,
                            arguments: 0);
                      }
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  margin: EdgeInsets.all(15), child: _getActionButton(quest)),
            ),
          ],
        );
      }),
    );
  }

  Widget _getActionButton(Quest quest) {
    if (quest.completed) return Container();
    final label = quest.userHasJoined ? "Continue" : "Join";
    return AirnoteForwardButton(
        text: label,
        onTap: () async {
          if (quest.userHasJoined) {
            return _continueQuest(quest);
          }
          await _joinQuest(quest);
        });
  }

  _openEntryByRoutine(Routine routine) async {
    final EntryViewModel entryViewModel = Provider.of<EntryViewModel>(context);
    await entryViewModel.getEntryByRoutine(routine.id);
    final entry = entryViewModel.currentEntry;
    if(entry == null) return;
    if (entry.isLocked) {
      await _localAuth.authenticate();
      if (!_localAuth.isAuthenticated) {
        return;
      }
    }
    Navigator.of(context).pushNamed(EntryView.routeName, arguments: entry.id);
  }

  Widget _getCompletionStatus(Quest quest) {
    return quest.userHasJoined
        ? Container(
            height: 110,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: quest.routines.length,
                itemBuilder: (BuildContext context, int index) {
                  final completed = quest.stage > index + 1;
                  final routine = quest.routines[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        AirnoteCirclarCheckBox(
                          value: completed,
                          interactive: false,
                          onTap: () async {
                            if(!completed) return;
                            await _openEntryByRoutine(routine);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Day ${index + 1}"),
                        ),
                      ],
                    ),
                  );
                }),
          )
        : Container();
  }

  _joinQuest(Quest quest) async {
    final success = await _questViewModel.joinQuest(quest.id);
    if (success) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutineView.routeName, (Route<dynamic> route) => route.isFirst,
          arguments: quest.routines[0]?.id);
    }
  }

  _continueQuest(Quest quest) {
    final stage = quest.stage;
    if (stage > quest.routines.length || stage < 0) return;
    final routine = quest.routines.elementAt(stage - 1);
    Navigator.of(context)
        .pushNamed(RoutineView.routeName, arguments: routine.id);
  }
}
