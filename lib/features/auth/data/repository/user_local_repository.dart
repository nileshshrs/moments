import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class UserLocalRepository implements IUserRepository {
  final UserLocalDatasource _UserLocalDataSource;

  UserLocalRepository({required UserLocalDatasource userLocalDataSource})
      : _UserLocalDataSource = userLocalDataSource;

  @override
  Future<Either<Failure, void>> createUser(UserEntity userEntity) {
    try {
      _UserLocalDataSource.createUser(userEntity);
      return Future.value(Right(null));
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await _UserLocalDataSource.deleteUser(id);
      return Right(null);
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUseres() async {
    try {
      final List<UserEntity> users = await _UserLocalDataSource.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
      String username, String password) async {
    try {
      final user = await _UserLocalDataSource.login(username, password);
      return (Right(user));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> updateUserProfile(UserEntity user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, UserEntity>> getUserByID(String id) {
    // TODO: implement getUserByID
    throw UnimplementedError();
  }
}
