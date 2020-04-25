import 'package:airnote/components/loading.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/models/transcript.dart';
import 'package:airnote/models/user.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/view-entry/entry.dart';
import 'package:airnote/views/premium.dart';
import 'package:flutter/material.dart';

class AirnoteEntryPanel extends StatelessWidget {
  final Entry entry;
  final User user;
  final String transcript;
  final ScrollController scrollController;
  AirnoteEntryPanel(
      {Key key, this.entry, this.scrollController, this.user, this.transcript})
      : super(key: key);

  Widget getContent(Transcript transcript) {
    final isTranscribed = transcript.isTranscribed;
    final content = transcript.content;
    final isTranscriptionSubmitted = transcript.isTranscriptionSubmitted;
    if (isTranscribed && content != null) {
      return Text(
        this.transcript,
        softWrap: true,
      );
    }

    if (isTranscriptionSubmitted && !isTranscribed) {
      return Center(
        child: Text(
          "I am currently transcribing your recording, please check back in a few moments.",
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!isTranscriptionSubmitted) {
      return Center(
        child: Text("There are no transcripts for this entry.",
            textAlign: TextAlign.center),
      );
    }

    return Center(
      child: Text(
          "There was a problem with this transcript. Please contact the Lesley team.",
          textAlign: TextAlign.center),
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
              child: user.membership > 0
                  ? getContent(transcript)
                  : AirnoteRaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(JoinPremium.routeName, (Route<dynamic> route) => route.settings.name == Root.routeName);
                      },
                      text: "Unlock",
                    ),
            ),
          ],
        ));
  }
}
