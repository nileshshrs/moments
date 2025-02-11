import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/model/post_api_model.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';

class GetPostsByUserUsecase
    implements UsecaseWithoutParams<List<PostApiModel>> {
  final IPostRepository repository;

  GetPostsByUserUsecase({required this.repository});
  @override
  Future<Either<Failure, List<PostApiModel>>> call() async {
    final posts = await repository.getPostsByUser();
    return posts;
  }
}
