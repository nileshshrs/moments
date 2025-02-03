// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDTO _$PostDTOFromJson(Map<String, dynamic> json) => PostDTO(
      id: json['_id'] as String,
      user: UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$PostDTOToJson(PostDTO instance) => <String, dynamic>{
      '_id': instance.id,
      'user': instance.user,
      'content': instance.content,
      'image': instance.image,
      'createdAt': instance.createdAt,
    };

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      id: json['_id'] as String,
      username: json['username'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'image': instance.image,
    };
