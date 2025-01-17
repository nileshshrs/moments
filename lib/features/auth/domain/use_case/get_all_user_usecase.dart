import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';


class GetAllUserUsecase implements UsecaseWithoutParams {
  final IUserRepository userRepository;
  const GetAllUserUsecase({required this.userRepository});
  @override
  Future<Either<Failure, List<UserEntity>>> call() {
    return userRepository.getAllUseres();
  }
}
