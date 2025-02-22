import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/data_source/remote_data/follow_remote_datasource.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';
import 'package:moments/features/interactions/domain/repository/follow_repository.dart';

class FollowRemoteRepository implements IFollowRepository {
  final FollowRemoteDatasource _followRemoteDatasource;
  FollowRemoteRepository(this._followRemoteDatasource);
  @override
  Future<Either<Failure, List<FollowDTO>>> getUserFollowers(String id) async {
    try {
      final followers = await _followRemoteDatasource.getUserFollowers(id);
      return Right(followers);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowDTO>>> getUserFollowings(String id) async {
    try {
      final followers = await _followRemoteDatasource.getUserFollowings(id);
      return Right(followers);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createFollow(String id) async {
    try {
      await _followRemoteDatasource.createFollow(id);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unfollowUser(
      String followerID, String followingID) async {
    try {
      await _followRemoteDatasource.unfollowUser(followerID, followingID);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
