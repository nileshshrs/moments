import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/data/repository/like_remote_repository.dart';

class GetLikesParams extends Equatable {
  final String id;

  const GetLikesParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetLikesUsecase implements UsecaseWithParams {
  LikeRemoteRepository repository;
  GetLikesUsecase(this.repository);
  @override
  Future<Either<Failure, LikeDTO>> call(params) {
    return repository.getPostLikes(params.id);
  }
}
