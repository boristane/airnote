// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    uuid: json['uuid'] as String,
    surname: json['surname'] as String,
    forename: json['forename'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'forename': instance.forename,
      'surname': instance.surname,
      'email': instance.email,
      'uuid': instance.uuid,
    };
