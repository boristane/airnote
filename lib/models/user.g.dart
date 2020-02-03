// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    email: json['email'] as String,
    id: json['id'] as int,
    surname: json['surname'] as String,
    forename: json['forename'] as String,
    entries: (json['entries'] as List)
        ?.map(
            (e) => e == null ? null : Entry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'forename': instance.forename,
      'surname': instance.surname,
      'email': instance.email,
      'id': instance.id,
      'entries': instance.entries,
    };
