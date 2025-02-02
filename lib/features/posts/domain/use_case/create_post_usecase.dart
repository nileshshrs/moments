import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/domain/entity/post_entity.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';

class CreatePostParams extends Equatable {
  final String? content;
  final List<String> image;

  const CreatePostParams({
    this.content,
    required this.image,
  });

  @override
  List<Object?> get props => [content, image];
}

class CreatePostUsecase implements UsecaseWithParams<void, CreatePostParams> {
  final IPostRepository repository;

  CreatePostUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreatePostParams params) {
    final post = PostEntity(content: params.content, image: params.image);

    return repository.createPost(post);
  }
}
