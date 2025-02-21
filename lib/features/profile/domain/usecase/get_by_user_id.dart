import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class GetByuserIDParams extends Equatable {
  final String id;

  const GetByuserIDParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetByUserIDUsecase implements UsecaseWithParams {
  final IUserRepository repository;
  const GetByUserIDUsecase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(params) {
    final user = repository.getUserByID(params.id);
    return user;
  }
}
