import 'package:airnote/models/entry.dart';
import 'package:airnote/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AirnoteEntryListItem extends StatelessWidget {
  final Entry entry;

  AirnoteEntryListItem({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroTag = "entry-image-${entry.id}";
    return Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        height: 150,
        decoration: BoxDecoration(
          color: AirnoteColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: AirnoteColors.primary.withOpacity(.5),
                offset: Offset(1.0, 3.0),
                blurRadius: 5.0),
          ],
        ),
        child: Stack(children: <Widget>[
          _EntryHeader(
            heroTag: heroTag,
            imageUrl: entry.imageUrl,
          ),
          Positioned(
            top: 75.0,
            child: _EntryDescription(entry: entry),
          )
        ]));
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
      imageBuilder: (context, imageProvider) => _EntryImage(
        heroTag: heroTag,
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _EntryImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _EntryImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}

class _EntryImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  _EntryImage({Key key, this.heroTag, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Stack(children: <Widget>[
        Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          height: 150,
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
