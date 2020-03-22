import 'package:airnote/components/loading.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteEntryPanel extends StatelessWidget {
  final Entry entry;
  final ScrollController scrollController;
  AirnoteEntryPanel({Key key, this.entry, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return AirnoteLoadingScreen();
    }
    final content = entry.transcript.content;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: scrollController,
          children: <Widget>[
            SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: AirnoteColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Transcript",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: content == null
                  ? Center(
                      child: Text("There are no transcripts for this entry"),
                    )
                  : Text(
                      content,
                      softWrap: true,
                    ),
            ),
          ],
        ));
  }
}