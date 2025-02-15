import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';

class UpdateConversationParams extends Equatable {
  final String id;
  const UpdateConversationParams({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateConversationUsecase implements UsecaseWithParams<void, UpdateConversationParams> {
  final IConversationRepository repository;

  UpdateConversationUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.updateConversation(params.id);
  }
}
