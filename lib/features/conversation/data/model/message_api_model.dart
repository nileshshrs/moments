import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';

@JsonSerializable()
class MessageModel extends Equatable {
  @JsonKey(name: '_id')
  final String? messageId;
  final String? conversation;
  final String? sender;
  final String? recipient;
  final String content;

  const MessageModel({
    this.messageId,
    this.conversation,
    this.sender,
    this.recipient,
    required this.content,
  });

  // Empty constructor
  MessageModel.empty()
      : messageId = '',
        conversation = '',
        sender = '',
        recipient = '',
        content = '';

  // ✅ Factory: Convert JSON to Model
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['_id'] as String?,
      conversation: json['conversation'] as String?,
      sender: json['sender'] as String?,
      recipient: json['recipient'] as String?,
      content: json['content'] as String,
    );
  }

  // ✅ Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': messageId,
      'conversation': conversation,
      'sender': sender,
      'recipient': recipient,
      'content': content,
    };
  }

  // ✅ Convert API Model to Entity
  MessageEntity toEntity() => MessageEntity(
        messageId: messageId,
        conversation: conversation,
        sender: sender,
        recipient: recipient,
        content: content,
      );

  // ✅ Convert Entity to API Model
  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      messageId: entity.messageId,
      conversation: entity.conversation,
      sender: entity.sender,
      recipient: entity.recipient,
      content: entity.content,
    );
  }

  // ✅ Convert List of Models to List of Entities
  static List<MessageEntity> toEntityList(List<MessageModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        messageId,
        conversation,
        sender,
        recipient,
        content,
      ];
}
