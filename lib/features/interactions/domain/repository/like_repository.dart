import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';

abstract interface class ILikeRepository {
  Future<Either<Failure, void>> toggleLikes(LikeEntity likes);
}
