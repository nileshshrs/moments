// test/features/conversation/domain/usecase/get_messages_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/conversation/data/dto/message_dto.dart';
import 'package:moments/features/conversation/domain/repository/message_repository.dart';
import 'package:moments/features/conversation/domain/use_case/get_messages_usecase.dart';

/// Create a mock for IMessageRepository.
class MockMessageRepository extends Mock implements IMessageRepository {}

void main() {
  late GetMessagesUsecase usecase;
  late MockMessageRepository mockRepository;

  setUp(() {
    mockRepository = MockMessageRepository();
    usecase = GetMessagesUsecase(mockRepository);
  });

  final tId = 'conv1';
  final tParams = GetMessagesParams(id: tId);

  // Dummy MessageDTO list.
  final tMessagesList = [
    MessageDTO(
      id: 'msg1',
      conversation: tId,
      sender: null, // Adjust if needed
      recipient: null, // Adjust if needed
      content: 'Hello',
    ),
    MessageDTO(
      id: 'msg2',
      conversation: tId,
      sender: null,
      recipient: null,
      content: 'World',
    ),
  ];

  test('should return list of MessageDTO when repository.fetchMessages() succeeds', () async {
    // Arrange: Stub repository.fetchMessages to return tMessagesList.
    when(() => mockRepository.fetchMessages(tId))
        .thenAnswer((_) async => Right(tMessagesList));

    // Act
    final result = await usecase.call(tParams);

    // Assert
    expect(result, Right(tMessagesList));
    verify(() => mockRepository.fetchMessages(tId)).called(1);
  });
}
