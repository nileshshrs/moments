import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? messageId;
  final String? conversation;
  final String? sender;
  final String? recipient;
  final String content;

  const MessageEntity({
    this.messageId,
    this.conversation,
    this.sender,
    this.recipient,
    required this.content,
  });

  // Empty constructor
  const MessageEntity.empty()
      : messageId = '',
        conversation = '',
        sender = '',
        recipient = '',
        content = '';

  @override
  List<Object?> get props => [
        messageId,
        conversation,
        sender,
        recipient,
        content,
      ];
}
