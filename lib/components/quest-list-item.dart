import 'package:airnote/components/badge.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AirnoteQuestListItem extends StatelessWidget {
  final Quest quest;
  AirnoteQuestListItem({Key key, this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: _QuestDescription(quest: quest),
      header: _QuestHeader(quest: quest),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ImageHeader(
            imageUrl: quest.imageUrl,
          )),
    );
  }
}

class _QuestDescription extends StatelessWidget {
  final Quest quest;

  _QuestDescription({Key key, this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(15),
      child: Text(
        quest.name,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AirnoteColors.white,
          letterSpacing: 1.0,
        ),
      ),
    ));
  }
}

class _QuestHeader extends StatelessWidget {
  final Quest quest;

  _QuestHeader({Key key, this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quest.completed == null) return Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          quest.completed
              ? AirnoteBadge(
                  child: Icon(
                    Icons.check,
                    size: 20,
                    color: AirnoteColors.primary,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class ImageHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;
  final Color topColor;
  final Color bottomColor;

  ImageHeader(
      {Key key, this.imageUrl, this.heroTag, this.topColor, this.bottomColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _GradientImage(
        imageProvider: imageProvider,
        topColor: topColor,
        bottomColor: bottomColor,
      ),
      placeholder: (context, url) => _GradientImage(
        imageProvider: AssetImage("assets/images/placeholder.png"),
        bottomColor: bottomColor,
      ),
      errorWidget: (context, url, error) => _GradientImage(
        imageProvider: AssetImage("assets/images/placeholder.png"),
        topColor: topColor,
        bottomColor: bottomColor,
      ),
    );
  }
}

class _GradientImage extends StatelessWidget {
  final ImageProvider imageProvider;
  final Color topColor;
  final Color bottomColor;

  _GradientImage(
      {Key key,
      this.imageProvider,
      this.bottomColor,
      this.topColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              topColor != null
                  ? topColor
                  : AirnoteColors.primary.withOpacity(0.0),
              bottomColor != null ? bottomColor : AirnoteColors.primary
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ]);
  }
}
