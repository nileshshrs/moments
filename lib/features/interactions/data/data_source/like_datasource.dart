import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';

abstract interface class ILikeDatasource {
  Future<void> toggleLikes(LikeEntity likes);
  Future<LikeDTO> getPostLikedData(String id);
}
