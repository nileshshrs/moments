part of 'conversation_bloc.dart';

class ConversationState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<ConversationDto>? conversation;
  final List<ConnectionDTO>? connections;
  final ConversationDto? chat; // Single conversation DTO
  final List<MessageDTO>? messages;
  final MessageDTO? message; // Made nullable

  const ConversationState({
    required this.isLoading,
    required this.isSuccess,
    this.conversation,
    this.connections,
    this.chat,
    this.messages,
    this.message,
  });

  // Initial state
  factory ConversationState.initial() {
    return const ConversationState(
      isLoading: false,
      isSuccess: false,
      conversation: [],
      connections: [],
      chat: null,
      messages: [],
      message: null, // Fixed missing message
    );
  }

  // Copy with method for state updates
  ConversationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<ConversationDto>? conversation,
    List<ConnectionDTO>? connections,
    ConversationDto? chat,
    List<MessageDTO>? messages,
    MessageDTO? message, // Made nullable
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      conversation: conversation ?? this.conversation,
      connections: connections ?? this.connections,
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      message: message ?? this.message, // Fixed missing comma
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        conversation,
        connections,
        chat,
        messages,
        message,
      ];
}
