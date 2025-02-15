import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';

@JsonSerializable()
class ConversationModel extends Equatable {
  @JsonKey(name: '_id')
  final String? conversationId;
  final List<String> participants;
  final String? lastMessage;
  final String? title; // Reference to the User who deleted the conversation
  final String? read;

  const ConversationModel({
    this.conversationId,
    required this.participants,
    this.lastMessage,
    this.title,
    this.read,
  });

  ConversationModel.empty()
      : conversationId = '',
        participants = [],
        lastMessage = '',
        title = null,
        read = null;

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['_id'] as String?,
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : [],
      lastMessage: json['lastMessage'] as String?,
      title: json['title'] as String?,
      read: json['read'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': conversationId,
      'participants': participants,
      'lastMessage': lastMessage,
      'title': title,
      'read': read,
    };
  }

  // Convert API Object to Entity
  ConversationEntity toEntity() => ConversationEntity(
        conversationId: conversationId,
        participants: participants,
        lastMessage: lastMessage,
        title: title,
        read: read,
      );

  // Convert Entity to API Object
  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      conversationId: entity.conversationId,
      participants: entity.participants,
      lastMessage: entity.lastMessage,
      title: entity.title,
      read: entity.read,
    );
  }

  // Convert API List to Entity List
  static List<ConversationEntity> toEntityList(List<ConversationModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        conversationId,
        participants,
        lastMessage,
        title,
        read,
      ];
}
