import 'dart:async';

import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/models/routine.dart';
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
    final routine = _routineViewModel.routine;
    if (routine == null) {
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
                child: Text("The routine"),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: ListView.builder(
                      itemCount: routine.length,
                      itemBuilder: (BuildContext context, int index) {
                        final routineItem = routine[index];
                        return RoutineItemView(
                          item: routineItem,
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

class RoutineItemView extends StatelessWidget {
  final RoutineItem item;

  RoutineItemView({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text("${item.prompt} -> ${item.duration}");
  }
}
