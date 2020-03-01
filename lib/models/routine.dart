import 'package:airnote/models/prompt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'routine.g.dart';

@JsonSerializable()
class Routine {
  final int id;
  final String name;
  final String imageUrl;
  final int position;
  final List<Prompt> prompts;

  Routine({this.id, this.name, this.imageUrl, this.position, this.prompts});
  factory Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);
  Map<String, dynamic> toJson() => _$RoutineToJson(this);
}