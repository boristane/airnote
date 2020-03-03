import 'package:airnote/models/routine.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quest.g.dart';

@JsonSerializable()
class Quest {
  final int id;
  final String name;
  final String imageUrl;
  final List<Routine> routines;

  Quest({this.id, this.name, this.imageUrl, this.routines});
  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
  Map<String, dynamic> toJson() => _$QuestToJson(this);
}