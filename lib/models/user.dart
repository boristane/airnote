import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String forename;
  final String surname;
  final String email;
  final String uuid;
  final String encryptionKey;

  User({this.email, this.uuid, this.surname, this.forename, this.encryptionKey});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}