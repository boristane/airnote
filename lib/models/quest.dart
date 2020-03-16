import 'package:airnote/models/routine.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quest.g.dart';

@JsonSerializable()
class Quest {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String shortDescription;
  final bool userHasJoined;
  final int stage;
  final List<Routine> routines;

  Quest(
      {this.id,
      this.name,
      this.imageUrl,
      this.routines,
      this.description,
      this.shortDescription,
      this.userHasJoined,
      this.stage});
  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
  Map<String, dynamic> toJson() => _$QuestToJson(this);
}
