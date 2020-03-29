// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications-user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsUser _$NotificationsUserFromJson(Map<String, dynamic> json) {
  return NotificationsUser(
    topics: (json['topics'] as List)
        ?.map((e) =>
            e == null ? null : _Topic.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    uuid: json['uuid'] as String,
    reminderTime: json['reminderTime'] as String,
  );
}

Map<String, dynamic> _$NotificationsUserToJson(NotificationsUser instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'reminderTime': instance.reminderTime,
      'topics': instance.topics,
    };

_Topic _$_TopicFromJson(Map<String, dynamic> json) {
  return _Topic(
    name: json['name'] as String,
    value: json['value'] as bool,
  );
}

Map<String, dynamic> _$_TopicToJson(_Topic instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
