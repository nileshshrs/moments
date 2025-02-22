import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/follow_remote_repository.dart';

class UnfollowUserParams extends Equatable {
  final String followerID;
  final String followingID;

  const UnfollowUserParams(
      {required this.followerID, required this.followingID});

  @override
  // TODO: implement props
  List<Object?> get props => [followerID, followingID];
}

class UnfollowUserUsecase implements UsecaseWithParams {
  final FollowRemoteRepository repository;

  UnfollowUserUsecase(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.unfollowUser(params.followerID, params.followingID);
  }
}
