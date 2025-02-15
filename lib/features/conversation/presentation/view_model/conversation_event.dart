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
  final String conversationID;
  const FetchMessage({required this.conversationID});

  @override
  List<Object> get props => [conversationID];
}
