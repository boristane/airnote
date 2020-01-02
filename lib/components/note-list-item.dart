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
        margin: EdgeInsets.only(bottom: 15.0, top: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: MediaQuery.of(context).size.width * .9,
              maxHeight: 280,
              child: Stack(children: <Widget>[
                CachedNetworkImage(
                  imageUrl: note.imageUrl,
                  imageBuilder: (context, imageProvider) => AirnoteNoteImage(
                    heroTag: heroTag,
                    imageProvider: imageProvider,
                  ),
                  placeholder: (context, url) => AirnoteNoteImage(
                    heroTag: heroTag,
                    imageProvider: AssetImage("assets/placeholder.jpg"),
                  ),
                  errorWidget: (context, url, error) => AirnoteNoteImage(
                    heroTag: heroTag,
                    imageProvider: AssetImage("assets/placeholder.jpg"),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  top: 30.0,
                  child: AirnoteNoteDescription(note: note),
                )
              ]),
            ),
          ],
        ));
  }
}

class AirnoteNoteImage extends StatelessWidget {
  final String heroTag;
  final ImageProvider imageProvider;

  AirnoteNoteImage({Key key, this.heroTag, this.imageProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageProvider,
      child: Container(
        width: 200,
        height: 250,
        margin: EdgeInsets.only(left: 100),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(AirnoteColors.primary, BlendMode.lighten)
                  ),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF3C4858).withOpacity(.4),
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}


class AirnoteNoteDescription extends StatelessWidget {
  final Note note;

  AirnoteNoteDescription({Key key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(note.createdAt);
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(date);
    return Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
            color: AirnoteColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                note.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AirnoteColors.grey,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.event_note,
                          size: 18,
                          color: AirnoteColors.grey,
                        ),
                        Padding(
                            padding: EdgeInsets.all(8), child: Text(dateString))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_forward,
                          size: 26.0,
                          color: Colors.blueGrey,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
