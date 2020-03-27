import 'package:airnote/components/loading.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/models/transcript.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteEntryPanel extends StatelessWidget {
  final Entry entry;
  final ScrollController scrollController;
  AirnoteEntryPanel({Key key, this.entry, this.scrollController})
      : super(key: key);

  Widget getContent(Transcript transcript) {
    final isTranscribed = transcript.isTranscribed;
    final content = transcript.content;
    final isTranscriptionSubmitted = transcript.isTranscriptionSubmitted;
    if (isTranscribed && content != null) {
      return Text(
        content,
        softWrap: true,
      );
    }

    if (isTranscriptionSubmitted && !isTranscribed) {
      return Center(
        child: Text(
            "I am currently transcribing your recording, please check back in a few moments."),
      );
    }

    if (!isTranscriptionSubmitted) {
      return Center(
        child: Text("There are no transcripts for this entry."),
      );
    }

    return Center(
      child: Text(
          "There was a problem with this transcript. Please contact the Lesley team."),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return AirnoteLoadingScreen();
    }
    final transcript = entry.transcript;
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
              height: 20.0,
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
              child: getContent(transcript),
            ),
          ],
        ));
  }
}