import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/comment_remote_repository.dart';

class GetCommentsParams extends Equatable {
  final String id;
  const GetCommentsParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetCommentsUsecase implements UsecaseWithParams {
  final CommentRemoteRepository repository;
  const GetCommentsUsecase(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getComments(params.id);
  }
}
