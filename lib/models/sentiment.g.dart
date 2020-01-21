// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentiment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sentiment _$SentimentFromJson(Map<String, dynamic> json) {
  return Sentiment(
    id: json['id'] as int,
    name: json['name'] as String,
    createdAt: json['createdAt'] as String,
    strength: (json['strength'] as num)?.toDouble(),
    emoji: json['emoji'] as String,
  );
}

Map<String, dynamic> _$SentimentToJson(Sentiment instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'strength': instance.strength,
      'emoji': instance.emoji,
      'createdAt': instance.createdAt,
    };
