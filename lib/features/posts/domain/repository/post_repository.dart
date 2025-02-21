import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';

abstract interface class IPostRepository {
  Future<Either<Failure, void>> createPost(PostEntity post);

  Future<Either<Failure, List<String>>> uploadImage(List<File> files);

  Future<Either<Failure, List<PostDTO>>> getPosts();

  Future<Either<Failure, List<PostApiModel>>> getPostsByUser();

  Future<Either<Failure, PostDTO>> getPostByID(String id);

  Future<Either<Failure, List<PostApiModel>>> getPostsByUserID(String id);
}
