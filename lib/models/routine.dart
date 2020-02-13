import 'package:json_annotation/json_annotation.dart';

part 'routine.g.dart';

@JsonSerializable()
class RoutineItem {
  final int duration;
  final String prompt;

  RoutineItem({this.prompt, this.duration});
  factory RoutineItem.fromJson(Map<String, dynamic> json) => _$RoutineItemFromJson(json);
  Map<String, dynamic> toJson() => _$RoutineItemToJson(this);
}