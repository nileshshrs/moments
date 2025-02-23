// test/features/conversation/domain/usecase/get_conversations_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';
import 'package:moments/features/conversation/domain/use_case/get_conversations_usecase.dart';

/// Create a mock for IConversationRepository.
class MockConversationRepository extends Mock implements IConversationRepository {}

void main() {
  late GetConversationsUsecase usecase;
  late MockConversationRepository mockRepository;

  setUp(() {
    mockRepository = MockConversationRepository();
    usecase = GetConversationsUsecase(repository: mockRepository);
  });

  final tConversationList = [
    ConversationDto(
      id: 'conv1',
      participants: [], // Use dummy or appropriate test values.
      lastMessage: 'Hi',
      title: null,
      read: 'false',
    )
  ];

  test('should return list of ConversationDto when repository.getConversation() succeeds', () async {
    // Arrange: Stub getConversation to return Right(tConversationList)
    when(() => mockRepository.getConversation())
        .thenAnswer((_) async => Right(tConversationList));

    // Act
    final result = await usecase.call();

    // Assert
    expect(result, Right(tConversationList));
    verify(() => mockRepository.getConversation()).called(1);
  });
}
