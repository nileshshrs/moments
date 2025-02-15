import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String? conversationId;
  final List<String> participants;
  final String? lastMessage;
  final String? title; // Reference to the User who deleted the conversation
  final String? read;

  const ConversationEntity({
    this.conversationId,
    required this.participants,
    this.lastMessage,
    this.title,
    this.read,
  });

  @override
  List<Object?> get props => [
        conversationId,
        participants,
        lastMessage,
        title,
        read,
      ];
}
