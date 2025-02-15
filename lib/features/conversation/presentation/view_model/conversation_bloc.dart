import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moments/app/di/di.dart';
import 'package:moments/core/network/socket_service.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/use_case/create_conversation_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/create_message_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_connections_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_conversations_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_messages_usecase.dart';
import 'package:moments/features/conversation/presentation/view/message_screen.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final GetConversationsUsecase _getConversationsUsecase;
  final GetConnectionsUsecase _getConnectionsUsecase;
  final CreateConversationUsecase _createConversationUsecase;
  final GetMessagesUsecase _getMessagesUsecase;
  final CreateMessageUsecase _createMessageUsecase;
  final SocketService _socketService;

  ConversationBloc(
      {required GetConversationsUsecase getConversationUsecase,
      required GetConnectionsUsecase getConnectionsUsecase,
      required CreateConversationUsecase createConversationUsecase,
      required GetMessagesUsecase getMessagesUsecase,
      required CreateMessageUsecase createMessageUsecase,
      required SocketService socketService})
      : _getConversationsUsecase = getConversationUsecase,
        _getConnectionsUsecase = getConnectionsUsecase,
        _createConversationUsecase = createConversationUsecase,
        _getMessagesUsecase = getMessagesUsecase,
        _createMessageUsecase = createMessageUsecase,
        _socketService = socketService,
        super(ConversationState.initial()) {
    on<LoadConversations>(_loadConversation);
    on<LoadConnections>(_loadConnections);
    on<CreateConversations>(_createConversation);
    on<FetchMessage>(_fetchMessage);
    on<CreateMessages>(_createMessages);
    // add(LoadConversations());
    // add(LoadConnections());
    on<ReceivedMessage>(_handleReceivedMessage);

    _socketService.onMessageReceived((newMessageData) {
      // print(newMessageData);
      final newMessage = MessageDTO.fromJson(newMessageData);
      add(ReceivedMessage(newMessageData: newMessage));
    });
  }

  Future<void> _loadConversation(
      LoadConversations event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final results = await _getConversationsUsecase.call();
    results.fold(
        (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
        (conversation) {
      // print(conversation);
      emit(state.copyWith(
          isLoading: false, isSuccess: true, conversation: conversation));
    });
  }

  Future<void> _loadConnections(
      LoadConnections event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final results = await _getConnectionsUsecase.call();
    results.fold(
        (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
        (connections) {
      emit(state.copyWith(
          isLoading: false, isSuccess: true, connections: connections));
    });
  }

  Future<void> _createConversation(
      CreateConversations event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    try {
      final params = CreateConversationParams(
        userID: event.userID,
        connectionID: event.connectionID,
      );
      final result = await _createConversationUsecase.call(params);
      result.fold(
        (failure) => emit(state.copyWith(isLoading: false, isSuccess: false)),
        (chat) {
          emit(state.copyWith(isLoading: false, isSuccess: true, chat: chat));
          add(LoadConversations());

          Navigator.of(event.context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: getIt<
                    ConversationBloc>(), //  Use stored reference instead of accessing context again
                child: MessageScreen(conversation: chat),
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      print(e);
    }
  }

  Future<void> _fetchMessage(
      FetchMessage event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final params = GetMessagesParams(
        id: event.conversation.id!); // Correctly wrap the parameter
    final results = await _getMessagesUsecase.call(params);

    results.fold((failure) {
      // print(failure);
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
      ));
    }, (messages) {
      // print("conversation bloc $messages");
      final reversedMessages = messages.reversed.toList();
      emit(state.copyWith(
          isLoading: false, isSuccess: true, messages: reversedMessages, chat: event.conversation));
    });
  }

  Future<void> _createMessages(
      CreateMessages event, Emitter<ConversationState> emit) async {
    emit(state.copyWith(isSuccess: false));

    final params = CreateMessageParams(
        conversationId: event.conversationID,
        content: event.content,
        recipient: event.recipient);

    final results = await _createMessageUsecase.call(params);

    results.fold((failure) {
      emit(state.copyWith(isLoading: false, isSuccess: false));
      print("failure: $failure");
    }, (newMessage) {
      // ✅ Update the messages list without reloading everything
      _socketService.sendMessage({
        "newMessage": {
          "_id": newMessage.id,
          "conversation": newMessage.conversation,
          "sender": {
            "_id": newMessage.sender?.id,
            "username": newMessage.sender?.username,
            "image": newMessage.sender?.image,
          },
          "recipient": {
            "_id": newMessage.recipient?.id,
            "username": newMessage.recipient?.username,
            "image": newMessage.recipient?.image,
          },
          "content": newMessage.content,
          "createdAt": DateTime.now().toIso8601String(),
        }
      });
      final updatedMessages = List<MessageDTO>.from(state.messages ?? []);
      updatedMessages.insert(0, newMessage);

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        messages: updatedMessages, // Only updating messages
      ));
    });
  }

  void _handleReceivedMessage(
      ReceivedMessage event, Emitter<ConversationState> emit) {
    final newMessage = event
        .newMessageData; // ✅ No need to parse JSON since it's already a MessageDTO
    print(state.chat?.id);
    print(newMessage.conversation);

    if (newMessage.conversation == state.chat?.id) {
      final updatedMessages = List<MessageDTO>.from(state.messages ?? []);
      updatedMessages.insert(0, newMessage);

      emit(state.copyWith(messages: updatedMessages));
    } else {
      add(LoadConversations());
    }
  }
}
