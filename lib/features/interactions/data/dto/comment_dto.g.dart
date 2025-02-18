// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDTO _$CommentDTOFromJson(Map<String, dynamic> json) => CommentDTO(
      commentId: json['_id'] as String?,
      post: json['post'] as String,
      user: UserDTO.fromJson(json['user'] as Map<String, dynamic>),
      comment: json['comment'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentDTOToJson(CommentDTO instance) =>
    <String, dynamic>{
      '_id': instance.commentId,
      'post': instance.post,
      'user': instance.user,
      'comment': instance.comment,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      userId: json['_id'] as String,
      username: json['username'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      '_id': instance.userId,
      'username': instance.username,
      'image': instance.image,
    };
