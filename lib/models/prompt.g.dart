// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prompt _$PromptFromJson(Map<String, dynamic> json) {
  return Prompt(
    text: json['prompt'] as String,
    duration: json['duration'] as int,
  );
}

Map<String, dynamic> _$PromptToJson(Prompt instance) => <String, dynamic>{
      'duration': instance.duration,
      'prompt': instance.text,
    };
