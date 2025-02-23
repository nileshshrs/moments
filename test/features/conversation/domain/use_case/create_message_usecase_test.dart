// test/features/conversation/domain/usecase/create_message_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/entity/message_entity.dart';
import 'package:moments/features/conversation/domain/repository/message_repository.dart';
import 'package:moments/features/conversation/domain/use_case/create_message_usecase.dart';

/// Create a mock for IMessageRepository.
class MockMessageRepository extends Mock implements IMessageRepository {}

/// Create a fake MessageEntity to be used as a fallback value.
class FakeMessageEntity extends Fake implements MessageEntity {}

void main() {
  // Register a fallback value for MessageEntity.
  setUpAll(() {
    registerFallbackValue(FakeMessageEntity());
  });

  late CreateMessageUsecase usecase;
  late MockMessageRepository mockRepository;

  setUp(() {
    mockRepository = MockMessageRepository();
    usecase = CreateMessageUsecase(mockRepository);
  });

  final tConversationId = 'conv1';
  final tContent = 'Hello there';
  final tRecipient = 'user2';
  final tParams = CreateMessageParams(
    conversationId: tConversationId,
    content: tContent,
    recipient: tRecipient,
  );

  // The usecase constructs a MessageEntity using the content and recipient from params.
  // Create a dummy MessageDTO to be returned by the repository.
  final tMessageDTO = MessageDTO(
    id: 'msg1',
    conversation: tConversationId,
    sender: null, // Adjust as needed
    recipient: null, // Adjust as needed
    content: tContent,
  );

  test('should call repository.createMessages with proper conversationId and messageEntity and return MessageDTO', () async {
    // Arrange: Stub repository.createMessages to return tMessageDTO.
    when(() => mockRepository.createMessages(any(), any()))
        .thenAnswer((_) async => Right(tMessageDTO));

    // Act
    final result = await usecase.call(tParams);

    // Assert: The result should be Right(tMessageDTO).
    expect(result, Right(tMessageDTO));

    // Verify that the repository was called with:
    // - conversationId equal to tConversationId
    // - a MessageEntity with content and recipient matching tContent and tRecipient.
    verify(() => mockRepository.createMessages(
          tConversationId,
          any(
            that: predicate<MessageEntity>((msg) {
              return msg.content == tContent && msg.recipient == tRecipient;
            }),
          ),
        )).called(1);
  });
}
