import 'package:dartz/dartz.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';
import 'dart:io';

abstract interface class IPostRepository {
  Future<Either<Failure, void>> createPost(PostEntity post);

  Future<Either<Failure, List<String>>> uploadImage(List<File> files);
}
