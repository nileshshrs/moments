import 'package:moments/features/interactions/domain/entity/like_entity.dart';

abstract interface class ILikeDatasource {
  Future<void> toggleLikes(LikeEntity likes);
}
