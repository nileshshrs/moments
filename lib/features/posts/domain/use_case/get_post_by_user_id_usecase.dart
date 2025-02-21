import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/repository/post_remote_repository/post_remote_repository.dart';

class GetPostByUserIdParams extends Equatable {
  final String id;

  const GetPostByUserIdParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetPostByUserIdUsecase implements UsecaseWithParams {
  final PostRemoteRepository repository;
  GetPostByUserIdUsecase(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getPostsByUserID(params.id);
  }
}
