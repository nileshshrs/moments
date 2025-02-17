import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/posts/data/dto/post_dto.dart';
import 'package:moments/features/posts/domain/repository/post_repository.dart';

class GetPostsByIDParams extends Equatable {
  final String id;

  const GetPostsByIDParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetPostByIdUsecase implements UsecaseWithParams {
  final IPostRepository repository;
  GetPostByIdUsecase(this.repository);
  @override
  Future<Either<Failure, PostDTO>> call(params) {
    final post = repository.getPostByID(params.id);
    return post;
  }
}
