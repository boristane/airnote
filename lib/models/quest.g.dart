// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quest _$QuestFromJson(Map<String, dynamic> json) {
  return Quest(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    routines: (json['routines'] as List)
        ?.map((e) =>
            e == null ? null : Routine.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    description: json['description'] as String,
    shortDescription: json['shortDescription'] as String,
  );
}

Map<String, dynamic> _$QuestToJson(Quest instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'routines': instance.routines,
    };
