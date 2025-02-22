// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDTO _$NotificationDTOFromJson(Map<String, dynamic> json) =>
    NotificationDTO(
      notificationId: json['_id'] as String?,
      read: json['read'] as bool,
      recipient: json['recipient'] as String,
      sender: SenderDTO.fromJson(json['sender'] as Map<String, dynamic>),
      post: json['post'] == null
          ? null
          : PostDTO.fromJson(json['post'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$NotificationDTOToJson(NotificationDTO instance) =>
    <String, dynamic>{
      '_id': instance.notificationId,
      'read': instance.read,
      'recipient': instance.recipient,
      'sender': instance.sender,
      'post': instance.post,
      'type': instance.type,
    };

SenderDTO _$SenderDTOFromJson(Map<String, dynamic> json) => SenderDTO(
      username: json['username'] as String,
      image: (json['image'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SenderDTOToJson(SenderDTO instance) => <String, dynamic>{
      'username': instance.username,
      'image': instance.image,
    };

PostDTO _$PostDTOFromJson(Map<String, dynamic> json) => PostDTO(
      image:
          (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PostDTOToJson(PostDTO instance) => <String, dynamic>{
      'image': instance.image,
    };
