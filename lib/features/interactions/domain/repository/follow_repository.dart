import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/follow_dto.dart';

abstract interface class IFollowRepository {
  Future<Either<Failure, List<FollowDTO>>> getUserFollowers(String id);
  Future<Either<Failure, List<FollowDTO>>> getUserFollowings(String id);
  Future<Either<Failure, void>> createFollow(String id);
  Future<Either<Failure, void>> unfollowUser(
      String followerID, String followingID);
}
