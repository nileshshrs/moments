import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';

abstract interface class ICommentRepository {
  Future<Either<Failure, CommentDTO>> createComment(CommentEntity comment);
  Future<Either<Failure, List<CommentDTO>>> getComments(String id);
  Future<Either<Failure, void>> deleteComments(String id);
}
