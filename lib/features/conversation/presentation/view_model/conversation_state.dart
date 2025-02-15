part of 'conversation_bloc.dart';

class ConversationState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<ConversationDto>? conversation;
  final List<ConnectionDTO>? connections;
  final ConversationDto? chat; // Single conversation DTO
  final List<MessageDTO>? messages;
  const ConversationState({
    required this.isLoading,
    required this.isSuccess,
    this.conversation,
    this.connections,
    this.chat, // ✅ Included in constructor
    this.messages,
  });

  // Initial state
  factory ConversationState.initial() {
    return const ConversationState(
      isLoading: false,
      isSuccess: false,
      conversation: [],
      connections: [],
      chat: null, // ✅ Fixed missing chat
      messages: []
    );
  }

  // Copy with method for state updates
  ConversationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<ConversationDto>? conversation,
    List<ConnectionDTO>? connections,
    ConversationDto? chat, // ✅ Include chat in copyWith
    List<MessageDTO>? messages,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      conversation: conversation ?? this.conversation,
      connections: connections ?? this.connections,
      chat: chat ?? this.chat, // ✅ Ensure chat gets updated properly
      messages: messages?? this.messages
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isSuccess, conversation, connections, chat, messages];
}
