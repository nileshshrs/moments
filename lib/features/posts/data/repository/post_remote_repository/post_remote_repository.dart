import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/data_source/remote_datasource/post_remote_datasource.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';

class PostRemoteRepository implements IPostRepository {
  final PostRemoteDatasource _postRemoteDatasource;

  PostRemoteRepository(this._postRemoteDatasource);
  @override
  Future<Either<Failure, void>> createPost(PostEntity post) async {
    try {
      await _postRemoteDatasource.createPosts(post);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImage(List<File> files) async {
    try {
      final images = await _postRemoteDatasource.uploadImages(files);
      return Right(images);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<Either<Failure, List<PostDTO>>> getPosts() async {
    try {
      final posts = await _postRemoteDatasource.getPosts();
      return Right(posts);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostApiModel>>> getPostsByUser() async {
    try {
      final posts = await _postRemoteDatasource.getPostsByUser();
      return Right(posts);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PostDTO>> getPostByID(String id) async {
    try {
      final post = await _postRemoteDatasource.getPostsByID(id);
      return Right(post);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<PostApiModel>>> getPostsByUserID(String id)async {
 try {
      final posts = await _postRemoteDatasource.getPostsByUserID(id);
      return Right(posts);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
