import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/data_source/remote_data/comment_remote_datasource.dart';
import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';
import 'package:moments/features/interactions/domain/repository/comment_repository.dart';

class CommentRemoteRepository implements ICommentRepository {
  final CommentRemoteDatasource commentRemoteDatasource;

  CommentRemoteRepository(this.commentRemoteDatasource);

  @override
  Future<Either<Failure, CommentDTO>> createComment(
      CommentEntity comment) async {
    try {
      final newComment = await commentRemoteDatasource.createComment(comment);
      return Right(newComment);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<CommentDTO>>> getComments(String id)async {
    try {
      final commentList = await commentRemoteDatasource.getComments(id);
      return Right(commentList);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteComments(String id) async{
    try {
       await commentRemoteDatasource.deleteComments(id);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
