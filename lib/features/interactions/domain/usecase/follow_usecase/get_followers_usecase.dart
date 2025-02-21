import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/follow_remote_repository.dart';

class GetFollowerParams extends Equatable {
  final String id;
  const GetFollowerParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetFollowersUsecase implements UsecaseWithParams {
  final FollowRemoteRepository repository;

  const GetFollowersUsecase(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getUserFollowers(params.id);
  }
}
