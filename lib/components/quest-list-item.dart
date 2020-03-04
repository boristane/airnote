import 'package:airnote/components/entry-list-item.dart';
import 'package:airnote/models/quest.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

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
          child: ImageHeader(
            heroTag: heroTag,
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
            fontFamily: "Raleway"),
      ),
    ));
  }
}

