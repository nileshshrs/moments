import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';

abstract interface class ILikeRepository {
  Future<Either<Failure, void>> toggleLikes(LikeEntity likes);
  Future<Either<Failure, LikeDTO>> getPostLikes(String id);
}
