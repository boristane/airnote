import 'package:airnote/models/note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;
  final int id;
  List<Note> notes;

  User({this.email, this.id, this.name, this.notes});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}