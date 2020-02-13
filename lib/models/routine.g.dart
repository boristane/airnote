// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutineItem _$RoutineItemFromJson(Map<String, dynamic> json) {
  return RoutineItem(
    prompt: json['prompt'] as String,
    duration: json['duration'] as int,
  );
}

Map<String, dynamic> _$RoutineItemToJson(RoutineItem instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'prompt': instance.prompt,
    };
