import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';

class GetPostsUsecase implements UsecaseWithoutParams<List<PostDTO>> {
  final IPostRepository repository;
  GetPostsUsecase(this.repository);
  @override
  Future<Either<Failure, List<PostDTO>>> call() async {
    final posts = await repository.getPosts();
    
    return posts;
  }
}
