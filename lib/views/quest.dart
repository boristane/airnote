import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/models/routine.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/quest.dart';
import 'package:airnote/views/entry.dart';
import 'package:airnote/views/routine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestView extends StatefulWidget {
  static const routeName = "quest";
  @override
  _QuestViewState createState() => _QuestViewState();
}

class _QuestViewState extends State<QuestView> {
  QuestViewModel _questViewModel;

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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
                      child: Stack(
              children: <Widget>[
                EntryHeader(
                  imageUrl: quest.imageUrl,
                  heroTag: heroTag,
                ),
                SafeArea(
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
                        color: AirnoteColors.grey,
                        letterSpacing: 1.0,
                        fontFamily: "Raleway"),
                  ),
                ),
                Positioned(
                  top: 220,
                                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(15),
                    child: Text(quest.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 15,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AirnoteColors.grey,
                            fontFamily: "Raleway",
                            fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: AirnoteSubmitButton(
                icon: Icon(Icons.credit_card),
                text: "Join",
                onPressed: () async {
                  await _joinQuest(quest);
                },
              ))
        ],
      );
    }));
  }

  _joinQuest(Quest quest) async {
    await _questViewModel.joinQuest(quest.id);
    Navigator.of(context).pushNamed(RoutineView.routeName);
  }
}

class _RoutineDescription extends StatelessWidget {
  final Routine routine;

  _RoutineDescription({Key key, this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),
              child: _RoutineImage(
                imageUrl: routine.imageUrl,
              )),
          Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              routine.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 18,
                  color: AirnoteColors.white,
                  fontFamily: "Raleway"),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineImage extends StatelessWidget {
  final String imageUrl;

  _RoutineImage({Key key, this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _GradientImage(
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _GradientImage(
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _GradientImage(
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}

class _GradientImage extends StatelessWidget {
  final ImageProvider imageProvider;

  _GradientImage({Key key, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(60),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AirnoteColors.primary.withOpacity(0.0),
            AirnoteColors.primary.withOpacity(0.7)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(60),
        ),
      )
    ]);
  }
}
