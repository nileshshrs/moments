import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class GetUserProfileUsecase implements UsecaseWithoutParams {
  final IUserRepository userRepository;
  const GetUserProfileUsecase({required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call() {
    return userRepository.getUserProfile();
  }
}
