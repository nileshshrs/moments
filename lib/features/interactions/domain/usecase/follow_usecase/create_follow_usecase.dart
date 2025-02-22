import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/interactions/data/repository/follow_remote_repository.dart';

class CreateFollowParams extends Equatable {
  final String id;
  const CreateFollowParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateFollowUsecase implements UsecaseWithParams {
  final FollowRemoteRepository repository;

  CreateFollowUsecase(this.repository);
  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.createFollow(params.id);
  }
}
