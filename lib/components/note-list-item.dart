import 'package:airnote/models/note.dart';
import 'package:airnote/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AirnoteNoteListItem extends StatelessWidget {
  final Note note;

  AirnoteNoteListItem({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroTag = "note-image-${note.id}";
    return Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        height: 150,
        child: Stack(children: <Widget>[
          _NoteHeader(
            heroTag: heroTag,
            imageUrl: note.imageUrl,
          ),
          Positioned(
            top: 75.0,
            child: _NoteDescription(note: note),
          )
        ]));
  }
}

class _NoteHeader extends StatelessWidget {
  final String heroTag;
  final String imageUrl;

  _NoteHeader({Key key, this.imageUrl, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => _NoteImage(
        heroTag: heroTag,
        imageProvider: imageProvider,
      ),
      placeholder: (context, url) => _NoteImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
      errorWidget: (context, url, error) => _NoteImage(
        heroTag: heroTag,
        imageProvider: AssetImage("assets/placeholder.jpg"),
      ),
    );
  }
}

class _NoteImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  _NoteImage({Key key, this.heroTag, this.imageProvider}) : super(key: key);

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

class _NoteDescription extends StatelessWidget {
  final Note note;

  _NoteDescription({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(note.createdAt);
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(date);
    return Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.title,
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
