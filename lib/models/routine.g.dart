// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Routine _$RoutineFromJson(Map<String, dynamic> json) {
  return Routine(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    position: json['position'] as int,
    prompts: (json['prompts'] as List)
        ?.map((e) =>
            e == null ? null : Prompt.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$RoutineToJson(Routine instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'position': instance.position,
      'prompts': instance.prompts,
    };
