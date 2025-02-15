// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDTO _$MessageDTOFromJson(Map<String, dynamic> json) => MessageDTO(
      id: json['_id'] as String?,
      conversation: json['conversation'] as String?,
      sender: json['sender'] == null
          ? null
          : UserReference.fromJson(json['sender'] as Map<String, dynamic>),
      recipient: json['recipient'] == null
          ? null
          : UserReference.fromJson(json['recipient'] as Map<String, dynamic>),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$MessageDTOToJson(MessageDTO instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'conversation': instance.conversation,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'content': instance.content,
    };

UserReference _$UserReferenceFromJson(Map<String, dynamic> json) =>
    UserReference(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      image:
          (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserReferenceToJson(UserReference instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'image': instance.image,
    };
