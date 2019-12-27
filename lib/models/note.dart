import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String createdAt;

  Note({this.id, this.content, this.createdAt, this.imageUrl, this.title});
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}