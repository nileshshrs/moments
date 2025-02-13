import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class UpdateUserParams extends Equatable {
  final String email;
  final String username;
  final String? fullname;
  final String? image;
  final String? bio;

  const UpdateUserParams({
    required this.email,
    required this.username,
    this.fullname,
    this.image,
    this.bio,
  });

  @override
  List<Object?> get props => [
        email,
        username,
        fullname,
        image,
        bio,
      ];
}

class UpdateUserUsecase implements UsecaseWithParams {
  final IUserRepository repository;

  const UpdateUserUsecase({required this.repository});
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    final user = UserEntity(
      email: params.email,
      username: params.username,
      fullname: params.fullname,
      image: params.image,
      bio: params.bio,
    );

    return await repository.updateUserProfile(user);
  }
}
