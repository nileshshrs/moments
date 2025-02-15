import 'package:dartz/dartz.dart';
import 'package:moments/app/usecase/usecase.dart';
import 'package:moments/core/error/failure.dart';
import 'package:moments/features/conversation/data/dto/conversation_dto.dart';
import 'package:moments/features/conversation/domain/repository/conversation_repository.dart';

class GetConversationsUsecase implements UsecaseWithoutParams {
  final IConversationRepository repository;
  GetConversationsUsecase({required this.repository});
  @override
  Future<Either<Failure, List<ConversationDto>>> call() {
    return repository.getConversation();
  }
}
