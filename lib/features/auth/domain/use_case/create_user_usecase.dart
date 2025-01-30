import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class CreateUserParams extends Equatable {
  final String email;
  final String username;
  final String password;
  final String? image;
  final bool? verified;

  const CreateUserParams({
    required this.email,
    required this.username,
    required this.password,
    this.image,
    this.verified,
  });

  @override
  List<Object?> get props => [email, username, password, image, verified];
}

class CreateUserUsecase implements UsecaseWithParams<void, CreateUserParams> {
  final IUserRepository userRepository;

  const CreateUserUsecase({required this.userRepository});

  @override
  Future<Either<Failure, void>> call(CreateUserParams params) async {
    // Create the user entity from the params
    final userEntity = UserEntity(
      userId: null, // The ID will be generated automatically by UserHiveModel
      email: params.email,
      username: params.username,
      password: params.password,
      image: null,
      bio: null, // You can pass null or default value here
      verified: params.verified,
    );

    // Call the repository method to create the user
    return await userRepository.createUser(userEntity);
  }
}
