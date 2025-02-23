// test/features/conversation/presentation/view_model/conversation_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/core/network/socket_service.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/use_case/create_conversation_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/create_message_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_connections_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_conversations_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/get_messages_usecase.dart';
import 'package:moments/features/conversation/domain/use_case/update_conversation_usecase.dart';
import 'package:moments/features/conversation/presentation/view/message_screen.dart';
import 'package:moments/features/conversation/presentation/view_model/conversation_bloc.dart';

/// Fakes for fallback values.
class FakeGetMessagesParams extends Fake implements GetMessagesParams {}
class FakeUpdateConversationParams extends Fake implements UpdateConversationParams {}

/// Mock classes.
class MockGetConversationsUsecase extends Mock implements GetConversationsUsecase {}
class MockGetConnectionsUsecase extends Mock implements GetConnectionsUsecase {}
class MockCreateConversationUsecase extends Mock implements CreateConversationUsecase {}
class MockGetMessagesUsecase extends Mock implements GetMessagesUsecase {}
class MockCreateMessageUsecase extends Mock implements CreateMessageUsecase {}
class MockUpdateConversationUsecase extends Mock implements UpdateConversationUsecase {}
class MockSocketService extends Mock implements SocketService {}

void main() {
  // Ensure binding is initialized.
  TestWidgetsFlutterBinding.ensureInitialized();

  // Register fallback values.
  setUpAll(() {
    registerFallbackValue(FakeGetMessagesParams());
    registerFallbackValue(FakeUpdateConversationParams());
  });

  late MockGetConversationsUsecase mockGetConversationsUsecase;
  late MockGetConnectionsUsecase mockGetConnectionsUsecase;
  late MockCreateConversationUsecase mockCreateConversationUsecase;
  late MockGetMessagesUsecase mockGetMessagesUsecase;
  late MockCreateMessageUsecase mockCreateMessageUsecase;
  late MockUpdateConversationUsecase mockUpdateConversationUsecase;
  late MockSocketService mockSocketService;

  setUp(() {
    mockGetConversationsUsecase = MockGetConversationsUsecase();
    mockGetConnectionsUsecase = MockGetConnectionsUsecase();
    mockCreateConversationUsecase = MockCreateConversationUsecase();
    mockGetMessagesUsecase = MockGetMessagesUsecase();
    mockCreateMessageUsecase = MockCreateMessageUsecase();
    mockUpdateConversationUsecase = MockUpdateConversationUsecase();
    mockSocketService = MockSocketService();

    when(() => mockSocketService.onMessageReceived(any())).thenReturn(null);
    when(() => mockSocketService.sendMessage(any())).thenReturn(null);
  });

  // Dummy test data.
  final tParticipants = Participants(
    id: 'user1',
    username: 'Alice',
    image: ['alice.png'],
  );
  final tConversationDto = ConversationDto(
    id: 'conv1',
    participants: [tParticipants],
    lastMessage: 'Hello',
    title: tParticipants,
    read: 'yes',
  );
  final tConversationList = [tConversationDto];

  final tMessageDto = MessageDTO(
    id: 'msg1',
    conversation: 'conv1',
    sender: UserReference(id: 'user1', username: 'Alice', image: ['alice.png']),
    recipient: UserReference(id: 'user2', username: 'Bob', image: ['bob.png']),
    content: 'Hello Bob',
  );
  final tMessagesList = [tMessageDto];

  final tConnectionDTO = ConnectionDTO(
    id: 'conn1',
    email: 'connection@example.com',
    username: 'connection1',
    image: ['connection.png'],
  );
  final tConnectionsList = [tConnectionDTO];

  group('ConversationBloc - LoadConversations', () {
    blocTest<ConversationBloc, ConversationState>(
      'emits correct states when LoadConversations is added',
      build: () {
        // Stub the getConversations usecase to return our conversation list.
        when(() => mockGetConversationsUsecase.call())
            .thenAnswer((_) => Future.value(Right(tConversationList)));
        return ConversationBloc(
          getConversationUsecase: mockGetConversationsUsecase,
          getConnectionsUsecase: mockGetConnectionsUsecase,
          createConversationUsecase: mockCreateConversationUsecase,
          getMessagesUsecase: mockGetMessagesUsecase,
          createMessageUsecase: mockCreateMessageUsecase,
          socketService: mockSocketService,
          updateConversationUsecase: mockUpdateConversationUsecase,
        );
      },
      // Because the bloc constructor auto-dispatches LoadConversations,
      // we skip the first two emissions.
      skip: 2,
      act: (bloc) => bloc.add(LoadConversations()),
      expect: () => [
        // Our expected states now reflect that the conversation list is already loaded.
        ConversationState.initial().copyWith(
            isSuccess: false, conversation: tConversationList),
        ConversationState.initial().copyWith(
            isLoading: false, isSuccess: true, conversation: tConversationList),
      ],
    );
  });

 
}

