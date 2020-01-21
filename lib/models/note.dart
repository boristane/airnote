import 'package:airnote/models/sentiment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String audioUrl;
  final String createdAt;
  final List<Sentiment> sentiments;

  Note({this.id, this.content, this.createdAt, this.imageUrl, this.title, this.audioUrl, this.sentiments});
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}