import 'package:moments/features/interactions/data/dto/comment_dto.dart';
import 'package:moments/features/interactions/domain/entity/comment_entity.dart';

abstract interface class ICommentDataSource {
  Future<CommentDTO> createComment(CommentEntity comment);
  Future<List<CommentDTO>> getComments(String id);
  Future<void> deleteComments(String id);
}
