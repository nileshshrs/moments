part of 'conversation_bloc.dart';

sealed class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class LoadConversations extends ConversationEvent {}

class LoadConnections extends ConversationEvent {}

class CreateConversations extends ConversationEvent {
  final String userID;
  final String connectionID;
  final BuildContext context;

  const CreateConversations(
      {required this.userID,
      required this.connectionID,
      required this.context});

  @override
  List<Object> get props => [userID, connectionID];
}

class FetchMessage extends ConversationEvent {
  final ConversationDto conversation;
  const FetchMessage({required this.conversation});

  @override
  List<Object> get props => [conversation];
}

class CreateMessages extends ConversationEvent {
  final String conversationID;
  final String content;
  final String recipient;

  const CreateMessages(
      {required this.conversationID,
      required this.content,
      required this.recipient});

  @override
  List<Object> get props => [conversationID, content, recipient];
}

class ReceivedMessage extends ConversationEvent {
  final MessageDTO newMessageData; // ✅ Ensure it's not nullable

  const ReceivedMessage({required this.newMessageData});

  @override
  List<Object> get props =>
      [newMessageData]; // ✅ Now it's List<Object> instead of List<Object?>
}

class UpdateConversation extends ConversationEvent {
  final String id;
  const UpdateConversation({required this.id});

  @override
  List<Object> get props => [id];
}
