import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/like_remote_repository.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';

class ToggleLikeParams extends Equatable {
  final String userID;
  final String postID;

  const ToggleLikeParams({required this.userID, required this.postID});
  @override
  List<Object> get props => [userID, postID];
}

class ToggleLikeUsecase implements UsecaseWithParams {
  final LikeRemoteRepository repository;
  ToggleLikeUsecase(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(params) {
    final likes = LikeEntity(post: params.postID, user: params.userID);

    return repository.toggleLikes(likes);
  }
}
