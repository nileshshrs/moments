import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/data_source/remote_data/like_remote_datasource.dart';
import 'package:moments/features/interactions/data/dto/like_dto.dart';
import 'package:moments/features/interactions/domain/entity/like_entity.dart';
import 'package:moments/features/interactions/domain/repository/like_repository.dart';

class LikeRemoteRepository implements ILikeRepository {
  final LikeRemoteDatasource _likeRemoteDatasource;
  LikeRemoteRepository(this._likeRemoteDatasource);

  @override
  Future<Either<Failure, void>> toggleLikes(LikeEntity likes)async {
     try {
      await _likeRemoteDatasource.toggleLikes(likes);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LikeDTO>> getPostLikes(String id)async {
     try {
      final likes= await _likeRemoteDatasource.getPostLikedData(id);
      return Right(likes);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
