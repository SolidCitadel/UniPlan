// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  picture: json['picture'] as String?,
  displayName: json['displayName'] as String?,
  role: json['role'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'picture': instance.picture,
  'displayName': instance.displayName,
  'role': instance.role,
  'status': instance.status,
};
