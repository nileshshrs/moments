import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
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

  const LoginUserUsecase({required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async{
    return await userRepository.login(params.username, params.password);
  }
}
