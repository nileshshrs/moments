// test/features/auth/domain/usecase/get_by_user_id_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';
import 'package:moments/features/profile/domain/usecase/get_by_user_id.dart';

/// Create a mock for IUserRepository.
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockRepository;
  late GetByUserIDUsecase usecase;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetByUserIDUsecase(mockRepository);
  });

  final tUserId = 'user123';
  final tParams = GetByuserIDParams(id: tUserId);

  // Create a dummy UserEntity.
  const tUserEntity = UserEntity(
    userId: 'user123',
    email: 'test@example.com',
    username: 'testuser',
    // Other fields as required; using null or default values.
    fullname: null,
    password: null,
    verified: null,
    image: null,
    bio: null,
  );

  test('should return UserEntity when repository.getUserByID succeeds', () async {
    // Arrange
    when(() => mockRepository.getUserByID(tUserId))
        .thenAnswer((_) async => Right(tUserEntity));
    // Act
    final result = await usecase.call(tParams);
    // Assert
    expect(result, Right(tUserEntity));
    verify(() => mockRepository.getUserByID(tUserId)).called(1);
  });
}
