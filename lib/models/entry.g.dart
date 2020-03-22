// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return Entry(
    id: json['id'] as int,
    created: json['created'] as String,
    imageUrl: json['imageUrl'] as String,
    title: json['title'] as String,
    sentiments: (json['sentiments'] as List)
        ?.map((e) =>
            e == null ? null : Sentiment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isLocked: json['isLocked'] as bool,
    routineId: json['routineId'] as int,
    transcript: json['transcript'] == null
        ? null
        : Transcript.fromJson(json['transcript'] as Map<String, dynamic>),
    backgroundMusic: json['backgroundMusic'] as String,
    recording: json['recording'] == null
        ? null
        : Recording.fromJson(json['recording'] as Map<String, dynamic>),
    questId: json['questId'] as int,
  );
}

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'created': instance.created,
      'backgroundMusic': instance.backgroundMusic,
      'isLocked': instance.isLocked,
      'routineId': instance.routineId,
      'questId': instance.questId,
      'recording': instance.recording,
      'transcript': instance.transcript,
      'sentiments': instance.sentiments,
    };
