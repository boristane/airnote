import 'package:airnote/components/badge.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class AirnoteEntryListItem extends StatelessWidget {
  final Entry entry;
  AirnoteEntryListItem({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroTag = "entry-image-${entry.id}";
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(children: <Widget>[
          ImageHeader(
            heroTag: heroTag,
            imageUrl: entry.imageUrl,
          ),
          Positioned(
            top: 75.0,
            child: _EntryDescription(entry: entry),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: _QuestIndicator(
                hasQuest: entry.quest != null,
              )),
          _EntryBlur(
            isLocked: entry.isLocked,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: entry.isLocked
                ? AirnoteBadge(
                    child: Icon(
                      Icons.lock,
                      size: 20,
                      color: AirnoteColors.primary,
                    ),
                  )
                : Container(),
          ),
        ]));
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
        heroTag: heroTag,
        imageProvider: imageProvider,
        topColor: topColor,
        bottomColor: bottomColor,
      ),
      placeholder: (context, url) => _GradientImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.png"),
        topColor: topColor,
        bottomColor: bottomColor,
      ),
      errorWidget: (context, url, error) => _GradientImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.png"),
        topColor: topColor,
        bottomColor: bottomColor,
      ),
    );
  }
}

class _GradientImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;
  final Color topColor;
  final Color bottomColor;

  _GradientImage(
      {Key key,
      this.heroTag,
      this.imageProvider,
      this.bottomColor,
      this.topColor})
      : super(key: key);

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
              topColor != null
                  ? topColor
                  : AirnoteColors.primary.withOpacity(0.0),
              bottomColor != null ? bottomColor : AirnoteColors.primary
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ]),
    );
  }
}

class _EntryDescription extends StatelessWidget {
  final Entry entry;

  _EntryDescription({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(entry.createdAt);
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(date);
    return Container(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            entry.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AirnoteColors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w700),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.event_note,
                size: 18,
                color: AirnoteColors.white.withOpacity(0.7),
              ),
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    dateString,
                    style: TextStyle(
                      color: AirnoteColors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ))
            ],
          ),
        ],
      ),
    ));
  }
}

class _EntryBlur extends StatelessWidget {
  final bool isLocked;

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

class _QuestIndicator extends StatelessWidget {
  final bool hasQuest;

  _QuestIndicator({Key key, this.hasQuest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasQuest
        ? AirnoteBadge(
            text: "Quest",
            isDark: false,
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
