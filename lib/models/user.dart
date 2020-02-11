import 'package:airnote/models/entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String forename;
  final String surname;
  final String email;
  final String uuid;

  User({this.email, this.uuid, this.surname, this.forename});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}