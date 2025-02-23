// test/features/conversation/domain/usecase/create_conversation_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';
import 'package:moments/features/conversation/domain/use_case/create_conversation_usecase.dart';

/// A mock implementation for IConversationRepository.
class MockConversationRepository extends Mock implements IConversationRepository {}

/// A fake ConversationEntity to serve as a fallback for any() calls.
class FakeConversationEntity extends Fake implements ConversationEntity {}

void main() {
  // Register a fallback value for ConversationEntity.
  setUpAll(() {
    registerFallbackValue(FakeConversationEntity());
  });

  late CreateConversationUsecase usecase;
  late MockConversationRepository mockRepository;

  setUp(() {
    mockRepository = MockConversationRepository();
    usecase = CreateConversationUsecase(mockRepository);
  });

  final tUserID = 'user1';
  final tConnectionID = 'user2';
  final tParams = CreateConversationParams(userID: tUserID, connectionID: tConnectionID);

  // The usecase creates a ConversationEntity with participants [userID, connectionID]
  // Dummy ConversationDto to be returned by the repository.
  final tConversationDto = ConversationDto(
    id: 'conv123',
    participants: [], // assume irrelevant for this test
    lastMessage: 'Hello',
    title: null,
    read: 'false',
  );

  test('should call repository.createConversations with proper ConversationEntity and return ConversationDto', () async {
    // Arrange: When repository.createConversations is called with any ConversationEntity,
    // then return Right(tConversationDto).
    when(() => mockRepository.createConversations(any()))
        .thenAnswer((_) async => Right(tConversationDto));
    
    // Act: Call the usecase.
    final result = await usecase.call(tParams);
    
    // Assert: The result should be Right(tConversationDto).
    expect(result, Right(tConversationDto));
    
    // Verify: The repository was called with a ConversationEntity with correct participants.
    verify(() => mockRepository.createConversations(
          any(
            that: predicate<ConversationEntity>((conv) {
              return conv.participants.length == 2 &&
                  conv.participants[0] == tUserID &&
                  conv.participants[1] == tConnectionID;
            }),
          ),
        )).called(1);
  });
}
