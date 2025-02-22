// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowDTO _$FollowDTOFromJson(Map<String, dynamic> json) => FollowDTO(
      followId: json['_id'] as String?,
      follower: UserDTO.fromJson(json['follower'] as Map<String, dynamic>),
      following: UserDTO.fromJson(json['following'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      match: json['match'] as bool?,
    );

Map<String, dynamic> _$FollowDTOToJson(FollowDTO instance) => <String, dynamic>{
      '_id': instance.followId,
      'follower': instance.follower,
      'following': instance.following,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'match': instance.match,
    };

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      id: json['_id'] as String?,
      username: json['username'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'image': instance.image,
      'email': instance.email,
    };
