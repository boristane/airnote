import 'package:airnote/components/entry-list-item.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopPickQuest extends StatelessWidget {
  final Quest quest;
  TopPickQuest({Key key, this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heroTag = "quest-image-${quest.id}";
    final height = MediaQuery.of(context).size.height * 3 / 7;
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: AirnoteColors.grey.withOpacity(.5),
              offset: Offset(3.0, 3.0),
              blurRadius: 5.0),
        ],
      ),
      child: Stack(
        children: <Widget>[
          ImageHeader(
            heroTag: heroTag,
            imageUrl: quest.imageUrl,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _TopPickDate(),
                  _QuestDescription(quest: quest),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestDescription extends StatelessWidget {
  final Quest quest;

  _QuestDescription({Key key, this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              quest.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AirnoteColors.white,
                  fontSize: 20,
                  letterSpacing: 1.0,
                  fontFamily: "Raleway"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                quest.shortDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AirnoteColors.white,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ));
  }
}

class _TopPickDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final formatter = new DateFormat("MMM d, y");
    final dateString = formatter.format(date);
    return Container(
      child: Text(
        dateString,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AirnoteColors.white,
            letterSpacing: 1.0,
            fontFamily: "Raleway"),
      ),
    );
  }
}
