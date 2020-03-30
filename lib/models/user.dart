import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String forename;
  final String surname;
  final String email;
  final String uuid;
  final String encryptionKey;
  final int membership;

  User({this.email, this.uuid, this.surname, this.forename, this.encryptionKey, this.membership});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}