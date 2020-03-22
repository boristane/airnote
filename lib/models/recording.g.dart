// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recording _$RecordingFromJson(Map<String, dynamic> json) {
  return Recording(
    id: json['id'] as int,
    created: json['created'] as String,
    audioUrl: json['audioUrl'] as String,
    isEncrypted: json['isEncrypted'] as bool,
    backgroundMusic: json['backgroundMusic'] as String,
    duration: json['duration'] as int,
  );
}

Map<String, dynamic> _$RecordingToJson(Recording instance) => <String, dynamic>{
      'id': instance.id,
      'audioUrl': instance.audioUrl,
      'created': instance.created,
      'duration': instance.duration,
      'isEncrypted': instance.isEncrypted,
      'backgroundMusic': instance.backgroundMusic,
    };
