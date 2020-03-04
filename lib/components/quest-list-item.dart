import 'package:airnote/models/quest.dart';
import 'package:airnote/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AirnoteQuestListItem extends StatelessWidget {
  final Quest quest;
  AirnoteQuestListItem({Key key, this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroTag = "quest-image-${quest.id}";
    return GridTile(
      footer: _QuestDescription(quest: quest),
      child: Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: _EntryHeader(
            heroTag: heroTag,
            imageUrl: quest.imageUrl,
          )),
    );
  }
}

class _EntryHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  _EntryHeader({Key key, this.imageUrl, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _QuestImage(
        heroTag: heroTag,
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _QuestImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _QuestImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}

class _QuestImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  _QuestImage({Key key, this.heroTag, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Stack(children: <Widget>[
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
              AirnoteColors.primary.withOpacity(0.0),
              AirnoteColors.primary
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ]),
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
            fontFamily: "Raleway"),
      ),
    ));
  }
}

class _EntryBlur extends StatelessWidget {
  final isLocked;

  _EntryBlur({Key key, this.isLocked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLocked
        ? BlurryEffect(
            opacity: 0,
            blurry: 3,
            shade: Colors.transparent,
          )
        : Container();
  }
}

class BlurryEffect extends StatelessWidget {
  final double opacity;
  final double blurry;
  final Color shade;

  BlurryEffect({this.opacity, this.blurry, this.shade});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurry, sigmaY: blurry),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: shade.withOpacity(opacity),
            ),
          ),
        ),
      ),
    );
  }
}
