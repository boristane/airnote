import 'package:airnote/components/forward-button.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/models/prompt.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineView extends StatefulWidget {
  static const routeName = "routine";
  @override
  _RoutineViewState createState() => _RoutineViewState();
}

class _RoutineViewState extends State<RoutineView> {
  RoutineViewModel _routineViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getRoutine();
    });
  }

  _getRoutine() async {
    final routineViewModel = Provider.of<RoutineViewModel>(context);
    if (this._routineViewModel == routineViewModel) {
      return;
    }
    this._routineViewModel = routineViewModel;
    final id = ModalRoute.of(context).settings.arguments;
    final success = await this._routineViewModel.getRoutine(id);
    if (!success && Navigator.of(context).canPop()) {
      return Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RoutineViewModel>(builder: (context, model, child) {
        final prompts = model.prompts;
        final routine = model.routine;
        if (prompts == null) {
          return AirnoteLoadingScreen();
        }
        return Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    _RoutineHeader(
                      imageUrl: routine.imageUrl,
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      height: 260,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            routine.name,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: AirnoteColors.grey,
                                letterSpacing: 1.0),
                          ),
                          Text(
                            "Day ${routine.position}",
                            style: TextStyle(
                              color: AirnoteColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  child: Text(routine.description,
                      style:
                          TextStyle(color: AirnoteColors.grey, fontSize: 15)),
                ),
                Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: prompts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final prompt = prompts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PromptView(
                          item: prompt,
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 40),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please take your time, think about these before we start.",
                        textAlign: TextAlign.center,
                      )),
                )
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
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: AirnoteForwardButton(
                  text: "Start",
                  onTap: () {
                    Navigator.of(context).pushNamed(RecordEntry.routeName);
                  },
                ),
              ),
            )
          ],
        );
      }),
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
        style: TextStyle(color: AirnoteColors.grey, fontSize: 18,),
      ),
      subtitle: Text(
        "Duration: ${millisecondsToTimeString(item.duration)}",
        style: TextStyle(color: AirnoteColors.inactive),
      ),
    );
  }
}

class _RoutineHeader extends StatelessWidget {
  final String imageUrl;

  _RoutineHeader({Key key, this.imageUrl}) : super(key: key);
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
          height: 299,
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        ),
        Container(
          height: 300,
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
