import 'dart:async';

import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/models/prompt.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Routine extends StatefulWidget {
  static const routeName = "create-entry-intro";
  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                _RoutineHeader(
                  heroTag: "heroTag",
                  imageUrl: routine.imageUrl,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: AirnoteOptionButton(
                    icon: Icon(Icons.arrow_downward),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  height: 120,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    routine.name,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AirnoteColors.grey,
                        letterSpacing: 1.0,
                        fontFamily: "Raleway"),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.all(15),
              child: Text(routine.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AirnoteColors.grey,
                      fontFamily: "Raleway",
                      fontSize: 18)),
            ),
            Divider(),
            Flexible(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
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
    return ListTile(
      title: Text(
        item.text,
        style: TextStyle(
            color: AirnoteColors.grey, fontFamily: "Raleway", fontSize: 18),
      ),
      subtitle: Text(
        "Duration: ${millisecondsToTimeString(item.duration)}",
        style: TextStyle(color: AirnoteColors.inactive),
      ),
    );
  }
}

class _RoutineHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  _RoutineHeader({Key key, this.imageUrl, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _RoutineHeaderImage(
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _RoutineHeaderImage(
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _RoutineHeaderImage(
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}

class _RoutineHeaderImage extends StatelessWidget {
  final ImageProvider imageProvider;

  _RoutineHeaderImage({Key key, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 149,
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AirnoteColors.backgroundColor.withOpacity(0.0),
              AirnoteColors.backgroundColor
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ],
    );
  }
}

String millisecondsToTimeString(int ms) {
  final duration = Duration(milliseconds: ms);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
}
