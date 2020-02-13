import 'package:airnote/models/sentiment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry.g.dart';

@JsonSerializable()
class Entry {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String audioUrl;
  final String createdAt;
  final bool isLocked;
  final bool isEncrypted;
  final List<Sentiment> sentiments;

  Entry({this.id, this.content, this.createdAt, this.imageUrl, this.title, this.audioUrl, this.sentiments, this.isLocked, this.isEncrypted});
  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryToJson(this);
}