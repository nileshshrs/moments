// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionDTO _$ConnectionDTOFromJson(Map<String, dynamic> json) =>
    ConnectionDTO(
      id: json['_id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ConnectionDTOToJson(ConnectionDTO instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'image': instance.image,
    };
