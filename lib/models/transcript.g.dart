// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transcript _$TranscriptFromJson(Map<String, dynamic> json) {
  return Transcript(
    id: json['id'] as int,
    content: json['content'] as String,
    created: json['created'] as String,
    isEncrypted: json['isEncrypted'] as bool,
    isTranscribed: json['isTranscribed'] as bool,
    isTranscriptionSubmitted: json['isTranscriptionSubmitted'] as bool,
  );
}

Map<String, dynamic> _$TranscriptToJson(Transcript instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'created': instance.created,
      'isEncrypted': instance.isEncrypted,
      'isTranscribed': instance.isTranscribed,
      'isTranscriptionSubmitted': instance.isTranscriptionSubmitted,
    };
