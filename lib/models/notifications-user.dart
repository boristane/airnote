import 'package:json_annotation/json_annotation.dart';

part 'notifications-user.g.dart';

@JsonSerializable()
class NotifiCationsUser {
  final String uuid;
  final String reminderTime;
  final List<String> topics;

  NotifiCationsUser({this.topics, this.uuid, this.reminderTime});
  factory NotifiCationsUser.fromJson(Map<String, dynamic> json) => _$NotifiCationsUserFromJson(json);
  Map<String, dynamic> toJson() => _$NotifiCationsUserToJson(this);
}