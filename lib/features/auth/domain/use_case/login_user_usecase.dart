import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/shared_prefs/shared_prefs.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : username = '',
        password = '';

  @override
  List<Object> get props => [username, password];
}

class LoginUserUsecase implements UsecaseWithParams<void, LoginParams> {
  final IUserRepository userRepository;
  final SharedPrefs sharedPrefs;

  const LoginUserUsecase(
      {required this.userRepository, required this.sharedPrefs});

  @override
  @override
  Future<Either<Failure, dynamic>> call(LoginParams params) async {
    return await userRepository.login(params.username, params.password).then(
          (value) => value.fold(
            (failure) => Left(failure),
            (response) async {
              // Save Access Token and wait for it to complete
              await sharedPrefs.saveAccessToken(response.accessToken);

              // Retrieve and correctly extract access token
              final accessTokenResult = await sharedPrefs.getAccessToken();
              accessTokenResult.fold(
                (failure) =>
                    print('Error fetching Access Token: ${failure.message}'),
                (token) => print('Access Token: $token'),
              );

              // Save Refresh Token and wait for it to complete
              await sharedPrefs.saveRefreshToken(response.refreshToken);

              // Retrieve and correctly extract refresh token
              final refreshTokenResult = await sharedPrefs.getRefreshToken();
              refreshTokenResult.fold(
                (failure) =>
                    print('Error fetching Refresh Token: ${failure.message}'),
                (token) => print('Refresh Token: $token'),
              );
              //save user id
              await sharedPrefs.setUserID(response.user.userId);

              //retrieve userID to check
              final userIDResults = await sharedPrefs.getUserID();
              userIDResults.fold(
                (failure) => print('Error fetching userID ${failure.message}'),
                (userID) => print('user id: $userID'),
              );

              return Right(response);
            },
          ),
        );
  }
}
