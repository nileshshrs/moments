import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';


class DeleteUserParams extends Equatable {
  final String UserId;

  const DeleteUserParams({required this.UserId});

  const DeleteUserParams.empty() : UserId = "_empty.string";

  @override
  List<Object?> get props => [UserId];
}

class DeleteUserUsecase implements UsecaseWithParams<void, DeleteUserParams> {
  final IUserRepository userRepository;

  const DeleteUserUsecase({required this.userRepository});

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return await userRepository.deleteUser(params.UserId);
  }
}