// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return Entry(
    id: json['id'] as int,
    content: json['content'] as String,
    createdAt: json['createdAt'] as String,
    imageUrl: json['imageUrl'] as String,
    title: json['title'] as String,
    audioUrl: json['audioUrl'] as String,
    sentiments: (json['sentiments'] as List)
        ?.map((e) =>
            e == null ? null : Sentiment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isLocked: json['isLocked'] as bool,
    isEncrypted: json['isEncrypted'] as bool,
    backgroundMusic: json['backgroundMusic'] as String,
  );
}

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'imageUrl': instance.imageUrl,
      'audioUrl': instance.audioUrl,
      'createdAt': instance.createdAt,
      'isLocked': instance.isLocked,
      'isEncrypted': instance.isEncrypted,
      'backgroundMusic': instance.backgroundMusic,
      'sentiments': instance.sentiments,
    };
