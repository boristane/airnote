import 'package:json_annotation/json_annotation.dart';

part 'sentiment.g.dart';

@JsonSerializable()
class Sentiment {
  final int id;
  final String name;
  final double strength;
  final String emoji;
  final String createdAt;

  Sentiment({this.id, this.name, this.createdAt, this.strength, this.emoji});
  factory Sentiment.fromJson(Map<String, dynamic> json) => _$SentimentFromJson(json);
  Map<String, dynamic> toJson() => _$SentimentToJson(this);
}