// test/features/auth/domain/use_case/login_user_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/app/shared_prefs/shared_prefs.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';
import 'package:moments/features/auth/domain/use_case/login_user_usecase.dart';

/// Mock classes for dependencies.
class MockUserRepository extends Mock implements IUserRepository {}
class MockSharedPrefs extends Mock implements SharedPrefs {}

/// Dummy user class with a userId getter.
class DummyUser {
  final String userId;
  DummyUser({required this.userId});
}

/// Dummy login response class, where the user field is a DummyUser.
class DummyLoginResponse {
  final String accessToken;
  final String refreshToken;
  final DummyUser user;
  DummyLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}

void main() {
  late MockUserRepository mockRepository;
  late MockSharedPrefs mockSharedPrefs;
  late LoginUserUsecase usecase;

  // Register fallback for LoginParams (if needed by mocktail).
  setUpAll(() {
    registerFallbackValue(const LoginParams(username: '', password: ''));
  });

  setUp(() {
    mockRepository = MockUserRepository();
    mockSharedPrefs = MockSharedPrefs();
    usecase = LoginUserUsecase(
      userRepository: mockRepository,
      sharedPrefs: mockSharedPrefs,
    );
  });

  final tUsername = 'kiran';
  final tPassword = 'kiran123';
  final tParams = LoginParams(username: tUsername, password: tPassword);

  // Create a dummy login response where the user is a DummyUser.
  final dummyLoginResponse = DummyLoginResponse(
    accessToken: 'mockAccessToken',
    refreshToken: 'mockRefreshToken',
    user: DummyUser(userId: 'user123'),
  );

  test(
      'should call repository.login with correct username and password, '
      'save tokens and userID in SharedPrefs, and return the login response',
      () async {
    // Arrange: Stub repository.login to return a successful response.
    when(() => mockRepository.login(any(), any())).thenAnswer((invocation) async {
      final username = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      if (username == tUsername && password == tPassword) {
        return Right(dummyLoginResponse);
      } else {
        return Left(ApiFailure(message: "login failed", statusCode: 400));
      }
    });

    // Stub SharedPrefs methods.
    when(() => mockSharedPrefs.saveAccessToken(any()))
        .thenAnswer((_) async => Right(null));
    when(() => mockSharedPrefs.getAccessToken())
        .thenAnswer((_) async => Right('mockAccessToken'));
    when(() => mockSharedPrefs.saveRefreshToken(any()))
        .thenAnswer((_) async => Right(null));
    when(() => mockSharedPrefs.getRefreshToken())
        .thenAnswer((_) async => Right('mockRefreshToken'));
    when(() => mockSharedPrefs.setUserID(any()))
        .thenAnswer((_) async => Right(null));
    when(() => mockSharedPrefs.getUserID())
        .thenAnswer((_) async => Right('user123'));

    // Act: Execute the usecase.
    final result = await usecase(tParams);

    // Assert: Verify the response.
    result.fold(
      (failure) => fail('Expected Right but got Left: ${failure.message}'),
      (response) {
        expect(response.accessToken, equals('mockAccessToken'));
        expect(response.refreshToken, equals('mockRefreshToken'));
        // Here, response.user is a DummyUser, so we check its userId.
        expect(response.user.userId, equals('user123'));
      },
    );

    // Verify that the shared preferences methods were called with expected arguments.
    verify(() => mockSharedPrefs.saveAccessToken('mockAccessToken')).called(1);
    verify(() => mockSharedPrefs.getAccessToken()).called(1);
    verify(() => mockSharedPrefs.saveRefreshToken('mockRefreshToken')).called(1);
    verify(() => mockSharedPrefs.getRefreshToken()).called(1);
    verify(() => mockSharedPrefs.setUserID('user123')).called(1);
    verify(() => mockSharedPrefs.getUserID()).called(1);
  });
}
