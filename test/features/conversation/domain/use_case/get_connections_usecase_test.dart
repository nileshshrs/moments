// test/features/conversation/domain/usecase/get_connections_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/connection_dto.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';
import 'package:moments/features/conversation/domain/use_case/get_connections_usecase.dart';

/// Create a mock for IConversationRepository.
class MockConversationRepository extends Mock implements IConversationRepository {}

void main() {
  late GetConnectionsUsecase usecase;
  late MockConversationRepository mockRepository;

  setUp(() {
    mockRepository = MockConversationRepository();
    usecase = GetConnectionsUsecase(repository: mockRepository);
  });

  final tConnectionsList = [
    ConnectionDTO(
      id: 'conn1',
      email: 'test@example.com',
      username: 'testuser',
      image: ['https://example.com/image.jpg'],
    )
  ];

  test('should return list of ConnectionDTO when repository.getConnections() succeeds', () async {
    // arrange: stub the repository to return the dummy list.
    when(() => mockRepository.getConnections())
        .thenAnswer((_) async => Right(tConnectionsList));

    // act
    final result = await usecase.call();

    // assert
    expect(result, Right(tConnectionsList));
    verify(() => mockRepository.getConnections()).called(1);
  });
}
