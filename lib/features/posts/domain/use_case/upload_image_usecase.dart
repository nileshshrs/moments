import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';

class UploadImageParams {
  final List<File> files;

  const UploadImageParams({required this.files});
}

class UploadImageUsecase
    implements UsecaseWithParams<List<String>, UploadImageParams> {
  final IPostRepository repository;

  UploadImageUsecase(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(UploadImageParams params) {
    return repository.uploadImage(params.files);
  }
}
