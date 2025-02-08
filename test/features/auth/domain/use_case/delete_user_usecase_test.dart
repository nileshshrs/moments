import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/use_case/delete_user_usecase.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

// Mock Repository
class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late DeleteUserUsecase usecase;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    usecase = DeleteUserUsecase(userRepository: repository);
  });

  final tUserId = '1';
  final deleteUserParams = DeleteUserParams(UserId: tUserId);

  test('delete user using userId', () async {
    // Arrange
    when(() => repository.deleteUser(any())).thenAnswer(
      (_) async => Right(null),
    );

    // Act
    final result = await usecase(deleteUserParams);

    // Assert
    expect(result, Right(null));

    // Verify
    verify(() => repository.deleteUser(tUserId)).called(1);

    verifyNoMoreInteractions(repository);
  });

  test('delete user and check if the userId is "user1"', () async {
    // Arrange
    when(() => repository.deleteUser(any())).thenAnswer(
      (invocation) async {
        final userId = invocation.positionalArguments[0] as String;

        if (userId == 'user1') {
          return Right(null);
        } else {
          return Left(ApiFailure(
            message: 'User not found',
          ));
        }
      },
    );

    // Act
    final result = await usecase(DeleteUserParams(UserId: 'user1'));

    // Assert
    expect(result, Right(null));

    // Verify
    verify(() => repository.deleteUser('user1')).called(1);

    verifyNoMoreInteractions(repository);
  });
}
