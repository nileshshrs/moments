import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moments/app/shared_prefs/shared_prefs.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';
import 'package:moments/features/auth/domain/use_case/login_user_usecase.dart';

// Mock classes
class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements SharedPrefs {}

void main() {
  late MockUserRepository repository;
  late MockTokenSharedPrefs tokenSharedPrefs;
  late LoginUserUsecase usecase;

  setUp(() {
    repository = MockUserRepository();
    tokenSharedPrefs = MockTokenSharedPrefs();
    usecase = LoginUserUsecase(
      sharedPrefs: tokenSharedPrefs,
      userRepository: repository,
    );

    // Register fallback values if needed
    registerFallbackValue(LoginParams(username: '', password: ''));
  });

  test(
      'should call the [AuthRepo.loginStudent] with correct username and password and save the access and refresh tokens',
      () async {
    // Mocking the login method
    when(() => repository.login(any(), any())).thenAnswer(
      (invocation) async {
        final username = invocation.positionalArguments[0] as String;
        final password = invocation.positionalArguments[1] as String;
        if (username == 'kiran' && password == 'kiran123') {
          return const Right((
              accessToken: 'mockAccessToken', refreshToken: 'mockRefreshToken'));
        } else {
          return Left(ApiFailure(message: "login failed", statusCode:400 ));
        }
      },
    );

    // Mocking the shared prefs methods
    when(() => tokenSharedPrefs.saveAccessToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getAccessToken())
        .thenAnswer((_) async => const Right('mockAccessToken'));

    when(() => tokenSharedPrefs.saveRefreshToken(any()))
        .thenAnswer((_) async => const Right(null));

    when(() => tokenSharedPrefs.getRefreshToken())
        .thenAnswer((_) async => const Right('mockRefreshToken'));

    // Execute the use case
    final result = await usecase(const LoginParams(username: 'kiran', password: 'kiran123'));

    // Assertions
    result.fold(
      (failure) => fail('Expected Right but got Left: ${failure.message}'),
      (response) {
        expect(response.accessToken, 'mockAccessToken');
        expect(response.refreshToken, 'mockRefreshToken');
      },
    );

    // Verify that shared preferences methods were called
    verify(() => tokenSharedPrefs.saveAccessToken('mockAccessToken')).called(1);
    verify(() => tokenSharedPrefs.getAccessToken()).called(1);
    verify(() => tokenSharedPrefs.saveRefreshToken('mockRefreshToken')).called(1);
    verify(() => tokenSharedPrefs.getRefreshToken()).called(1);
  });
}
