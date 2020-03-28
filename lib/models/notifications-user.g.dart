// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications-user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifiCationsUser _$NotifiCationsUserFromJson(Map<String, dynamic> json) {
  return NotifiCationsUser(
    topics: (json['topics'] as List)?.map((e) => e as String)?.toList(),
    uuid: json['uuid'] as String,
    reminderTime: json['reminderTime'] as String,
  );
}

Map<String, dynamic> _$NotifiCationsUserToJson(NotifiCationsUser instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'reminderTime': instance.reminderTime,
      'topics': instance.topics,
    };
