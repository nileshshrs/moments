// test/features/conversation/domain/usecase/update_conversation_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';
import 'package:moments/features/conversation/domain/use_case/update_conversation_usecase.dart';

/// Create a mock for IConversationRepository.
class MockConversationRepository extends Mock implements IConversationRepository {}

void main() {
  late UpdateConversationUsecase usecase;
  late MockConversationRepository mockRepository;

  setUp(() {
    mockRepository = MockConversationRepository();
    usecase = UpdateConversationUsecase(mockRepository);
  });

  final tId = 'conv1';
  final tParams = UpdateConversationParams(id: tId);

  test('should call repository.updateConversation with the correct id and return Right(null) on success', () async {
    // Arrange
    when(() => mockRepository.updateConversation(tId))
        .thenAnswer((_) async => Right(null));
    
    // Act
    final result = await usecase.call(tParams);
    
    // Assert
    expect(result, Right(null));
    verify(() => mockRepository.updateConversation(tId)).called(1);
  });
}
