import 'dart:async';

import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/models/prompt.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEntryIntro extends StatefulWidget {
  static const routeName = "create-entry-intro";
  @override
  _CreateEntryIntroState createState() => _CreateEntryIntroState();
}

class _CreateEntryIntroState extends State<CreateEntryIntro> {
  RoutineViewModel _routineViewModel;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final _routineViewModel = Provider.of<RoutineViewModel>(context);
    if (this._routineViewModel == _routineViewModel) {
      return;
    }
    this._routineViewModel = _routineViewModel;
    Future.microtask(this._routineViewModel.getRoutine);
  }

  @override
  Widget build(BuildContext context) {
    final prompts = _routineViewModel.prompts;
    final routine = _routineViewModel.routine;
    if (prompts == null) {
      return AirnoteLoadingScreen();
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AirnoteOptionButton(
                icon: Icon(Icons.arrow_downward),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                child:
                    AirnoteHeaderText(text: routine.name),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: ListView.builder(
                      itemCount: prompts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final prompt = prompts[index];
                        return PromptView(
                          item: prompt,
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AirnoteColors.primary,
        child: Icon(
          Icons.arrow_forward,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(RecordEntry.routeName);
        },
      ),
    );
  }
}

class PromptView extends StatelessWidget {
  final Prompt item;

  PromptView({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0, color: AirnoteColors.grey),
                ),
              ),
              child: Text(
                item.text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontFamily: "Raleway"),
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 20, 2, 20),
              child: Text(millisecondsToTimeString(item.duration))),
        ],
      ),
    );
  }
}

String millisecondsToTimeString(int ms) {
  final duration = Duration(milliseconds: ms);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
}
