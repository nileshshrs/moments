import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/entity/conversation_entity.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';

class CreateConversationParams extends Equatable {
  final String userID;
  final String connectionID;
  const CreateConversationParams({
    required this.userID,
    required this.connectionID,
  });
  @override
  List<Object?> get props => [userID, connectionID];
}

class CreateConversationUsecase implements UsecaseWithParams {
  final IConversationRepository repository;
  CreateConversationUsecase(this.repository);

  @override
  Future<Either<Failure, ConversationDto>> call(params) async {
    final conversationEntity =
        ConversationEntity(participants: [params.userID, params.connectionID]);
    return await repository.createConversations(conversationEntity);
  }
}
