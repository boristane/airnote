import 'package:json_annotation/json_annotation.dart';

part 'notifications-user.g.dart';

@JsonSerializable()
class NotificationsUser {
  final String uuid;
  final String reminderTime;
  final List<_Topic> topics;

  NotificationsUser({this.topics, this.uuid, this.reminderTime});
  factory NotificationsUser.fromJson(Map<String, dynamic> json) => _$NotificationsUserFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsUserToJson(this);
}

@JsonSerializable()
class _Topic {
  final String name;
  final bool value;

  _Topic({this.name, this.value});
  factory _Topic.fromJson(Map<String, dynamic> json) => _$_TopicFromJson(json);
  Map<String, dynamic> toJson() => _$_TopicToJson(this);
}