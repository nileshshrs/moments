import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';
import 'package:moments/features/auth/domain/use_case/get_all_user_usecase.dart';
import 'package:moments/core/error/failure.dart';

// Mock Repository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository repository;
  late GetAllUserUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = GetAllUserUsecase(userRepository: repository);
  });

  final tUser = UserEntity(
    userId: '1',
    email: 'testuser@example.com',
    username: 'testuser',
    password: 'password123',
    image: null,
    bio: null,
    verified: true,
  );

  final tUser2 = UserEntity(
    userId: '2',
    email: 'testuser2@example.com',
    username: 'testuser2',
    password: 'password123',
    image: null,
    bio: null,
    verified: true,
  );

  final tUsers = [tUser, tUser2];

  test('should get users from repository', () async {
    // Arrange
    when(() => repository.getAllUseres())
        .thenAnswer((_) async => Right(tUsers));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(tUsers));

    // Verify
    verify(() => repository.getAllUseres()).called(1);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    final failure = ApiFailure(message: 'Error fetching users', statusCode: 500);
    when(() => repository.getAllUseres()).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Left(failure));

    // Verify
    verify(() => repository.getAllUseres()).called(1);
  });
}
