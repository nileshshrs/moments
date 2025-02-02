import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:moments/features/auth/data/dto/login_dto.dart';
import 'package:moments/features/auth/domain/entity/user_entity.dart';
import 'package:moments/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository(this._userRemoteDatasource);
  @override
  Future<Either<Failure, void>> createUser(UserEntity user) async {
    try {
      await _userRemoteDatasource.createUser(user);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 409));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUseres() {
    // TODO: implement getAllUseres
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LoginDto>> login(
      String username, String password) async {
    try {
      final loginDto = await _userRemoteDatasource.login(username, password);

      // print("Raw API Response: ${loginDto.toJson()}"); // Debugging output

      return Right(loginDto);
    } catch (e, stacktrace) {
      // print("Error: $e");
      // print("Stacktrace: $stacktrace"); // Helps debug
      return Left(ApiFailure(message: e.toString(), statusCode: 401));
    }
  }
}
