import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/comment_remote_repository.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';

class CreateCommentParams extends Equatable {
  final String postID;
  final String comment;

  const CreateCommentParams({required this.postID, required this.comment});

  @override
  List<Object> get props => [postID, comment];
}

class CreateCommentUsecase implements UsecaseWithParams {
  final CommentRemoteRepository repository;
  const CreateCommentUsecase(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(params) {
    final comment = CommentEntity(post: params.postID, comment: params.comment);
    return repository.createComment(comment);
  }
}
