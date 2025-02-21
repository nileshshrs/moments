import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/data/model/user_api_model.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> createUser(UserEntity userEntity);
  Future<Either<Failure, List<UserEntity>>> getAllUseres();
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, dynamic>> login(String username, String password);
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, void>> updateUserProfile(UserEntity user);
  Future<Either<Failure, UserEntity>> getUserByID(String id);
}
