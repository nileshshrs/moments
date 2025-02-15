// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    ConversationDto(
      id: json['_id'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => Participants.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] as String?,
      title: json['title'] == null
          ? null
          : Participants.fromJson(json['title'] as Map<String, dynamic>),
      read: json['read'] as String?,
    );

Map<String, dynamic> _$ConversationDtoToJson(ConversationDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'title': instance.title,
      'read': instance.read,
    };

Participants _$ParticipantsFromJson(Map<String, dynamic> json) => Participants(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      image:
          (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ParticipantsToJson(Participants instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'image': instance.image,
    };
